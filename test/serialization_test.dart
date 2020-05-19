/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'dart:convert';

import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:test/test.dart';

void main() {
  test("CarePlan serialization", () {
    String jsonString = r"""{
        "resourceType": "CarePlan",
        "id": "1058",
        "meta": {
          "versionId": "1"
        },
        "status": "active",
        "intent": "plan",
        "description": "Monitor symptoms",
        "period": {
          "start": "2020-03-01T00:00:00.000",
          "end": "2020-12-31T00:00:00.000"
        },
        "activity": [
          {
            "detail": {
              "instantiatesCanonical": [
                "Questionnaire/204"
              ],
              "status": "scheduled",
              "doNotPerform": false,
              "scheduledTiming": {
                "repeat": {
                  "frequency": 1,
                  "period": 1,
                  "periodUnit": "d"
                }
              },
              "description": "Questionnaire"
            }
          },
          {
            "detail": {
              "instantiatesCanonical": [
                "Questionnaire/1057"
              ],
              "status": "scheduled",
              "doNotPerform": false,
              "description": "Exposure questionnaire"
            }
          },
          {
            "detail": {
              "instantiatesCanonical": [
                "Questionnaire/1376"
              ],
              "status": "scheduled",
              "doNotPerform": false,
              "description": "COVID-19 testing questionnaire"
            }
          },
          {
            "detail": {
              "instantiatesCanonical": [
                "Questionnaire/1442"
              ],
              "status": "scheduled",
              "doNotPerform": false,
              "description": "Pregnancy questionnaire"
            }
          }
        ]
      }""";
    CarePlan expected = CarePlan(
      id: "1058",
      meta: Meta(versionId: "1"),
      status: CarePlanStatus.active,
      intent: "plan",
      description: "Monitor symptoms",
      period: Period(
        start: DateTime(2020, 3, 1),
        end: DateTime(2020, 12, 31),
      ),
      activity: [
        Activity(
            detail: Detail(
                instantiatesCanonical: ["Questionnaire/204"],
                status: DetailStatus.scheduled,
                doNotPerform: false,
                scheduledTiming: Timing(
                    repeat: Repeat(
                  frequency: 1,
                  period: 1,
                  periodUnit: "d",
                )),
                description: "Questionnaire")),
        Activity(
            detail: Detail(
                instantiatesCanonical: ["Questionnaire/1057"],
                status: DetailStatus.scheduled,
                doNotPerform: false,
                description: "Exposure questionnaire")),
        Activity(
            detail: Detail(
                instantiatesCanonical: ["Questionnaire/1376"],
                status: DetailStatus.scheduled,
                doNotPerform: false,
                description: "COVID-19 testing questionnaire")),
        Activity(
            detail: Detail(
                instantiatesCanonical: ["Questionnaire/1442"],
                status: DetailStatus.scheduled,
                doNotPerform: false,
                description: "Pregnancy questionnaire")),
      ],
    );

    CarePlan actual = CarePlan.fromJson(jsonDecode(jsonString));
    expect(actual.toJson(), jsonDecode(jsonString));
    expect(actual.toJson(), expected.toJson());
  });

  test("Communication serialization", () {
    String jsonString = r"""{
  "resourceType": "Communication",
  "id": "57",
  "meta": {
    "versionId": "1"
  },
  "status": "in-progress",
  "category": [
    {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/communication-category",
          "code": "alert"
        }
      ]
    }
  ],
  "priority": "routine",
  "payload": [
    {
      "contentString": "Welcome to StayHome! We're glad you're here.\n- Keep an eye on this space for messages\n- Dismiss them with the “Dismiss” button\n- Find new and old messages in the Menu under Communications",
      "_contentString": {
        "extension": [
          {
            "url": "http://hl7.org/fhir/StructureDefinition/elementdefinition-translatable",
            "valueBoolean": true
          },
          {
            "url" : "http://hl7.org/fhir/StructureDefinition/translation",
            "extension" : [{
              "url" : "lang",
              "valueCode" : "de"
            },{
              "url" : "content",
              "valueString" : "Symptombegutachtung"
            }]
          },
          {
            "url" : "http://hl7.org/fhir/StructureDefinition/translation",
            "extension" : [{
              "url" : "lang",
              "valueCode" : "es"
            },{
              "url" : "content",
              "valueString" : "Evaluación de síntomas"
            }]
          }
        ]
      }
    }
  ]
}""";
    Communication expected = Communication(
        id: "57",
        meta: Meta(versionId: "1"),
        status: CommunicationStatus.in_progress,
        category: [
          CodeableConcept(coding: [
            Coding(
                system: "http://terminology.hl7.org/CodeSystem/communication-category",
                code: "alert")
          ])
        ],
        priority: Priority.routine,
        payload: [
          Payload(
              contentStringBase:
                  "Welcome to StayHome! We're glad you're here.\n- Keep an eye on this space for messages\n- Dismiss them with the “Dismiss” button\n- Find new and old messages in the Menu under Communications",
              contentStringExt: PrimitiveTypeExtension(extension: [
                Extension(
                    url: "http://hl7.org/fhir/StructureDefinition/elementdefinition-translatable",
                    valueBoolean: true),
                Extension(url: "http://hl7.org/fhir/StructureDefinition/translation", extension: [
                  Extension(url: "lang", valueCode: "de"),
                  Extension(url: "content", valueString: "Symptombegutachtung")
                ]),
                Extension(url: "http://hl7.org/fhir/StructureDefinition/translation", extension: [
                  Extension(url: "lang", valueCode: "es"),
                  Extension(url: "content", valueString: "Evaluación de síntomas")
                ])
              ])),
        ]);

    Communication actual = Communication.fromJson(jsonDecode(jsonString));
    expect(actual.toJson(), jsonDecode(jsonString));
    expect(actual.toJson(), expected.toJson());
  });

  test("Consent serialization", () {
    String jsonString = r"""{
  "resourceType": "Consent",
  "id": "1728",
  "status": "active",
  "scope": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/consentscope",
        "code": "patient-privacy"
      }
    ]
  },
  "category": [
    {
      "coding": [
        {
          "system": "http://loinc.org",
          "code": "59284-0"
        }
      ]
    }
  ],
  "patient": {
    "reference": "Patient/1221"
  },
  "organization": [
    {
      "reference": "Organization/1463"
    }
  ],
  "provision": {
    "type": "permit",
    "period": {
      "start": "2020-04-17T19:08:07.114"
    },
    "class": [
      {
        "system": "https://stayhome.app/CodeSystem/consent-content-class",
        "code": "location_contact-information_symptoms-testing-conditions"
      }
    ]
  }
}""";
    Consent expected = Consent(
        id: "1728",
        status: ConsentStatus.active,
        scope: CodeableConcept(coding: [
          Coding(
              system: "http://terminology.hl7.org/CodeSystem/consentscope", code: "patient-privacy")
        ]),
        category: [
          CodeableConcept(coding: [Coding(system: "http://loinc.org", code: "59284-0")])
        ],
        patient: Reference(reference: "Patient/1221"),
        organization: [Reference(reference: "Organization/1463")],
        provision: Provision(
            type: ProvisionType.permit,
            period: Period(start: DateTime(2020, 4, 17, 19, 8, 7, 114)),
            provisionClass: [
              Coding(
                  system: "https://stayhome.app/CodeSystem/consent-content-class",
                  code: "location_contact-information_symptoms-testing-conditions")
            ]));

    Consent actual = Consent.fromJson(jsonDecode(jsonString));
    expect(actual.toJson(), expected.toJson());
    expect(actual.toJson(), jsonDecode(jsonString));
  });

  test("QuestionnaireResponse serialization", () {
    String jsonString = r"""{
  "resourceType": "QuestionnaireResponse",
  "id": "1729",
  "meta": {
    "versionId": "1"
  },
  "basedOn": [
    {
      "reference": "CarePlan/1445"
    }
  ],
  "questionnaire": "Questionnaire/204",
  "status": "completed",
  "subject": {
    "reference": "Patient/1444"
  },
  "authored": "2020-04-18T20:07:00.000",
  "item": [
    {
      "linkId": "/70442-9",
      "answer": [
        {
          "valueCoding": {
            "code": "LA6568-5",
            "display": "Not at all"
          }
        }
      ]
    }
  ]
}""";
    QuestionnaireResponse expected = QuestionnaireResponse.from(
        Questionnaire(id: "204"), Reference(reference: "Patient/1444"), CarePlan(id: "1445"),
        status: QuestionnaireResponseStatus.completed, id: "1729", meta: Meta(versionId: "1"));
    expected.setAnswer("/70442-9", Answer(valueCoding: Coding(code: "LA6568-5", displayBase: "Not at all")));
    expected.authored = DateTime(2020, 4, 18, 20, 7, 0, 0);

    QuestionnaireResponse actual = QuestionnaireResponse.fromJson(jsonDecode(jsonString));
    expect(actual.toJson(), expected.toJson());
    expect(actual.toJson(), jsonDecode(jsonString));
  });

  test("Questionnaire serialization", () {
    String jsonString = r"""{
  "resourceType": "Questionnaire",
  "id": "204",
  "meta": {
    "versionId": "6"
  },
  "name": "Symptom Assessment",
  "title": "Symptom Assessment",
  "status": "active",
  "item": [
    {
      "linkId": "/info",
      "type": "display",
      "required": false,
      "repeats": false,
      "item": [
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system": "http://hl7.org/fhir/questionnaire-item-control",
                    "code": "help",
                    "display": "Help-Button"
                  }
                ],
                "text": "Help-Button"
              }
            }
          ],
          "repeats": false,
          "linkId": "/info-help",
          "text": "All questions are optional.",
          "type": "display"
        }
      ]
    },
    {
      "linkId": "/70442-9",
      "code": [
        {
          "system": "http://loinc.org",
          "code": "70442-9",
          "display": "I have been coughing"
        }
      ],
      "text": "I recently started coughing",
      "type": "choice",
      "required": false,
      "repeats": false,
      "answerOption": [
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 0
            }
          ],
          "valueCoding": {
            "code": "LA6568-5",
            "display": "Not at all"
          }
        },
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 2
            }
          ],
          "valueCoding": {
            "code": "LA13909-9",
            "display": "Somewhat"
          }
        },
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 4
            }
          ],
          "valueCoding": {
            "code": "LA13914-9",
            "display": "Very much"
          }
        }
      ]
    },
    {
      "linkId": "/70305-8",
      "code": [
        {
          "system": "http://loinc.org",
          "code": "70305-8",
          "display": "I have been short of breath"
        }
      ],
      "text": "I recently have been wheezing or short of breath",
      "type": "choice",
      "required": false,
      "repeats": false,
      "answerOption": [
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 0
            }
          ],
          "valueCoding": {
            "code": "LA6568-5",
            "display": "Not at all"
          }
        },
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 2
            }
          ],
          "valueCoding": {
            "code": "LA13909-9",
            "display": "Somewhat"
          }
        },
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 4
            }
          ],
          "valueCoding": {
            "code": "LA13914-9",
            "display": "Very much"
          }
        }
      ]
    },
    {
      "linkId": "/sense_of_smell",
      "code": [
        {
          "system": "Custom",
          "code": "sense_of_smell",
          "display": "My sense of smell or taste is"
        }
      ],
      "text": "My sense of smell or taste is",
      "type": "choice",
      "required": false,
      "repeats": false,
      "answerOption": [
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 0
            }
          ],
          "valueCoding": {
            "system": "Custom",
            "code": "normal",
            "display": "Normal"
          }
        },
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 1
            }
          ],
          "valueCoding": {
            "system": "Custom",
            "code": "decreased",
            "display": "Decreased"
          }
        },
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 2
            }
          ],
          "valueCoding": {
            "system": "Custom",
            "code": "completely_gone",
            "display": "Completely gone"
          }
        }
      ]
    },
    {
      "linkId": "/70421-3",
      "code": [
        {
          "system": "http://loinc.org",
          "code": "70421-3",
          "display": "I have had fevers (episodes of high body temperature)"
        }
      ],
      "text": "I have felt feverish (had episodes of high body temperature)",
      "type": "choice",
      "required": false,
      "repeats": false,
      "answerOption": [
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 0
            }
          ],
          "valueCoding": {
            "code": "LA6568-5",
            "display": "Not at all"
          }
        },
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 2
            }
          ],
          "valueCoding": {
            "code": "LA13909-9",
            "display": "Somewhat"
          }
        },
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/ordinalValue",
              "valueDecimal": 4
            }
          ],
          "valueCoding": {
            "code": "LA13914-9",
            "display": "Very much"
          }
        }
      ]
    },
    {
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/questionnaire-unit",
          "valueCoding": {
            "display": "[degF]"
          }
        }
      ],
      "linkId": "/8310-5",
      "code": [
        {
          "system": "http://loinc.org",
          "code": "8310-5",
          "display": "Temperature"
        }
      ],
      "text": "Temperature if taken by thermometer",
      "type": "decimal",
      "required": false,
      "repeats": false
    },
    {
      "linkId": "/comment",
      "code": [
        {
          "system": "Custom",
          "code": "comment",
          "display": "Comments"
        }
      ],
      "text": "Comments",
      "type": "string",
      "required": false,
      "repeats": false
    },
    {
      "linkId": "/exposure_info",
      "type": "display",
      "required": false,
      "repeats": false,
      "item": [
        {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system": "http://hl7.org/fhir/questionnaire-item-control",
                    "code": "help",
                    "display": "Help-Button"
                  }
                ],
                "text": "Help-Button"
              }
            }
          ],
          "linkId": "/exposure_info-help",
          "text": "If you have had a possible or known exposure to a person infected with COVID-19, or if you have traveled within the last two weeks, please enter that information in “enter possible exposure or travel”.",
          "type": "display",
          "repeats": false
        }
      ]
    }
  ]
}""";

    expect(Questionnaire.fromJson(jsonDecode(jsonString)).toJson(), jsonDecode(jsonString));
  });
}
