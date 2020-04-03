/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */
import 'dart:convert';
import 'dart:io' show HttpHeaders;

import 'package:http/http.dart' show get;
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:simple_auth/simple_auth.dart' show HttpMethod, OAuthApi, Request, Response;

class Repository {
  static String fhirBaseUrl;

  static void init(String fhirBaseUrl) {
    Repository.fhirBaseUrl = fhirBaseUrl;
  }

  static Future<Patient> getPatient(String system, String identifier, OAuthApi api) async {
    print("Attempting to load patient with id: $system|$identifier");
    var patientSearchUrl = "$fhirBaseUrl/Patient";
    var request = new Request(HttpMethod.Get, patientSearchUrl,
        headers: _defaultHeaders(), parameters: {"identifier": "$system|$identifier"});
    var response = await api.send<String>(request);
//    var response = await get(patientSearchUrl, headers: _defaultHeaders(authToken));

    if (response.statusCode == 200) {
      var searchResultBundle = jsonDecode(response.body);
      // multiple patients
      if (searchResultBundle['total'] > 1) {
        String patientsIds = searchResultBundle['entry']
            .map((entry) => "${entry['resource']['resourceType']}/${entry['resource']['id']}")
            .toList()
            .join("\n");
        print("Multiple patients match:\n$patientsIds");
        return Future.error(
            "The user ID does not uniquely match a patient resource. Please contact an administrator.");
      }
      // no patients
      if (searchResultBundle['total'] == 0) {
        print("no patient");
        return null;
      }
      // found exactly one patient!
      var entry = searchResultBundle['entry'][0];
      print("Found patient: ${entry['resource']['resourceType']}/${entry['resource']['id']}");
      return Patient.fromJson(entry['resource']);
    } else {
      print("Status code: ${response.statusCode}");
      return Future.error("Could not load patient");
    }
  }

  static Future<Patient> postPatient(Patient patient, OAuthApi api) async {
    String body = jsonEncode(patient.toJson());
    var headers = _defaultHeaders();

    var response;
    if (patient.id != null && patient.id.length > 0) {
      var url = "$fhirBaseUrl/Patient/${patient.id}";
      var request = new Request(HttpMethod.Put, url, body: body, headers: headers);
      response = await api.send<String>(request);
//      response =
//      await put(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
    } else {
      var url = "$fhirBaseUrl/Patient";
      var request = new Request(HttpMethod.Post, url, body: body, headers: headers);
      response = await api.send<String>(request);
//      response =
//      await post(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
    }
    String result = await resultFromResponse(response, "Saving patient failed");
    return Patient.fromJson(jsonDecode(result));
  }

  /// Use only when we don't care about the response other than whether it succeeded. E.g. when
  /// posting a new resource  - in that case, we just want to reload everything.
  static Future<String> resultFromResponse(Response response, String defaultErrorMessage) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.base.reasonPhrase == "Created") {
        var resource = jsonDecode(response.body);
        print("Created record: ${resource['resourceType']}/${resource['id']}");
      }
      return Future.value(response.body);
    } else {
      print("Status code: ${response.statusCode} ${response.base.reasonPhrase}");
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
  static Future<CarePlan> getCarePlan(Patient patient, String templateRef, OAuthApi api) async {
    var url = "$fhirBaseUrl/CarePlan";
    var request = new Request(HttpMethod.Get, url,
        parameters: {"subject": "${patient.reference}"}, headers: _defaultHeaders());
    var response = await api.send<String>(request);
//    var response = await get(url, headers: _defaultHeaders(authToken));
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

  static Future<List<Procedure>> getProcedures(CarePlan carePlan, OAuthApi api) async {
    var url = "$fhirBaseUrl/Procedure";
    var request = new Request(HttpMethod.Get, url,
        parameters: {"based-on": "${carePlan.reference}"}, headers: _defaultHeaders());
    var response = await api.send<String>(request);
//    var response = await get(url, headers: _defaultHeaders(authToken));
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
      CarePlan carePlan, api) async {
    int maxToReturn = 200;
    var url = "$fhirBaseUrl/QuestionnaireResponse";
    var request = new Request(HttpMethod.Get, url,
        parameters: {
          "based-on": "${carePlan.reference}",
          "_count": "$maxToReturn",
          "_sort": "-authored"
        },
        headers: _defaultHeaders());
    var response = await api.send<String>(request);
//    var response = await get(url, headers: _defaultHeaders(authToken));
    var searchResultBundle = jsonDecode(response.body);
    List<QuestionnaireResponse> responses = [];
    if (searchResultBundle['total'] > 0) {
      await Future.forEach(searchResultBundle['entry'], (var entry) async {
        responses.add(QuestionnaireResponse.fromJson(entry['resource']));
      });
    }
    return responses;
  }

  static Future<List<DocumentReference>> getResourceLinks(String carePlanTemplateRef, api) async {
    CarePlan carePlan;
    try {
      carePlan = await loadCarePlan(carePlanTemplateRef, api, authenticated: false);
    } catch (e) {
      print('$e');
      return Future.error("Could not load info resource: $e");
    }
    if (carePlan == null) return Future.error("Could not load info resource");
    List<Reference> documentReferenceReferences = [];
    for (Activity activity in carePlan.activity) {
      if (activity.detail.reasonReference != null) {
        documentReferenceReferences.addAll(activity.detail.reasonReference);
      }
    }
    List<DocumentReference> documentReferences = [];
    await Future.forEach(documentReferenceReferences, (Reference r) async {
      var url = "$fhirBaseUrl/${r.reference}";
      var request = new Request(HttpMethod.Get, url, headers: _defaultHeaders(), authenticated: false);
      var response = await api.send<String>(request);
//      var value = await get(url, headers: _defaultHeaders(authToken));

      documentReferences.add(DocumentReference.fromJson(jsonDecode(response.body)));
    });
    return documentReferences;
  }

  static Future<ValueSet> getValueSet(String address) async {
    var url = "https://r4.ontoserver.csiro.au/fhir/ValueSet/\$expand?url=$address";

    var value = await get(url, headers: {});

    return ValueSet.fromJson(jsonDecode(value.body));
  }

  static Future<void> postCompletedSession(Procedure treatmentSession, OAuthApi api) async {
    var url = "$fhirBaseUrl/Procedure";
    String body = jsonEncode(treatmentSession.toJson());
    var headers = _defaultHeaders();
    var request = new Request(HttpMethod.Put, url, body: body, headers: headers);
    var response = await api.send<String>(request);
//    Response value =
//    await post(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));

    return resultFromResponse(response, "An error occurred when trying to save your responses. Please try logging in again.");
  }

  static Future<QuestionnaireResponse> postQuestionnaireResponse(
      QuestionnaireResponse questionnaireResponse, OAuthApi api) async {
    String result;
    try {
      result = await postResource(questionnaireResponse, api);
    } catch (e) {
      print('$e');
      return Future.error("An error occurred when trying to save your responses. Please try logging in again.");
    }
    QuestionnaireResponse postedResponse = QuestionnaireResponse.fromJson(jsonDecode(result));
    print("Created ${postedResponse.reference}");
    return postedResponse;
  }

  static Future<Questionnaire> getQuestionnaire(String questionnaireReference, OAuthApi api) async {
    var url = "$fhirBaseUrl/$questionnaireReference";
    var request = new Request(HttpMethod.Get, url, headers: _defaultHeaders());
    var response = await api.send<String>(request);
//    var value = await get(url, headers: _defaultHeaders(authToken));

    var q = Questionnaire.fromJson(jsonDecode(response.body));
    await q.loadValueSets();
    return q;
  }

  /// get all questionnaires instantiated by activities in this CarePlan
  static Future<List<Questionnaire>> getQuestionnaires(CarePlan carePlan, OAuthApi api) async {
    List<Questionnaire> questionnaires = [];
    await Future.forEach(carePlan.activity, (var activity) async {
      if (activity.detail.instantiatesCanonical != null) {
        for (String instantiatesReference in activity.detail.instantiatesCanonical) {
          if (instantiatesReference.startsWith("Questionnaire")) {
            Questionnaire q = await getQuestionnaire(instantiatesReference, api);
            questionnaires.add(q);
          }
        }
      }
    });
    return questionnaires;
  }

  /// get all communication records which are active and pertinent
  static Future<List<Communication>> getCommunications(Patient patient, OAuthApi api) async {
    int maxToReturn = 200;
    var url = "$fhirBaseUrl/Communication";
    var request = new Request(HttpMethod.Get, url,
        parameters: {
          "recipient": "${patient.reference}",
          "_count": "$maxToReturn",
          "_sort": "sent"
        },
        headers: _defaultHeaders());
    var response = await api.send<String>(request);
//    var response = await get(url, headers: _defaultHeaders(authToken));
    var searchResultBundle = jsonDecode(response.body);
    List<Communication> responses = [];
    if (searchResultBundle['total'] > 0) {
      await Future.forEach(searchResultBundle['entry'], (var entry) async {
        responses.add(Communication.fromJson(entry['resource']));
      });
    }
    return responses;
  }

  /// reference should be of format CarePlan/123
  static Future<CarePlan> loadCarePlan(String reference, OAuthApi api, {bool authenticated=true}) async {
    var url = "$fhirBaseUrl/$reference";
    var request = new Request(HttpMethod.Get, url, headers: _defaultHeaders(), authenticated: authenticated);
    var response = await api.send<String>(request);
    if (response.statusCode == 200) {
      print("Loaded careplan");
      return CarePlan.fromJson(jsonDecode(response.body));
    } else {
      print("Status code: ${response.statusCode}");
      return Future.error("Could not load care plan");
    }
  }

  /// reference should be of format Communication/123
  static Future<Communication> loadCommunication(String id, OAuthApi api) async {
    var url = "$fhirBaseUrl/Communication/$id";
    var request = new Request(HttpMethod.Get, url, headers: _defaultHeaders());
    var response = await api.send<String>(request);

//    var response = await get(url, headers: _defaultHeaders(authToken));
    if (response.statusCode == 200) {
//      return response.body;
      return Communication.fromJson(jsonDecode(response.body));
    } else {
      print('$response');
//      print("Status code: ${response.statusCode} ${response.reasonPhrase}");
      return Future.error("Could not load communication");
    }
  }

//  /// reference should be of format Communication/123
//  static Future<Communication> loadCommunication(String reference, String authToken) async {
//    var url = "$fhirBaseUrl/$reference";
//    var response = await get(url, headers: _defaultHeaders(authToken));
//    if (response.statusCode == 200) {
//      return Communication.fromJson(jsonDecode(response.body));
//    } else {
//      print("Status code: ${response.statusCode} ${response.reasonPhrase}");
//      return Future.error("Could not load communication");
//    }
//  }

  static Future<String> postResource(Resource resource, OAuthApi api) async {
    var url = "$fhirBaseUrl/${resource.resourceType}";
    String body = jsonEncode(resource.toJson());
    var headers = _defaultHeaders();
    var request = new Request(HttpMethod.Post, url, body: body, headers: headers);
    var response = await api.send<String>(request);
//    Response response =
//        await post(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));

    return resultFromResponse(response, "Creating ${resource.resourceType} failed");
  }

  static Future<CarePlan> postCarePlan(CarePlan carePlan, OAuthApi api) async {
    String result = await postResource(carePlan, api);
    return CarePlan.fromJson(jsonDecode(result));
  }

  static Future<Communication> postCommunication(Communication comm, OAuthApi api) async {
    String result = await postResource(comm, api);
    return Communication.fromJson(jsonDecode(result));
  }

  static Future<String> updateResource(Resource resource, OAuthApi api) async {
    var url = "$fhirBaseUrl/${resource.resourceType}/${resource.id}";
    String body = jsonEncode(resource.toJson());
    var headers = _defaultHeaders();
    var request = new Request(HttpMethod.Put, url, body: body, headers: headers);
    var response = await api.send<String>(request);
//    Response response =
//        await put(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
    return resultFromResponse(response, "Updating ${resource.reference} failed");
  }

  static Future<CarePlan> updateCarePlan(CarePlan carePlan, OAuthApi api) async {
    String result = await updateResource(carePlan, api);
    return CarePlan.fromJson(jsonDecode(result));
  }

  static Future<Communication> updateCommunication(Communication comm, OAuthApi api) async {
    String result = await updateResource(comm, api);
    return Communication.fromJson(jsonDecode(result));
  }

  static Map<String, String> _defaultHeaders() {
    return {
      HttpHeaders.cacheControlHeader: "no-cache",
      HttpHeaders.acceptHeader: 'application/json',
//      HttpHeaders.authorizationHeader: "Bearer $authToken",
      HttpHeaders.contentTypeHeader: 'application/json'
    };
  }
}
