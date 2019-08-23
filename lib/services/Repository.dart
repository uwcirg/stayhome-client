/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';

import 'package:http/http.dart' show Response, get, post;
import 'package:map_app_flutter/fhir/FhirResources.dart';

class Repository {
  static Future<Patient> getPatient() async {
    var system = "http://hospital.smarthealthit.org";
    var identifier = "fb538307-c13a-4605-9b7f-f9689654392a"; // MRN
    var patientSearchUrl =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/Patient?identifier=$system|$identifier";
    var response = await get(patientSearchUrl, headers: {});
    var searchResultBundle = jsonDecode(response.body);
    String patientResourceId = searchResultBundle['entry'][0]['resource']['id'];

    var patientLoadUrl =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/Patient/$patientResourceId";
    response = await get(patientLoadUrl, headers: {});
    return Patient.fromJson(jsonDecode(response.body));
  }

  /// Get the first returned CarePlan for the given patient.
  static Future<CarePlan> getCarePlan(Patient patient) async {
    var url =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/CarePlan?subject=${patient.reference}";
    var response = await get(url, headers: {});
    var searchResultBundle = jsonDecode(response.body);
    String id = searchResultBundle['entry'][0]['resource']['id'];
    url =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/CarePlan/$id";
    response = await get(url, headers: {});
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
        String id = entry['resource']['id'];
        url =
            "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/Procedure/$id";
        response = await get(url, headers: {});
        procedures.add(Procedure.fromJson(jsonDecode(response.body)));
      });
    }
    return procedures;
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
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/Questionnaire?_format=json";
    var body = questionnaireResponse.toJson();
    var headers = {
      "Accept-Charset": "utf-8",
      "Accept": "application/fhir+json;q=1.0, application/json+fhir;q=0.9",
      "Accept-Encoding": "gzip",
      "Content-Type": "application/fhir+json; charset=UTF-8",
    };

    return await post(url,
        headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));
  }

  static Future<Questionnaire> getMapAppQuestionnaire() async {
    var url =
        "https://hapi-fhir.cirg.washington.edu/hapi-fhir-jpaserver/fhir/Questionnaire/53";

    var value = await get(url, headers: {});

    var q = Questionnaire.fromJson(jsonDecode(value.body));
    await q.loadValueSets();
    return q;
  }
}
