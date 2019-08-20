/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';

import 'package:http/http.dart' show Response, get, post;
import 'package:map_app_flutter/fhir/Questionnaire.dart';

class Repository {
  static Future<Questionnaire> getQuestionnaire() async {
    var url =
        'http://hapi.fhir.org/baseR4/Questionnaire/11723';

    var value = await get(url, headers: { });

    return Questionnaire.fromJson(jsonDecode(value.body));
  }
}

