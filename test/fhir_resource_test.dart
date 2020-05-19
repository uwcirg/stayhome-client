/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'dart:convert';

import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:test/test.dart';

void main() {
  group("QuestionnaireResponse test", () {
    Answer a0 = Answer(valueCoding: Coding(system: "system", code: "code0"));
    Answer a1 = Answer(valueCoding: Coding(system: "system", code: "code1"));

    test("Single answer", () {
      QuestionnaireResponse actual = new QuestionnaireResponse();
      actual.setAnswer("q1", a0);
      QuestionnaireResponse expected = QuestionnaireResponse(item: [
        QuestionnaireResponseItem(linkId: "q1", answer: [a0])
      ]);
      expect(actual.toJson(), expected.toJson());
    });

    test("Removed single answer", () {
      QuestionnaireResponse actual = new QuestionnaireResponse();
      actual.setAnswer("q1", a0);
      actual.removeAnswer("q1", a0);
      QuestionnaireResponse expected = QuestionnaireResponse(); //blank
      expect(actual.toJson(), expected.toJson());
    });

    test("Two answers", () {
      QuestionnaireResponse actual = new QuestionnaireResponse();
      actual.setAnswer("q1", a0);
      actual.setAnswer("q1", a1);
      QuestionnaireResponse expected = QuestionnaireResponse(item: [
        QuestionnaireResponseItem(linkId: "q1", answer: [a0, a1])
      ]);
      expect(actual.toJson(), expected.toJson());
    });

    test("Remove one answer", () {
      QuestionnaireResponse actual = new QuestionnaireResponse();
      actual.setAnswer("q1", a0);
      actual.setAnswer("q1", a1);
      actual.removeAnswer("q1", a0);
      QuestionnaireResponse expected = QuestionnaireResponse(item: [
        QuestionnaireResponseItem(linkId: "q1", answer: [a1])
      ]);
      expect(actual.toJson(), expected.toJson());
    });
  });
}
