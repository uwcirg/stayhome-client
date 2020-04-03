/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';

class MalformedFhirResourceException implements Exception {
  final dynamic _fhirResource;
  final String _message;

  @override
  String toString() {
    String objectString = jsonEncode(_fhirResource.toJson());
    return "MalformedFhirResourceException: Fhir resource had invalid format/missing properties. $_message\nWas:\n$objectString}";
  }

  MalformedFhirResourceException(this._fhirResource, this._message);
}
