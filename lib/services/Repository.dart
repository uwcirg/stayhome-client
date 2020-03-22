/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';
import 'dart:io' show HttpHeaders;

import 'package:http/http.dart' show Response, get, post, put;
import 'package:map_app_flutter/fhir/FhirResources.dart';

class Repository {
  static String fhirBaseUrl;

  static void init(String fhirBaseUrl) {
    Repository.fhirBaseUrl = fhirBaseUrl;
  }

  static Future<Patient> getPatient(String system, String identifier, String authToken) async {
    print("Attempting to load patient with id: $system|$identifier");
    var patientSearchUrl = "$fhirBaseUrl/Patient?identifier=$system|$identifier";
    var response = await get(patientSearchUrl, headers: _defaultShortHeaders(authToken));

    return resultFromResponse(response, "Error loading Patient/$identifier").then((value) {
      var searchResultBundle = jsonDecode(value);
      if (searchResultBundle['total'] > 1) {
        String patientsIds = searchResultBundle['entry']
            .map((entry) => "${entry['resource']['resourceType']}/${entry['resource']['id']}")
            .toList()
            .join("\n");
        print("Multiple patients match:\n$patientsIds");
        return Future.error(
            "The user ID does not uniquely match a patient resource. Please contact an administrator.");
      }
      if (searchResultBundle['total'] == 0) {
        print("no patient");
        return null;
      }
      print("found patient");
      return Patient.fromJson(searchResultBundle['entry'][0]['resource']);
    });
  }

  static Future resultFromResponse(Response response, String defaultErrorMessage) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.reasonPhrase == "Created") {
        var resource = jsonDecode(response.body);
        print("Created record: ${resource['resourceType']}/${resource['id']}");
      }
      return Future.value(response.body);
    } else {
      var message;
      try {
        message = jsonDecode(response.body)['issue'][0]['diagnostics'];
      } catch (e) {
        message = defaultErrorMessage;
      }
      print(message);
      return Future.error(message);
    }
  }

  /// Get the first returned CarePlan for the given patient.
  static Future<CarePlan> getCarePlan(Patient patient, String templateRef, String authToken) async {
    var url = "$fhirBaseUrl/CarePlan?subject=${patient.reference}";
    var response = await get(url, headers: _defaultShortHeaders(authToken));
    var searchResultBundle = jsonDecode(response.body);
    if (searchResultBundle["total"] == 0) {
      return null;
    } else {
      List<CarePlan> carePlansForPatient = [];
      searchResultBundle['entry'].forEach((v) {
        carePlansForPatient.add(CarePlan.fromJson(v['resource']));
      });
      // return the first active careplan with the correct template
      return carePlansForPatient.firstWhere(
          (CarePlan plan) =>
              plan.basedOn != null &&
              plan.basedOn.any((Reference reference) => reference.reference == templateRef) &&
              plan.status == CarePlanStatus.active &&
              plan.period.start.isBefore(DateTime.now()) &&
              plan.period.end.isAfter(DateTime.now()),
          orElse: () => null);
    }
  }

  /// reference should be of format CarePlan/123
  static Future<CarePlan> loadCarePlan(String reference, String authToken) async {
    var url = "$fhirBaseUrl/$reference";
    var response = await get(url, headers: _defaultShortHeaders(authToken));
    return CarePlan.fromJson(jsonDecode(response.body));
  }

  static Future<List<Procedure>> getProcedures(CarePlan carePlan, String authToken) async {
    var url = "$fhirBaseUrl/Procedure?based-on=${carePlan.reference}";
    var response = await get(url, headers: _defaultShortHeaders(authToken));
    var searchResultBundle = jsonDecode(response.body);
    List<Procedure> procedures = [];
    if (searchResultBundle['total'] > 0) {
      await Future.forEach(searchResultBundle['entry'], (var entry) async {
        procedures.add(Procedure.fromJson(entry['resource']));
      });
    }
    return procedures;
  }

  static Future<List<QuestionnaireResponse>> getQuestionnaireResponses(
      CarePlan carePlan, String authToken) async {
    int maxToReturn = 200;
    var url =
        "$fhirBaseUrl/QuestionnaireResponse?based-on=${carePlan.reference}&_count=$maxToReturn&_sort=-authored";
    var response = await get(url, headers: _defaultShortHeaders(authToken));
    var searchResultBundle = jsonDecode(response.body);
    List<QuestionnaireResponse> responses = [];
    if (searchResultBundle['total'] > 0) {
      await Future.forEach(searchResultBundle['entry'], (var entry) async {
        responses.add(QuestionnaireResponse.fromJson(entry['resource']));
      });
    }
    return responses;
  }

  static Future<List<DocumentReference>> getResourceLinks(
      String carePlanTemplateRef, String authToken) async {
    CarePlan carePlan = await loadCarePlan(carePlanTemplateRef, authToken);
    if (carePlan == null) return Future.error("Could not load info links");
    List<Reference> documentReferenceReferences = [];
    for (Activity activity in carePlan.activity) {
      documentReferenceReferences.addAll(activity.detail.reasonReference);
    }
    List<DocumentReference> documentReferences = [];
    await Future.forEach(documentReferenceReferences, (Reference r) async {
      var url = "$fhirBaseUrl/${r.reference}";
      var value = await get(url, headers: _defaultShortHeaders(authToken));

      documentReferences.add(DocumentReference.fromJson(jsonDecode(value.body)));
    });
    return documentReferences;
  }

  static Future<Questionnaire> getSimpleQuestionnaire(String authToken) async {
    var url = 'http://hapi.fhir.org/baseR4/Questionnaire/11723';

    var value = await get(url, headers: _defaultShortHeaders(authToken));
    var q = Questionnaire.fromJson(jsonDecode(value.body));
    await q.loadValueSets();
    return q;
  }

  static Future<Questionnaire> getPHQ9Questionnaire(String authToken) async {
    var url = "$fhirBaseUrl/Questionnaire/52";

    var value = await get(url, headers: _defaultShortHeaders(authToken));

    var q = Questionnaire.fromJson(jsonDecode(value.body));
    await q.loadValueSets();
    return q;
  }

  static Future<ValueSet> getValueSet(String address) async {
    var url = "https://r4.ontoserver.csiro.au/fhir/ValueSet/\$expand?url=$address";

    var value = await get(url, headers: {});

    return ValueSet.fromJson(jsonDecode(value.body));
  }

  static Future<void> postCompletedSession(Procedure treatmentSession, String authToken) async {
    var url = "$fhirBaseUrl/Procedure?_format=json";
    String body = jsonEncode(treatmentSession.toJson());
    var headers = _defaultFullHeaders(authToken);

    Response value =
        await post(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));

    return resultFromResponse(value, "An error occurred when trying to save your responses.");
  }

  static Future<void> postQuestionnaireResponse(
      QuestionnaireResponse questionnaireResponse, String authToken) async {
    var url = "$fhirBaseUrl/QuestionnaireResponse?_format=json";
    String body = jsonEncode(questionnaireResponse.toJson());
    var headers = _defaultFullHeaders(authToken);

    Response value =
        await post(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));

    return resultFromResponse(value, "An error occurred when trying to save your responses.");
  }

  static Future<Questionnaire> getQuestionnaire(
      String questionnaireReference, String authToken) async {
    var url = "$fhirBaseUrl/$questionnaireReference";

    var value = await get(url, headers: _defaultShortHeaders(authToken));

    var q = Questionnaire.fromJson(jsonDecode(value.body));
    await q.loadValueSets();
    return q;
  }

  /// get all questionnaires instantiated by activities in this CarePlan
  static Future<List<Questionnaire>> getQuestionnaires(CarePlan carePlan, String authToken) async {
    List<Questionnaire> questionnaires = [];
    await Future.forEach(carePlan.activity, (var activity) async {
      if (activity.detail.instantiatesCanonical != null) {
        for (String instantiatesReference in activity.detail.instantiatesCanonical) {
          if (instantiatesReference.startsWith("Questionnaire")) {
            Questionnaire q = await getQuestionnaire(instantiatesReference, authToken);
            questionnaires.add(q);
          }
        }
      }
    });
    return questionnaires;
  }
  /// get all communication records which are active and pertinent
  static Future<List<Communication>> getCommunications(Patient patient, String authToken) async {
    int maxToReturn = 200;
    String status = "in-progress";
    var url =
        "$fhirBaseUrl/Communication?recipient=${patient.reference}&status=$status&_count=$maxToReturn";
    var response = await get(url, headers: _defaultShortHeaders(authToken));
    var searchResultBundle = jsonDecode(response.body);
    List<Communication> responses = [];
    if (searchResultBundle['total'] > 0) {
      await Future.forEach(searchResultBundle['entry'], (var entry) async {
        responses.add(Communication.fromJson(entry['resource']));
      });
    }
    return responses;
  }

  static Future<void> updateCommunication(
      Communication communication, String authToken) async {
    var url = "$fhirBaseUrl/Communication/${communication.id}?_format=json";
    String body = jsonEncode(communication.toJson());
    var headers = _defaultFullHeaders(authToken);

    Response value =
    await put(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));

    return resultFromResponse(value, "An error occurred when trying to update the communication.");
  }

  static Future postCarePlan(CarePlan plan, String authToken) async {
    var url = "$fhirBaseUrl/CarePlan?_format=json";
    String body = jsonEncode(plan.toJson());
    var headers = _defaultFullHeaders(authToken);

    Response response =
        await post(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
    return resultFromResponse(response, "Creating care plan failed");
  }

  static Future updateCarePlan(CarePlan plan, String authToken) async {
    var url = "$fhirBaseUrl/CarePlan/${plan.id}?_format=json";
    String body = jsonEncode(plan.toJson());
    var headers = _defaultFullHeaders(authToken);

    Response response =
        await put(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
    return resultFromResponse(response, "Updating care plan failed");
  }

  static Future postPatient(Patient patient, String authToken) async {
    String body = jsonEncode(patient.toJson());
    var headers = _defaultFullHeaders(authToken);

    Response response;
    if (patient.id != null && patient.id.length > 0) {
      var url = "$fhirBaseUrl/Patient/${patient.id}?_format=json";
      response =
          await put(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
    } else {
      var url = "$fhirBaseUrl/Patient?_format=json";
      response =
          await post(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
    }
    return resultFromResponse(response, "Saving patient failed");
  }

  static Map<String, String> _defaultShortHeaders(String authToken) =>
      {HttpHeaders.authorizationHeader: "Bearer " + authToken};

  static Map<String, String> _defaultFullHeaders(String authToken) {
    return {
      HttpHeaders.acceptCharsetHeader: "utf-8",
      HttpHeaders.acceptHeader: "application/fhir+json;q=1.0, application/json+fhir;q=0.9",
      HttpHeaders.userAgentHeader: "HAPI-FHIR/3.8.0 (FHIR Client; FHIR 4.0.0/R4; apache)",
      HttpHeaders.acceptEncodingHeader: "gzip",
      HttpHeaders.contentTypeHeader: "application/fhir+json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + authToken,
    };
  }
}
