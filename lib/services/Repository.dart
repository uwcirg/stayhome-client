/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';

import 'package:http/http.dart' show Response, get, post;
import 'package:map_app_flutter/fhir/FhirResources.dart';

class Repository {
  static Future<Patient> getPatient(String patientResourceId) async {
    if (patientResourceId == null) {
      var system = "http://hospital.smarthealthit.org";
      var identifier = "fb538307-c13a-4605-9b7f-f9689654392a"; // MRN
      var patientSearchUrl =
          "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/Patient?identifier=$system|$identifier";
      var response = await get(patientSearchUrl, headers: {});
      var searchResultBundle = jsonDecode(response.body);
      patientResourceId = searchResultBundle['entry'][0]['resource']['id'];
    }
    var patientLoadUrl =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/Patient/$patientResourceId";
    var response = await get(patientLoadUrl, headers: {});
    if (response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body));
    } else {
      var message;
      try {
        message = jsonDecode(response.body)['issue'][0]['diagnostics'];
      } catch (e) {
        message = "Error loading Patient/$patientResourceId";
      }
      return Future.error(message);
    }
  }

  /// Get the first returned CarePlan for the given patient.
  static Future<CarePlan> getCarePlan(Patient patient) async {
    var url =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/CarePlan?subject=${patient.reference}";
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
      return carePlansForPatient.firstWhere((CarePlan plan) =>
          plan.basedOn != null &&
          plan.basedOn.any(
              (Reference reference) => reference.reference == "CarePlan/54") &&
          plan.status == CarePlanStatus.active &&
          plan.period.start.isBefore(DateTime.now()) &&
          plan.period.end.isAfter(DateTime.now())
      , orElse: () => null);
    }
  }

  static Future<CarePlan> loadCarePlan(String id) async {
    var url =
    "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/CarePlan/$id";
    var response = await get(url, headers: {});
    return CarePlan.fromJson(jsonDecode(response.body));
  }

  static Future<List<Procedure>> getProcedures(CarePlan carePlan) async {
    var url =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/Procedure?based-on=${carePlan.reference}";
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

  static Future<List<QuestionnaireResponse>> getQuestionnaireResponses(
      CarePlan carePlan) async {
    var url =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/QuestionnaireResponse?based-on=${carePlan.reference}";
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

  static Future<Questionnaire> getSimpleQuestionnaire() async {
    var url = 'http://hapi.fhir.org/baseR4/Questionnaire/11723';

    var value = await get(url, headers: {});
    var q = Questionnaire.fromJson(jsonDecode(value.body));
    await q.loadValueSets();
    return q;
  }

  static Future<Questionnaire> getPHQ9Questionnaire() async {
    var url =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/Questionnaire/52";

    var value = await get(url, headers: {});

    var q = Questionnaire.fromJson(jsonDecode(value.body));
    await q.loadValueSets();
    return q;
  }

  static Future<ValueSet> getValueSet(String address) async {
    var url =
        "https://r4.ontoserver.csiro.au/fhir/ValueSet/\$expand?url=$address";

    var value = await get(url, headers: {});

    return ValueSet.fromJson(jsonDecode(value.body));
  }

  static Future<Response> postQuestionnaireResponse(
      QuestionnaireResponse questionnaireResponse) async {
    var url =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/QuestionnaireResponse?_format=json";
    String body = jsonEncode(questionnaireResponse.toJson());
    var headers = {
      "Accept-Charset": "utf-8",
      "Accept": "application/fhir+json;q=1.0, application/json+fhir;q=0.9",
      "User-Agent": "HAPI-FHIR/3.8.0 (FHIR Client; FHIR 4.0.0/R4; apache)",
      "Accept-Encoding": "gzip",
      "Content-Type": "application/fhir+json; charset=UTF-8",
    };

    return await post(url,
        headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
  }

  static Future<Questionnaire> getQuestionnaire(
      String questionnaireReference) async {
    var url =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/$questionnaireReference";

    var value = await get(url, headers: {});

    var q = Questionnaire.fromJson(jsonDecode(value.body));
    await q.loadValueSets();
    return q;
  }

  /// get all questionnaires instantiated by activities in this CarePlan
  static Future<List<Questionnaire>> getQuestionnaires(
      CarePlan carePlan) async {
    List<Questionnaire> questionnaires = [];
    await Future.forEach(carePlan.activity, (var activity) async {
      if (activity.detail.instantiatesCanonical != null) {
        for (String instantiatesReference
            in activity.detail.instantiatesCanonical) {
          if (instantiatesReference.startsWith("Questionnaire")) {
            Questionnaire q = await getQuestionnaire(instantiatesReference);
            questionnaires.add(q);
          }
        }
      }
    });
    return questionnaires;
  }

  static Future<Response> postCarePlan(CarePlan plan) async {
    var url =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/CarePlan?_format=json";
    String body = jsonEncode(plan.toJson());
    var headers = {
      "Accept-Charset": "utf-8",
      "Accept": "application/fhir+json;q=1.0, application/json+fhir;q=0.9",
      "User-Agent": "HAPI-FHIR/3.8.0 (FHIR Client; FHIR 4.0.0/R4; apache)",
      "Accept-Encoding": "gzip",
      "Content-Type": "application/fhir+json; charset=UTF-8",
    };

    return await post(url,
        headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
  }
}
