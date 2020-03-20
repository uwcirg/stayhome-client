/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';

import 'package:http/http.dart' show Response, get, post, put;
import 'package:map_app_flutter/fhir/FhirResources.dart';

class Repository {
  static final fhirBaseUrl = "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir";

  static Future<Patient> getPatient(String system, String identifier) async {
    print("Attempting to load patient with id: $system|$identifier");
    var patientSearchUrl = "$fhirBaseUrl/Patient?identifier=$system|$identifier";
    var response = await get(patientSearchUrl, headers: {});

    return resultFromResponse(response, "Error loading Patient/$identifier").then((value) {
      var searchResultBundle = jsonDecode(value);
      if (searchResultBundle['total'] > 1) {
        print("more than 1 patient");
        return Future.error("The user ID does not uniquely match a patient resource.");
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
  static Future<CarePlan> getCarePlan(Patient patient, String templateRef) async {
    var url = "$fhirBaseUrl/CarePlan?subject=${patient.reference}";
    var response = await get(url, headers: {});
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
  static Future<CarePlan> loadCarePlan(String reference) async {
    var url = "$fhirBaseUrl/$reference";
    var response = await get(url, headers: {});
    return CarePlan.fromJson(jsonDecode(response.body));
  }

  static Future<List<Procedure>> getProcedures(CarePlan carePlan) async {
    var url = "$fhirBaseUrl/Procedure?based-on=${carePlan.reference}";
    var response = await get(url, headers: {});
    var searchResultBundle = jsonDecode(response.body);
    List<Procedure> procedures = [];
    if (searchResultBundle['total'] > 0) {
      await Future.forEach(searchResultBundle['entry'], (var entry) async {
        procedures.add(Procedure.fromJson(entry['resource']));
      });
    }
    return procedures;
  }

  static Future<List<QuestionnaireResponse>> getQuestionnaireResponses(CarePlan carePlan) async {
    int maxToReturn = 200;
    var url =
        "$fhirBaseUrl/QuestionnaireResponse?based-on=${carePlan.reference}&_count=$maxToReturn&_sort=-authored";
    var response = await get(url, headers: {});
    var searchResultBundle = jsonDecode(response.body);
    List<QuestionnaireResponse> responses = [];
    if (searchResultBundle['total'] > 0) {
      await Future.forEach(searchResultBundle['entry'], (var entry) async {
        responses.add(QuestionnaireResponse.fromJson(entry['resource']));
      });
    }
    return responses;
  }

  static Future<List<DocumentReference>> getResourceLinks(String carePlanTemplateRef) async {
    CarePlan carePlan = await loadCarePlan(carePlanTemplateRef);
    List<Reference> documentReferenceReferences = [];
    for (Activity activity in carePlan.activity) {
      documentReferenceReferences.addAll(activity.detail.reasonReference);
    }
    List<DocumentReference> documentReferences = [];
    await Future.forEach(documentReferenceReferences, (Reference r) async {
      var url = "$fhirBaseUrl/${r.reference}";
      var value = await get(url, headers: {});

      documentReferences.add(DocumentReference.fromJson(jsonDecode(value.body)));
    });
    return documentReferences;
  }

  static Future<Questionnaire> getSimpleQuestionnaire() async {
    var url = 'http://hapi.fhir.org/baseR4/Questionnaire/11723';

    var value = await get(url, headers: {});
    var q = Questionnaire.fromJson(jsonDecode(value.body));
    await q.loadValueSets();
    return q;
  }

  static Future<Questionnaire> getPHQ9Questionnaire() async {
    var url = "$fhirBaseUrl/Questionnaire/52";

    var value = await get(url, headers: {});

    var q = Questionnaire.fromJson(jsonDecode(value.body));
    await q.loadValueSets();
    return q;
  }

  static Future<ValueSet> getValueSet(String address) async {
    var url = "https://r4.ontoserver.csiro.au/fhir/ValueSet/\$expand?url=$address";

    var value = await get(url, headers: {});

    return ValueSet.fromJson(jsonDecode(value.body));
  }

  static Future<void> postCompletedSession(Procedure treatmentSession) async {
    var url = "$fhirBaseUrl/Procedure?_format=json";
    String body = jsonEncode(treatmentSession.toJson());
    var headers = {
      "Accept-Charset": "utf-8",
      "Accept": "application/fhir+json;q=1.0, application/json+fhir;q=0.9",
      "User-Agent": "HAPI-FHIR/3.8.0 (FHIR Client; FHIR 4.0.0/R4; apache)",
      "Accept-Encoding": "gzip",
      "Content-Type": "application/fhir+json; charset=UTF-8",
    };

    Response value =
        await post(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));

    return resultFromResponse(value, "An error occurred when trying to save your responses.");
  }

  static Future<void> postQuestionnaireResponse(QuestionnaireResponse questionnaireResponse) async {
    var url = "$fhirBaseUrl/QuestionnaireResponse?_format=json";
    String body = jsonEncode(questionnaireResponse.toJson());
    var headers = {
      "Accept-Charset": "utf-8",
      "Accept": "application/fhir+json;q=1.0, application/json+fhir;q=0.9",
      "User-Agent": "HAPI-FHIR/3.8.0 (FHIR Client; FHIR 4.0.0/R4; apache)",
      "Accept-Encoding": "gzip",
      "Content-Type": "application/fhir+json; charset=UTF-8",
    };

    Response value =
        await post(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));

    return resultFromResponse(value, "An error occurred when trying to save your responses.");
  }

  static Future<Questionnaire> getQuestionnaire(String questionnaireReference) async {
    var url = "$fhirBaseUrl/$questionnaireReference";

    var value = await get(url, headers: {});

    var q = Questionnaire.fromJson(jsonDecode(value.body));
    await q.loadValueSets();
    return q;
  }

  /// get all questionnaires instantiated by activities in this CarePlan
  static Future<List<Questionnaire>> getQuestionnaires(CarePlan carePlan) async {
    List<Questionnaire> questionnaires = [];
    await Future.forEach(carePlan.activity, (var activity) async {
      if (activity.detail.instantiatesCanonical != null) {
        for (String instantiatesReference in activity.detail.instantiatesCanonical) {
          if (instantiatesReference.startsWith("Questionnaire")) {
            Questionnaire q = await getQuestionnaire(instantiatesReference);
            questionnaires.add(q);
          }
        }
      }
    });
    return questionnaires;
  }

  static Future postCarePlan(CarePlan plan) async {
    var url = "$fhirBaseUrl/CarePlan?_format=json";
    String body = jsonEncode(plan.toJson());
    var headers = {
      "Accept-Charset": "utf-8",
      "Accept": "application/fhir+json;q=1.0, application/json+fhir;q=0.9",
      "User-Agent": "HAPI-FHIR/3.8.0 (FHIR Client; FHIR 4.0.0/R4; apache)",
      "Accept-Encoding": "gzip",
      "Content-Type": "application/fhir+json; charset=UTF-8",
    };

    Response response =
        await post(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
    return resultFromResponse(response, "Creating care plan failed");
  }

  static Future updateCarePlan(CarePlan plan) async {
    var url = "$fhirBaseUrl/CarePlan/${plan.id}?_format=json";
    String body = jsonEncode(plan.toJson());
    var headers = {
      "Accept-Charset": "utf-8",
      "Accept": "application/fhir+json;q=1.0, application/json+fhir;q=0.9",
      "User-Agent": "HAPI-FHIR/3.8.0 (FHIR Client; FHIR 4.0.0/R4; apache)",
      "Accept-Encoding": "gzip",
      "Content-Type": "application/fhir+json; charset=UTF-8",
    };

    Response response =
        await put(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
    return resultFromResponse(response, "Updating care plan failed");
  }

  static Future postPatient(Patient patient) async {
    String body = jsonEncode(patient.toJson());
    var headers = {
      "Accept-Charset": "utf-8",
      "Accept": "application/fhir+json;q=1.0, application/json+fhir;q=0.9",
      "User-Agent": "HAPI-FHIR/3.8.0 (FHIR Client; FHIR 4.0.0/R4; apache)",
      "Accept-Encoding": "gzip",
      "Content-Type": "application/fhir+json; charset=UTF-8",
    };

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
}
