/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */
import 'package:intl/intl.dart';
import 'package:map_app_flutter/fhir/fhir_translations.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/map_app_code_system.dart';
import 'package:map_app_flutter/services/Repository.dart';
import 'package:json_annotation/json_annotation.dart';

// To generate the serialization code run in project root: flutter pub run build_runner build
// see https://pub.dev/packages/json_serializable
//  and https://flutter.dev/docs/development/data-and-backend/json
part 'FhirResources.g.dart';

abstract class Resource {
  get resourceType;

  get id;

  @JsonKey(ignore: true)
  String get reference => "$resourceType/$id";

  factory Resource.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson();
}

enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('other')
  other,
  @JsonValue('unknown')
  unknown
}

enum CommunicationStatus {
  @JsonValue('preparation')
  preparation,
  @JsonValue('in-progress')
  in_progress,
  @JsonValue('not-done')
  not_done,
  @JsonValue('on-hold')
  on_hold,
  @JsonValue('stopped')
  stopped,
  @JsonValue('completed')
  completed,
  @JsonValue('entered-in-error')
  entered_in_error,
  @JsonValue('unknown')
  unknown
}

enum Priority {
  @JsonValue("routine")
  routine,
  @JsonValue("urgent")
  urgent,
  @JsonValue("asap")
  asap,
  @JsonValue("stat")
  stat,
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Consent with Resource {
  final String resourceType;
  String id;
  Meta meta;
  ConsentStatus status;
  CodeableConcept scope;
  List<CodeableConcept> category;
  Reference patient;
  Provision provision;
  List<Reference> organization;

  Consent(
      {this.resourceType = "Consent",
      this.id,
      this.meta,
      this.status,
      this.scope,
      this.category,
      this.patient,
      this.provision,
      this.organization});

  factory Consent.fromJson(Map<String, dynamic> json) => _$ConsentFromJson(json);

  Map<String, dynamic> toJson() => _$ConsentToJson(this);

  bool hasCategory(Coding category) => this
      .category
      .any((CodeableConcept concept) => concept.coding.any((element) => element == category));

  @JsonKey(ignore: true)
  bool get isConsented => provision.type == ProvisionType.permit;

  update(ProvisionType type) {
    this.provision.type = type;
    this.provision.period = Period(start: DateTime.now());
  }

  factory Consent.from(
      Patient patient, Reference organization, Coding contentClass, ProvisionType type) {
    return Consent(
        status: ConsentStatus.active,
        scope: CodeableConcept(coding: [ConsentScope.patientPrivacy]),
        category: [
          CodeableConcept(coding: [ConsentCategory.patientConsent])
        ],
        patient: Reference(reference: patient.reference),
        organization: [organization],
        provision: Provision(
            provisionClass: [contentClass], type: type, period: Period(start: DateTime.now())));
  }
}

enum ConsentStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('proposed')
  proposed,
  @JsonValue('active')
  active,
  @JsonValue('rejected')
  rejected,
  @JsonValue('inactive')
  inactive,
  @JsonValue('entered-in-error')
  entered_in_error
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Provision {
  ProvisionType type;
  @JsonKey(name: "class")
  List<Coding> provisionClass;
  Period period;

  Provision({this.type, this.provisionClass, this.period});

  factory Provision.fromJson(Map<String, dynamic> json) => _$ProvisionFromJson(json);

  Map<String, dynamic> toJson() => _$ProvisionToJson(this);
}

enum ProvisionType {
  @JsonValue('deny')
  deny,
  @JsonValue('permit')
  permit
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Communication with Resource {
  String resourceType;
  String id;
  Meta meta;
  CommunicationStatus status;
  Priority priority;
  List<CodeableConcept> category;
  List<Reference> recipient;
  List<Payload> payload;
  DateTime sent;

  Communication(
      {this.resourceType = "Communication",
      this.id,
      this.meta,
      this.status,
      this.priority,
      this.category,
      this.recipient,
      this.payload,
      this.sent});

  factory Communication.fromJson(Map<String, dynamic> json) => _$CommunicationFromJson(json);

  Map<String, dynamic> toJson() => _$CommunicationToJson(this);

  String displayText(context) {
    return payload[0]?.contentString ?? S.of(context).no_content;
  }

  factory Communication.fromTemplate(Communication commTemplate, Patient patient) {
    Communication comm = Communication.fromJson(commTemplate.toJson());
    comm.recipient = [Reference(reference: patient.reference)];
    comm.sent = DateTime.now();
    return comm;
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class PrimitiveTypeExtension {
  List<Extension> extension;

  PrimitiveTypeExtension({this.extension});

  factory PrimitiveTypeExtension.fromJson(Map<String, dynamic> json) =>
      _$PrimitiveTypeExtensionFromJson(json);

  Map<String, dynamic> toJson() => _$PrimitiveTypeExtensionToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Payload {
  Attachment contentAttachment;
  Reference contentReference;

  @JsonKey(name: "contentString")
  String contentStringBase;
  @JsonKey(name: "_contentString")
  PrimitiveTypeExtension contentStringExt;

  @JsonKey(ignore: true)
  String get contentString =>
      FhirTranslations.extractTranslation(contentStringBase, contentStringExt);

  Payload(
      {this.contentStringBase,
      this.contentAttachment,
      this.contentReference,
      this.contentStringExt});

  factory Payload.fromJson(Map<String, dynamic> json) => _$PayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Patient with Resource {
  final String resourceType;
  String id;
  Meta meta;
  Narrative text;
  List<Extension> extension;
  List<Identifier> identifier;
  List<HumanName> name;
  List<ContactPoint> telecom;
  Gender gender;
  DateTime birthDate;
  List<Address> address;
  CodeableConcept maritalStatus;
  bool multipleBirthBoolean;
  List<PatientCommunication> communication;

  Patient(
      {this.resourceType = 'Patient',
      this.id,
      this.meta,
      this.text,
      this.extension,
      this.identifier,
      this.name,
      this.telecom,
      this.gender,
      this.birthDate,
      this.address,
      this.maritalStatus,
      this.multipleBirthBoolean,
      this.communication});

  factory Patient.fromNewPatientForm(Patient originalPatient,
      {String phoneNumber,
      String lastName,
      String firstName,
      String emailAddress,
      String homeZip,
      String secondZip,
      ContactPointSystem preferredContactMethod,
      Gender gender,
      DateTime birthDate}) {
    Patient patient;
    if (originalPatient != null) {
      patient = Patient.fromJson(originalPatient.toJson());
    } else {
      patient = Patient();
    }
    patient.firstName = firstName;
    patient.lastName = lastName;
    patient.phoneNumber = phoneNumber;
    patient.emailAddress = emailAddress;
    patient.homeZip = homeZip;
    patient.secondZip = secondZip;
    patient.preferredContactMethod = preferredContactMethod;
    patient.gender = gender;
    patient.birthDate = birthDate;
    return patient;
  }

  @JsonKey(ignore: true)
  String get firstName => this.name != null &&
          this.name.length > 0 &&
          this.name[0].given != null &&
          this.name[0].given.length > 0
      ? this.name[0].given[0]
      : null;

  @JsonKey(ignore: true)
  String get fullNameDisplay {
    List<String> names = [];
    if (firstName != null && firstName.isNotEmpty) names.add(firstName);
    if (lastName != null && lastName.isNotEmpty) names.add(lastName);
    return names.join(" ");
  }

  setKeycloakId(String keycloakIdentifierSystemName, String keycloakId) {
    identifier ??= [];
    Identifier keycloakIdentifier = identifier.firstWhere(
        (element) => element.system == keycloakIdentifierSystemName,
        orElse: () => null);
    if (keycloakIdentifier == null) {
      identifier.add(Identifier(system: keycloakIdentifierSystemName, value: keycloakId));
    } else {
      keycloakIdentifier.value = keycloakId;
    }
  }

  @JsonKey(ignore: true)
  set firstName(String text) {
    if (this.name == null || this.name.isEmpty) this.name = [HumanName()];
    if (this.name[0].given == null || this.name[0].given.length == 0) this.name[0].given = [""];
    this.name[0].given[0] = text;
  }

  @JsonKey(ignore: true)
  String get lastName => this.name != null && this.name.length > 0 && this.name[0].family != null
      ? this.name[0].family
      : null;

  @JsonKey(ignore: true)
  set lastName(String text) {
    if (this.name == null || this.name.isEmpty) this.name = [HumanName()];
    this.name[0].family = text;
  }

  @JsonKey(ignore: true)
  set emailAddress(String text) {
    this.telecom ??= [];
    ContactPoint p = _contactPointForSystem(ContactPointSystem.email);
    if (p == null) {
      this.telecom.add(ContactPoint(system: ContactPointSystem.email, value: text));
    } else {
      p.value = text;
    }
  }

  @JsonKey(ignore: true)
  set phoneNumber(String text) {
    this.telecom ??= [];
    ContactPoint p = _contactPointForSystem(ContactPointSystem.phone);
    if (p == null) {
      this.telecom.add(ContactPoint(system: ContactPointSystem.phone, value: text));
    } else {
      p.value = text;
    }
  }

  ContactPoint _contactPointForSystem(ContactPointSystem system) {
    return system != null && this.telecom != null && this.telecom.length > 0
        ? this.telecom.firstWhere((ContactPoint p) => p.system == system, orElse: () => null)
        : null;
  }

  @JsonKey(ignore: true)
  set preferredContactMethod(ContactPointSystem system) {
    // if sms is preferred and we have a phone number, use that and set its use to sms.
    // if phone is preferred and we have a sms number, use that and set its use to phone.
    // then set the contact point as preferred.

    if (this.telecom == null || this.telecom.length == 0) return;

    if (system == ContactPointSystem.phone || system == ContactPointSystem.sms) {
      ContactPoint sms = _contactPointForSystem(ContactPointSystem.sms);
      ContactPoint phone = _contactPointForSystem(ContactPointSystem.phone);
      // if we have neither, there's nothing to do
      if (phone == null && sms == null) return;

      if (system == ContactPointSystem.phone) {
        if (phone == null) {
          // if we have sms, update it to phone
          sms.system = ContactPointSystem.phone;
        }
      } else {
        if (sms == null) {
          phone.system = ContactPointSystem.sms;
        }
      }
    }

    // update rank of all contact points
    this.telecom.forEach((ContactPoint p) {
      if (system == null || p.system != system) {
        p.rank = 99;
      } else {
        p.rank = 1;
      }
    });
  }

  @JsonKey(ignore: true)
  ContactPointSystem get preferredContactMethod => this.telecom != null && this.telecom.length > 0
      ? this
          .telecom
          .firstWhere((ContactPoint p) => p.rank == 1, orElse: () => ContactPoint())
          .system
      : null;

  @JsonKey(ignore: true)
  String get emailAddress {
    ContactPoint p = _contactPointForSystem(ContactPointSystem.email);
    return p != null ? p.value : null;
  }

  @JsonKey(ignore: true)
  String get phoneNumber {
    ContactPoint phone = _contactPointForSystem(ContactPointSystem.phone);
    ContactPoint sms = _contactPointForSystem(ContactPointSystem.sms);
    ContactPoint p;
    if (phone == null || sms == null) {
      if (phone == null) {
        p = sms;
      } else {
        p = phone;
      }
    } else {
      p = phone;
    }
    return p != null ? p.value : null;
  }

  @JsonKey(ignore: true)
  String get homeZip => this.address != null && this.address.length > 0
      ? this
          .address
          .firstWhere((Address a) => a.use == AddressUse.home, orElse: () => Address())
          .postalCode
      : null;

  @JsonKey(ignore: true)
  set homeZip(String text) {
    if (this.address == null) this.address = [];
    Address address =
        this.address.firstWhere((Address a) => a.use == AddressUse.home, orElse: () => null);
    if (address == null) {
      address = Address(use: AddressUse.home);
      this.address.add(address);
    }
    address.postalCode = text;
  }

  @JsonKey(ignore: true)
  String get secondZip => this.address != null && this.address.length > 0
      ? this
          .address
          .firstWhere((Address a) => a.use != AddressUse.home, orElse: () => Address())
          .postalCode
      : null;

  @JsonKey(ignore: true)
  set secondZip(String text) {
    if (this.address == null) this.address = [];
    Address address =
        this.address.firstWhere((Address a) => a.use != AddressUse.home, orElse: () => null);
    if (address == null) {
      address = Address();
      this.address.add(address);
    }
    address.postalCode = text;
  }

  @JsonKey(ignore: true)
  String get language => this
      .communication
      ?.firstWhere((element) => element?.preferred ?? false, orElse: () => null)
      ?.language
      ?.coding
      ?.first
      ?.code;

  @JsonKey(ignore: true)
  set language(String text) {
    String localeString = text;
    if (localeString.contains("_")) {
      localeString = localeString.replaceAll("_", "-");
    }
    this.communication = [
      PatientCommunication(
          language: CodeableConcept(coding: [CommunicationLanguage(localeString)]), preferred: true)
    ];
  }

  factory Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);

  Map<String, dynamic> toJson() => _$PatientToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Meta {
  String versionId;
  DateTime lastUpdated;

  Meta({this.versionId, this.lastUpdated});

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Narrative {
  String status;
  String div;

  Narrative({this.status, this.div});

  factory Narrative.fromJson(Map<String, dynamic> json) => _$NarrativeFromJson(json);

  Map<String, dynamic> toJson() => _$NarrativeToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class HumanName {
  String use;
  String family;
  List<String> given;

  HumanName({this.use, this.family, this.given});

  factory HumanName.fromJson(Map<String, dynamic> json) => _$HumanNameFromJson(json);

  Map<String, dynamic> toJson() => _$HumanNameToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ContactPoint {
  ContactPointSystem system;
  String value;
  String use;
  int rank;

  ContactPoint({this.system, this.value, this.use, this.rank});

  factory ContactPoint.fromJson(Map<String, dynamic> json) => _$ContactPointFromJson(json);

  Map<String, dynamic> toJson() => _$ContactPointToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Address {
  List<Extension> extension;
  List<String> line;
  AddressUse use;
  String city;
  String district;
  String state;
  String postalCode;
  String country;

  Address(
      {this.extension,
      this.line,
      this.use,
      this.city,
      this.district,
      this.state,
      this.postalCode,
      this.country});

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  String toString() {
    return "${line.join(', ')}, $city, $state $postalCode";
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class PatientCommunication {
  CodeableConcept language;
  bool preferred;

  PatientCommunication({this.language, this.preferred});

  factory PatientCommunication.fromJson(Map<String, dynamic> json) =>
      _$PatientCommunicationFromJson(json);

  Map<String, dynamic> toJson() => _$PatientCommunicationToJson(this);
}

enum AddressUse {
  @JsonValue('home')
  home,
  @JsonValue('work')
  work,
  @JsonValue('temp')
  temp,
  @JsonValue('old')
  old,
  @JsonValue('billing')
  billing
}

enum ContactPointSystem {
  @JsonValue('phone')
  phone,
  @JsonValue('fax')
  fax,
  @JsonValue('email')
  email,
  @JsonValue('pager')
  pager,
  @JsonValue('url')
  url,
  @JsonValue('sms')
  sms,
  @JsonValue('other')
  other
}

enum ProcedureStatus {
  @JsonValue('preparation')
  preparation,
  @JsonValue('in-progress')
  in_progress,
  @JsonValue('not-done')
  not_done,
  @JsonValue('suspended')
  suspended,
  @JsonValue('aborted')
  aborted,
  @JsonValue('completed')
  completed,
  @JsonValue('entered-in-error')
  entered_in_error,
  @JsonValue('unknown')
  unknown
}

enum QuestionnaireResponseStatus {
  @JsonValue('in-progress')
  in_progress,
  @JsonValue('stopped')
  stopped,
  @JsonValue('completed')
  completed,
  @JsonValue('amended')
  amended,
  @JsonValue('entered-in-error')
  entered_in_error
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Procedure with Resource {
  final String resourceType;
  String id;
  Meta meta;
  Narrative text;
  List<Identifier> identifier;
  List<Reference> basedOnCarePlan;
  List<String> instantiatesQuestionnaire;
  ProcedureStatus status;
  CodeableConcept statusReason;
  CodeableConcept category;
  CodeableConcept code;
  Reference subject;
  DateTime performedDateTime;
  Period performedPeriod;
  List<CodeableConcept> reasonCode;

  Procedure(
      {this.resourceType = "Procedure",
      this.id,
      this.meta,
      this.text,
      this.identifier,
      this.basedOnCarePlan,
      this.status,
      this.statusReason,
      this.category,
      this.code,
      this.subject,
      this.performedDateTime,
      this.reasonCode,
      this.performedPeriod,
      this.instantiatesQuestionnaire});

  factory Procedure.fromJson(Map<String, dynamic> json) => _$ProcedureFromJson(json);

  Map<String, dynamic> toJson() => _$ProcedureToJson(this);

  Procedure.treatmentSession(int minutes, CarePlan carePlan,
      {this.resourceType = "Procedure", this.id, this.status, this.code}) {
    if (this.code == null) {
      this.code = carePlan.getTreatmentActivity().detail.code;
    }
    if (this.status == null) {
      this.status = ProcedureStatus.completed;
    }
    this.subject = carePlan.subject;
    this.basedOnCarePlan = [Reference(reference: carePlan.reference)];

    var today = new DateTime.now();
    // remove milliseconds and seconds
    DateTime performedDateTime =
        new DateTime(today.year, today.month, today.day, today.hour, today.minute);
    this.performedDateTime = performedDateTime;
    this.performedPeriod = Period(
        start: performedDateTime.subtract(Duration(minutes: minutes)), end: performedDateTime);
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class CarePlan with Resource {
  final String resourceType;
  String id;
  Meta meta;
  List<Identifier> identifier;
  List<Reference> basedOn;
  CarePlanStatus status;
  String intent;
  List<CodeableConcept> category;
  String description;
  Reference subject;
  Period period;
  DateTime created;
  List<Activity> activity;

  CarePlan(
      {this.resourceType = "CarePlan",
      this.id,
      this.meta,
      this.identifier,
      this.basedOn,
      this.status,
      this.intent,
      this.category,
      this.description,
      this.subject,
      this.period,
      this.created,
      this.activity});

  factory CarePlan.fromJson(Map<String, dynamic> json) => _$CarePlanFromJson(json);

  Map<String, dynamic> toJson() => _$CarePlanToJson(this);

  Activity getActivityWithCode(String code) {
    return activity.firstWhere((Activity activity) {
      if (activity == null ||
          activity.detail == null ||
          activity.detail.code == null ||
          activity.detail.code.coding == null) return null;
      return activity.detail.code.coding.any((Coding coding) => coding.code == code);
    });
  }

  Activity getQuestionnaireActivities() {
    return activity.firstWhere((Activity activity) {
      if (activity == null ||
          activity.detail == null ||
          activity.detail.instantiatesCanonical == null) return false;

      return activity.detail.instantiatesCanonical
          .any((String instantiated) => instantiated.startsWith(Questionnaire().resourceType));
    });
  }

  Activity getTreatmentActivity() {
    // for now, assume that the treatment activity is the first activity that
    // has a snomed code
    return activity.firstWhere((Activity activity) {
      if (activity == null ||
          activity.detail == null ||
          activity.detail.code == null ||
          activity.detail.code.coding == null) return false;

      return activity.detail.code.coding.any((Coding coding) {
        if (coding == null || coding.system == null) return false;
        return coding.system.contains("snomed");
      });
    });
  }

  List<String> getAllQuestionnaireReferences() {
    return activity
        .where((Activity activity) {
          if (activity == null ||
              activity.detail == null ||
              activity.detail.instantiatesCanonical == null ||
              activity.detail.instantiatesCanonical.length > 1 ||
              activity.detail.instantiatesCanonical.length == 0) return false;
          return activity.detail.instantiatesCanonical[0].startsWith(Questionnaire().resourceType);
        })
        .map((Activity questionnaireActivity) =>
            questionnaireActivity.detail.instantiatesCanonical[0])
        .toList();
  }

  static CarePlan fromTemplate(CarePlan plan, Patient patient) {
    CarePlan newPlan = CarePlan.fromJson(plan.toJson());
    newPlan.subject = Reference(reference: patient.reference);
    newPlan.id = null;
    newPlan.basedOn = [Reference(reference: plan.reference)];
    newPlan.status = CarePlanStatus.active;
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    newPlan.period = Period(start: today, end: today.add(Duration(days: 120)));
    return newPlan;
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Identifier {
  String value;
  String system;

  Identifier({this.value, this.system});

  factory Identifier.fromJson(Map<String, dynamic> json) => _$IdentifierFromJson(json);

  Map<String, dynamic> toJson() => _$IdentifierToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Period {
  DateTime start;
  DateTime end;

  Period({this.start, this.end});

  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Activity {
  Detail detail;

  Activity({this.detail});

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Detail {
  CodeableConcept code;
  DetailStatus status;
  CodeableConcept statusReason;
  bool doNotPerform;
  Timing scheduledTiming;
  Period scheduledPeriod;
  String description;
  List<String> instantiatesCanonical;
  List<Reference> reasonReference;

  Detail(
      {this.code,
      this.status,
      this.statusReason,
      this.doNotPerform,
      this.scheduledTiming,
      this.scheduledPeriod,
      this.description,
      this.instantiatesCanonical,
      this.reasonReference});

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);

  Map<String, dynamic> toJson() => _$DetailToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Timing {
  Repeat repeat;
  CodeableConcept code;

  Timing({this.repeat});

  factory Timing.fromJson(Map<String, dynamic> json) => _$TimingFromJson(json);

  Map<String, dynamic> toJson() => _$TimingToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Repeat {
  double duration;
  String durationUnit;
  int frequency;
  double period;
  String periodUnit;

  Repeat({this.frequency, this.period, this.periodUnit, this.durationUnit, this.duration});

  factory Repeat.fromJson(Map<String, dynamic> json) => _$RepeatFromJson(json);

  Map<String, dynamic> toJson() => _$RepeatToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Range {
  SimpleQuantity low;
  SimpleQuantity high;

  Range({this.low, this.high});

  factory Range.fromJson(Map<String, dynamic> json) => _$RangeFromJson(json);

  Map<String, dynamic> toJson() => _$RangeToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SimpleQuantity {
  double value;
  String unit;
  String system;
  String code;

  SimpleQuantity({this.value, this.unit, this.system, this.code});

  factory SimpleQuantity.fromJson(Map<String, dynamic> json) => _$SimpleQuantityFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleQuantityToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class TimingAbbreviation {
  String display;
  String definition;

  TimingAbbreviation();

  TimingAbbreviation._(this.display, this.definition);

  static TimingAbbreviation BID = TimingAbbreviation._("BID", "Two times a day");

  static TimingAbbreviation TID =
      TimingAbbreviation._("TID", "Three times a day at institution specified time");
  static TimingAbbreviation QID =
      TimingAbbreviation._("QID", "Four times a day at institution specified time");
  static TimingAbbreviation AM =
      TimingAbbreviation._("AM", "Every morning at institution specified times");
  static TimingAbbreviation PM =
      TimingAbbreviation._("PM", "Every afternoon at institution specified times");
  static TimingAbbreviation QD =
      TimingAbbreviation._("QD", "Every Day at institution specified times");
  static TimingAbbreviation QOD =
      TimingAbbreviation._("QOD", "Every Other Day at institution specified times");
  static TimingAbbreviation Q1H =
      TimingAbbreviation._("every hour", "Every hour at institution specified times");
  static TimingAbbreviation Q2H =
      TimingAbbreviation._("every 2 hours", "Every 2 hours at institution specified times");
  static TimingAbbreviation Q3H =
      TimingAbbreviation._("every 3 hours", "Every 3 hours at institution specified times");
  static TimingAbbreviation Q4H =
      TimingAbbreviation._("Q4H", "Every 4 hours at institution specified times");
  static TimingAbbreviation Q6H =
      TimingAbbreviation._("Q6H", "Every 6 Hours at institution specified times");
  static TimingAbbreviation Q8H =
      TimingAbbreviation._("every 8 hours", "Every 8 hours at institution specified times");
  static TimingAbbreviation BED =
      TimingAbbreviation._("at bedtime", "At bedtime (institution specified time)");
  static TimingAbbreviation WK =
      TimingAbbreviation._("weekly", "Weekly at institution specified time");
  static TimingAbbreviation MO =
      TimingAbbreviation._("monthly", "Monthly at institution specified time");

  static List<TimingAbbreviation> _vals = [
    TID,
    QID,
    AM,
    PM,
    QD,
    QOD,
    Q1H,
    Q2H,
    Q3H,
    Q4H,
    Q6H,
    Q8H,
    BED,
    WK,
    MO
  ];

  static TimingAbbreviation fromJson(String key) {
    return _vals.firstWhere((TimingAbbreviation v) => v.display == key,
        orElse: () => throw ArgumentError("Key does not match any TimingAbbreviation"));
  }
}

enum DetailStatus {
  @JsonValue('not-started')
  not_started,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in-progress')
  in_progress,
  @JsonValue('on-hold')
  on_hold,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('stopped')
  stopped,
  @JsonValue('unknown')
  unknown,
  @JsonValue('entered-in-error')
  entered_in_error
}

enum CarePlanStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('active')
  active,
  @JsonValue('suspended')
  suspended,
  @JsonValue('completed')
  completed,
  @JsonValue('entered-in-error')
  entered_in_error,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('unknown')
  unknown
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Questionnaire with Resource {
  final String resourceType;
  String id;
  Meta meta;
  String version;
  String name;
  String status;
  String description;
  List<QuestionnaireItem> item;

  @JsonKey(name: "title")
  String titleBase;
  @JsonKey(name: "_title")
  PrimitiveTypeExtension titleExt;

  @JsonKey(ignore: true)
  String get title => FhirTranslations.extractTranslation(titleBase, titleExt);

  Questionnaire(
      {this.resourceType = "Questionnaire",
      this.name,
      this.id,
      this.meta,
      this.version,
      this.titleBase,
      this.status,
      this.description,
      this.item});

  Future<void> loadValueSets() async {
    return Future.wait(item.map((QuestionnaireItem questionnaireItem) async {
      List<Future> futures = _loadValueSetsForSelfAndChildren(questionnaireItem);
      await Future.wait(futures);
    }));
  }

  List<Future> _loadValueSetsForSelfAndChildren(QuestionnaireItem item) {
    List<Future> futures = [item.loadValueSet()];
    item.item?.forEach((element) {
      futures.addAll(_loadValueSetsForSelfAndChildren(element));
    });
    return futures;
  }

  factory Questionnaire.fromJson(Map<String, dynamic> json) => _$QuestionnaireFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class CodeableConcept {
  List<Coding> coding;
  String text;

  CodeableConcept({this.coding, this.text});

  @override
  String toString() {
    return coding.toString();
  }

  factory CodeableConcept.fromJson(Map<String, dynamic> json) => _$CodeableConceptFromJson(json);

  Map<String, dynamic> toJson() => _$CodeableConceptToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CodeableConcept &&
          this.coding.any((Coding code1) {
            return other.coding.any((Coding code2) => code1 == code2);
          });

  @override
  int get hashCode => coding.hashCode;
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Coding implements ChoiceOption {
  String system;
  String code;
  @JsonKey(name: "display")
  String displayBase;
  @JsonKey(name: "_display")
  PrimitiveTypeExtension displayExt;

  @JsonKey(ignore: true)
  String get display => FhirTranslations.extractTranslation(displayBase, displayExt);

  @JsonKey(ignore: true)
  Answer get ifSelected => new Answer(valueCoding: this);

  Coding({this.system, this.code, this.displayBase});

  String identifierString() {
    return "$system|$code";
  }

  factory Coding.fromJson(Map<String, dynamic> json) => _$CodingFromJson(json);

  Map<String, dynamic> toJson() => _$CodingToJson(this);

  @override
  bool operator ==(other) {
    if (other is! Coding) return false;
    Coding o = other;
    return o.system == this.system && o.code == this.code;
  }

  @override
  int get hashCode => system.hashCode ^ code.hashCode;
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Extension {
  Address valueAddress;

  String url;
  String valueCanonical;
  ValueExpression valueExpression;
  CodeableConcept valueCodeableConcept;
  Coding valueCoding;
  String valueString;
  String valueCode;
  bool valueBoolean;
  int valueDecimal;
  String valueUri;
  List<Extension> extension;

  Extension(
      {this.valueString,
      this.valueCode,
      this.valueBoolean,
      this.valueDecimal,
      this.url,
      this.valueCanonical,
      this.valueExpression,
      this.valueCodeableConcept,
      this.valueCoding,
      this.valueAddress,
      this.valueUri,
      this.extension});

  factory Extension.fromJson(Map<String, dynamic> json) => _$ExtensionFromJson(json);

  Map<String, dynamic> toJson() => _$ExtensionToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ValueExpression {
  String language;
  String expression;

  ValueExpression({this.language, this.expression});

  factory ValueExpression.fromJson(Map<String, dynamic> json) => _$ValueExpressionFromJson(json);

  Map<String, dynamic> toJson() => _$ValueExpressionToJson(this);
}

enum QuestionType {
  @JsonValue('group')
  group,
  @JsonValue('display')
  display,

// question types
  @JsonValue('boolean')
  boolean,
  @JsonValue('decimal')
  decimal,
  @JsonValue('integer')
  integer,
  @JsonValue('date')
  date,
  @JsonValue('dateTime')
  dateTime,
  @JsonValue('time')
  time,
  @JsonValue('string')
  string,
  @JsonValue('text')
  text,
  @JsonValue('url')
  url,
  @JsonValue('choice')
  choice,
  @JsonValue('open-choice')
  open_choice,
  @JsonValue('attachment')
  attachment,
  @JsonValue('reference')
  reference,
  @JsonValue('quantity')
  quantity
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class QuestionnaireItem {
  String linkId;

  bool required;
  QuestionType type;
  List<Coding> code;
  List<AnswerOption> answerOption;
  String answerValueSetAddress;
  List<Coding> answerValueSet;
  List<Extension> extension;
  List<QuestionnaireItem> item;

  @JsonKey(name: "text")
  String textBase;
  @JsonKey(name: "_text")
  PrimitiveTypeExtension textExt;

  @JsonKey(ignore: true)
  String get text => FhirTranslations.extractTranslation(textBase, textExt);

  QuestionnaireItem(
      {this.linkId,
      this.textBase,
      this.required,
      this.type,
      this.code,
      this.answerOption,
      this.answerValueSetAddress,
      this.answerValueSet,
      this.extension,
      this.item});

  bool isSupported() {
    return type == QuestionType.choice ||
        type == QuestionType.decimal ||
        type == QuestionType.string ||
        type == QuestionType.display ||
        type == QuestionType.date;
  }

  bool isTemperature() {
    return code != null &&
        code
                .firstWhere((Coding c) => c.system != null && c.system.contains("loinc"),
                    orElse: () => null)
                ?.code ==
            "8310-5";
  }

  loadValueSet() async {
    if (answerValueSetAddress != null) {
      ValueSet answers = await Repository.getValueSet(answerValueSetAddress);
      answerValueSet = answers.expansion.contains;
    }
  }

  @JsonKey(ignore: true)
  List<ChoiceOption> get choiceOptions => answerOption ?? answerValueSet;

  @JsonKey(ignore: true)
  int get choiceCount => choiceOptions != null ? choiceOptions.length : 0;

  @JsonKey(ignore: true)
  String get helpText {
    // find the first sub item that has a help type extension
    QuestionnaireItem helpTextSubItem = item?.firstWhere((QuestionnaireItem subItem) =>
        subItem.extension != null &&
        subItem.extension.any((Extension extension) =>
            extension.valueCodeableConcept != null &&
            extension.valueCodeableConcept.coding != null &&
            extension.valueCodeableConcept.coding.any((Coding coding) =>
                coding.code == "help" &&
                coding.system == "http://hl7.org/fhir/questionnaire-item-control")));
    return helpTextSubItem?.text;
  }

  @JsonKey(ignore: true)
  SupportLink get supportLink {
    String supportLinkExtName = "http://hl7.org/fhir/StructureDefinition/questionnaire-supportLink";
    // find the first sub item that has a supportLink type extension
    QuestionnaireItem supportLinkSubItem = item?.firstWhere(
        (QuestionnaireItem subItem) =>
            subItem.extension != null &&
            subItem.extension.any((Extension extension) =>
                extension.url != null && extension.url == supportLinkExtName),
        orElse: () => null);
    if (supportLinkSubItem == null) return null;
    // find the supportLink extension value
    Extension supportLinkExt = supportLinkSubItem.extension.firstWhere(
        (Extension extension) => extension.url != null && extension.url == supportLinkExtName);
    return SupportLink(title: supportLinkSubItem.text, url: supportLinkExt.valueUri);
  }

  factory QuestionnaireItem.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireItemFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireItemToJson(this);

  bool isGroup() {
    return type == QuestionType.group;
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SupportLink {
  final String title;
  final String url;

  SupportLink({this.title, this.url});
}

abstract class ChoiceOption {
  Answer get ifSelected;

  String get display;
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class AnswerOption implements ChoiceOption {
  int valueInteger;
  List<Extension> extension;
  Coding valueCoding;

  @JsonKey(ignore: true)
  Answer get ifSelected => new Answer.fromAnswerOption(this);

  AnswerOption({this.valueInteger, this.extension, this.valueCoding});

  factory AnswerOption.fromJson(Map<String, dynamic> json) => _$AnswerOptionFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerOptionToJson(this);

  @override
  String get display {
    if (valueInteger != null) return '$valueInteger';
    if (valueCoding != null) return valueCoding.display;
    return super.toString();
  }

  /// returns -1 if there is no ordinal value.
  int ordinalValue() {
    if (extension == null) return -1;
    Extension ordinalValueExtension = extension.firstWhere(
        (Extension e) => e.url == 'http://hl7.org/fhir/StructureDefinition/ordinalValue');
    if (ordinalValueExtension != null) {
      return ordinalValueExtension.valueDecimal;
    }
    return -1;
  }
}

/// https://www.hl7.org/fhir/questionnaireresponse.html
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class QuestionnaireResponse with Resource {
  final String resourceType;
  String id;
  Meta meta;
  String questionnaire;
  List<Reference> basedOn;
  Reference subject;
  DateTime authored;
  List<QuestionnaireResponseItem> item;
  QuestionnaireResponseStatus status;

  QuestionnaireResponse(
      {this.resourceType = "QuestionnaireResponse",
      this.id,
      this.meta,
      this.questionnaire,
      this.basedOn,
      this.subject,
      this.authored,
      this.item,
      this.status});

  QuestionnaireResponse.from(Questionnaire questionnaire, this.subject, CarePlan carePlan,
      {this.resourceType = "QuestionnaireResponse", this.id, this.meta, this.status, this.item}) {
    if (this.item == null) {
      this.item = [];
    }
    this.questionnaire = questionnaire.reference;
    this.basedOn = [Reference(reference: carePlan.reference)];
    var today = new DateTime.now();
    this.authored = new DateTime(today.year, today.month, today.day, today.hour, today.minute);
  }

  @JsonKey(ignore: true)
  bool get isEmpty =>
      this.item == null ||
      this.item.isEmpty ||
      this.item.every((QuestionnaireResponseItem element) => element.isEmpty);

  factory QuestionnaireResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireResponseToJson(this);

  void setAnswer(String linkId, Answer answer) {
    if (answer == null || answer.isEmpty) {
      removeResponseItem(linkId);
    } else {
      var responseItem = getResponseItem(linkId);
      if (responseItem != null) {
        responseItem.answer = [answer]; // single response
      } else {
        this.item.add(new QuestionnaireResponseItem(linkId: linkId, answer: [answer]));
      }
    }
  }

  Answer getAnswer(String linkId) {
    List<Answer> answers = getResponseItem(linkId)?.answer;
    if (answers != null && answers.length > 0) return answers[0];
    return null;
  }

  void removeResponseItem(String linkId) {
    if (item != null) {
      item.removeWhere((QuestionnaireResponseItem element) => element.linkId == linkId);
    }
  }

  QuestionnaireResponseItem getResponseItem(String linkId) {
    for (QuestionnaireResponseItem responseItem in item) {
      if (responseItem.linkId == linkId) {
        return responseItem;
      }
    }
    return null;
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Content {
  Attachment attachment;

  Content({this.attachment});

  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class DocumentReference {
  //	"type" : Loinc 48766-0 	(Information source)
  //	"description": string
  //	"status": "current"
  //	"content": [{ // R!  Document referenced
  //    "attachment" : { Attachment }, // R!  Where to access the document
  //    "format" : { Coding } // Format/content rules for the document
  //  }],
  String description;
  List<Content> content;
  CodeableConcept type;
  String status;

  DocumentReference({this.description, this.content, this.type, this.status});

  bool isGroup() {
    return content != null && content.length > 1 && description != null;
  }

  @JsonKey(ignore: true)
  String get url => content != null && content.length > 0 && content[0].attachment != null
      ? content[0].attachment.url
      : "";

  factory DocumentReference.fromJson(Map<String, dynamic> json) =>
      _$DocumentReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentReferenceToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Attachment {
  String url;
  String title;

  Attachment({this.url, this.title});

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Reference {
  String reference;

  Reference({this.reference});

  factory Reference.fromJson(Map<String, dynamic> json) => _$ReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ReferenceToJson(this);

  Reference.from(Resource resource) : this(reference: resource.reference);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Reference && reference == other.reference;

  @override
  int get hashCode => reference.hashCode;
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class QuestionnaireResponseItem {
  String linkId;
  List<Answer> answer;

  @JsonKey(ignore: true)
  bool get isEmpty => answer == null || answer.isEmpty || answer.every((Answer a) => a.isEmpty);

  QuestionnaireResponseItem({this.linkId, this.answer});

  @JsonKey(ignore: true)
  String get answerDisplay {
    if (answer == null || answer.isEmpty) return "";
    return answer.map((e) => e.displayString).join(",");
  }

  factory QuestionnaireResponseItem.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireResponseItemFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireResponseItemToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Answer {
  int valueInteger;
  double valueDecimal;
  Coding valueCoding;
  String valueString;
  DateTime valueDate;
  DateTime valueDateTime;

  @JsonKey(ignore: true)
  bool get isEmpty =>
      valueInteger == null &&
      valueDecimal == null &&
      valueCoding == null &&
      (valueString == null || valueString.isEmpty) &&
      valueDate == null &&
      valueDateTime == null;

  Answer(
      {this.valueDecimal,
      this.valueInteger,
      this.valueCoding,
      this.valueString,
      this.valueDate,
      this.valueDateTime});

  @JsonKey(ignore: true)
  String get displayString {
    if (this.valueDate != null) {
      return DateFormat.yMd().format(this.valueDate);
    }
    if (this.valueDateTime != null) {
      return DateFormat.yMd().add_jm().format(this.valueDateTime);
    }
    if (this.valueInteger != null || this.valueDecimal != null) {
      return NumberFormat.decimalPattern().format(this.valueInteger ?? this.valueDecimal);
    }
    return this.toLocalizedString;
  }

  bool operator ==(dynamic o) {
    if (o is Answer) {
      Answer other = o;
      return valueInteger == other.valueInteger &&
          valueCoding == other.valueCoding &&
          valueDecimal == other.valueDecimal &&
          valueString == other.valueString &&
          valueDate == other.valueDate &&
          valueDateTime == other.valueDateTime;
    } else if (o is AnswerOption) {
      AnswerOption other = o;
      return valueInteger == other.valueInteger && valueCoding == other.valueCoding;
    } else if (o is Coding) {
      Coding other = o;
      return valueInteger == null && other == valueCoding;
    }

    return false;
  }

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + valueInteger;
    if (valueCoding != null) {
      result = 37 * result + valueCoding.hashCode;
    }
    if (valueString != null) {
      result = 37 * result + valueString.hashCode;
    }
    if (valueDate != null) {
      result = 37 * result + valueDate.hashCode;
    }
    if (valueDateTime != null) {
      result = 37 * result + valueDateTime.hashCode;
    }
    return result;
  }

  @JsonKey(ignore: true)
  String get toLocalizedString {
    if (valueInteger != null) return '$valueInteger';
    if (valueCoding != null) return valueCoding.display;
    if (valueDecimal != null) return valueDecimal.toString();
    if (valueString != null) return valueString;
    if (valueDate != null) return valueDate.toString();
    if (valueDateTime != null) return valueDateTime.toString();
    return '';
  }

  factory Answer.fromAnswerOption(AnswerOption option) {
    return Answer.fromJson(option.toJson());
  }

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ValueSet with Resource {
  final String resourceType;
  String id;
  Meta meta;
  String language;
  String url;
  String status;
  Expansion expansion;

  ValueSet(
      {this.resourceType = "ValueSet",
      this.id,
      this.language,
      this.url,
      this.status,
      this.expansion});

  factory ValueSet.fromJson(Map<String, dynamic> json) => _$ValueSetFromJson(json);

  Map<String, dynamic> toJson() => _$ValueSetToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Expansion {
  String identifier;
  String timestamp;
  int total;
  List<Parameter> parameter;
  List<Coding> contains;

  Expansion({this.identifier, this.timestamp, this.total, this.parameter, this.contains});

  factory Expansion.fromJson(Map<String, dynamic> json) => _$ExpansionFromJson(json);

  Map<String, dynamic> toJson() => _$ExpansionToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Parameter {
  String name;
  String valueUri;
  int valueInteger;

  Parameter({this.name, this.valueUri, this.valueInteger});

  factory Parameter.fromJson(Map<String, dynamic> json) => _$ParameterFromJson(json);

  Map<String, dynamic> toJson() => _$ParameterToJson(this);
}
