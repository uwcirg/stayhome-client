/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

class MalformedFhirResourceException implements Exception {
  final String _message;

  @override
  String toString() {
    return "MalformedFhirResourceException: Fhir resource had invalid format/missing properties. $_message";
  }

  MalformedFhirResourceException(this._message);
}
