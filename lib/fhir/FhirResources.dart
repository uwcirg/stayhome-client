/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
import 'package:map_app_flutter/services/Repository.dart';

class Resource {
  String resourceType;
  String id;

  Resource({this.resourceType, this.id});

  get reference => "$resourceType/$id";
}

class Gender {
  final _value;

  const Gender._(this._value);

  toString() => _value;

  static fromJson(String key) {
    return _vals.firstWhere((v) => v._value == key,
        orElse: () => throw ArgumentError("Key does not match any Gender"));
  }

  static const male = const Gender._('male');
  static const female = const Gender._('female');
  static const other = const Gender._('other');
  static const unknown = const Gender._('unknown');

  static const _vals = [male, female, other, unknown];
}

class CommunicationStatus {
  final _value;

  const CommunicationStatus._(this._value);

  toString() => _value;

  static fromJson(String key) {
    return _vals.firstWhere((v) => v._value == key,
        orElse: () => throw ArgumentError("Key does not match any CommunicationStatus"));
  }

  static const preparation = const CommunicationStatus._('preparation');
  static const in_progress = const CommunicationStatus._('in-progress');
  static const not_done = const CommunicationStatus._('not-done');
  static const on_hold = const CommunicationStatus._('on-hold');
  static const stopped = const CommunicationStatus._('stopped');
  static const completed = const CommunicationStatus._('completed');
  static const entered_in_error = const CommunicationStatus._('entered-in-error');
  static const unknown = const CommunicationStatus._('unknown');

  static const _vals = [
    preparation,
    in_progress,
    not_done,
    on_hold,
    stopped,
    completed,
    entered_in_error,
    unknown
  ];
}

class Priority {
  final _value;

  const Priority._(this._value);

  toString() => _value;

  static fromJson(String key) {
    return _vals.firstWhere((v) => v._value == key,
        orElse: () => throw ArgumentError("Key does not match any Priority"));
  }

  static const routine = const Priority._('routine');
  static const urgent = const Priority._('urgent');
  static const asap = const Priority._('asap');
  static const stat = const Priority._('stat');

  static const _vals = [routine, urgent, asap, stat];
}

class Communication extends Resource {
  Meta meta;
  CommunicationStatus status;
  Priority priority;
  List<CodeableConcept> category;
  List<Reference> recipient;
  List<Payload> payload;
  DateTime sent;

  Communication(
      {resourceType,
      id,
      this.meta,
      this.status,
      this.priority,
      this.category,
      this.recipient,
      this.payload,
      this.sent})
      : super(resourceType: "Communication", id: id);

  Communication.fromJson(Map<String, dynamic> json) {
    resourceType = json['resourceType'];
    id = json['id'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;

    if (json['status'] != null) status = CommunicationStatus.fromJson(json['status']);
    if (json['priority'] != null) priority = Priority.fromJson(json['priority']);
    if (json['category'] != null) {
      category = new List<CodeableConcept>();
      json['category'].forEach((v) {
        category.add(new CodeableConcept.fromJson(v));
      });
    }
    if (json['recipient'] != null) {
      recipient = new List<Reference>();
      json['recipient'].forEach((v) {
        recipient.add(new Reference.fromJson(v));
      });
    }
    if (json['payload'] != null) {
      payload = new List<Payload>();
      json['payload'].forEach((v) {
        payload.add(new Payload.fromJson(v));
      });
    }
    if (json['sent'] != null) sent = DateTime.parse(json['sent']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.id != null) data['id'] = id;
    if (this.resourceType != null) data['resourceType'] = resourceType;
    if (this.meta != null) data['meta'] = meta.toJson();
    if (this.status != null) data['status'] = status.toString();
    if (this.priority != null) data['priority'] = priority.toString();
    if (this.category != null) data['category'] = this.category.map((v) => v.toJson()).toList();
    if (this.recipient != null) data['recipient'] = this.recipient.map((v) => v.toJson()).toList();
    if (this.payload != null) data['payload'] = this.payload.map((v) => v.toJson()).toList();
    if (this.sent != null) data['sent'] = sent.toIso8601String();

    return data;
  }
}

class Payload {
  String contentString;
  Attachment contentAttachment;
  Reference contentReference;

  Payload({this.contentString, this.contentAttachment, this.contentReference});

  Payload.fromJson(Map<String, dynamic> json) {
    contentString = json['contentString'];
    if (json['contentAttachment'] != null)
      contentAttachment = Attachment.fromJson(json['contentAttachment']);
    if (json['contentReference'] != null)
      contentReference = Reference.fromJson(json['contentReference']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contentString != null) data['contentString'] = this.contentString;
    if (this.contentAttachment != null) data['contentAttachment'] = this.contentAttachment.toJson();
    if (this.contentReference != null) data['contentReference'] = this.contentReference.toJson();
    return data;
  }
}

class Patient extends Resource {
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
      {String resourceType,
      String id,
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
      this.communication})
      : super(resourceType: "Patient", id: id);

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
    patient.resourceType = "Patient";
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

  String get firstName => this.name != null &&
          this.name.length > 0 &&
          this.name[0].given != null &&
          this.name[0].given.length > 0
      ? this.name[0].given[0]
      : null;

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

  set firstName(String text) {
    if (this.name == null || this.name.isEmpty) this.name = [HumanName()];
    if (this.name[0].given == null || this.name[0].given.length == 0) this.name[0].given = [""];
    this.name[0].given[0] = text;
  }

  String get lastName => this.name != null && this.name.length > 0 && this.name[0].family != null
      ? this.name[0].family
      : null;

  set lastName(String text) {
    if (this.name == null || this.name.isEmpty) this.name = [HumanName()];
    this.name[0].family = text;
  }

  set emailAddress(String text) {
    this.telecom ??= [];
    ContactPoint p = _contactPointForSystem(ContactPointSystem.email);
    if (p == null) {
      this.telecom.add(ContactPoint(system: ContactPointSystem.email, value: text));
    } else {
      p.value = text;
    }
  }

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

  ContactPointSystem get preferredContactMethod => this.telecom != null && this.telecom.length > 0
      ? this
          .telecom
          .firstWhere((ContactPoint p) => p.rank == 1, orElse: () => ContactPoint())
          .system
      : null;

  String get emailAddress {
    ContactPoint p = _contactPointForSystem(ContactPointSystem.email);
    return p != null ? p.value : null;
  }

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

  String get homeZip => this.address != null && this.address.length > 0
      ? this
          .address
          .firstWhere((Address a) => a.use == AddressUse.home, orElse: () => Address())
          .postalCode
      : null;

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

  String get secondZip => this.address != null && this.address.length > 0
      ? this
          .address
          .firstWhere((Address a) => a.use != AddressUse.home, orElse: () => Address())
          .postalCode
      : null;

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

  Patient.fromJson(Map<String, dynamic> json) {
    resourceType = json['resourceType'];
    id = json['id'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    text = json['text'] != null ? new Narrative.fromJson(json['text']) : null;
    if (json['extension'] != null) {
      extension = new List<Extension>();
      json['extension'].forEach((v) {
        extension.add(new Extension.fromJson(v));
      });
    }
    if (json['birthDate'] != null) {
      birthDate = DateTime.parse(json['birthDate']);
    }
    if (json['identifier'] != null) {
      identifier = new List<Identifier>();
      json['identifier'].forEach((v) {
        identifier.add(new Identifier.fromJson(v));
      });
    }
    if (json['name'] != null) {
      name = new List<HumanName>();
      json['name'].forEach((v) {
        name.add(new HumanName.fromJson(v));
      });
    }
    if (json['telecom'] != null) {
      telecom = new List<ContactPoint>();
      json['telecom'].forEach((v) {
        telecom.add(new ContactPoint.fromJson(v));
      });
    }
    if (json['gender'] != null) gender = Gender.fromJson(json['gender']);
    if (json['address'] != null) {
      address = new List<Address>();
      json['address'].forEach((v) {
        address.add(new Address.fromJson(v));
      });
    }
    maritalStatus =
        json['maritalStatus'] != null ? new CodeableConcept.fromJson(json['maritalStatus']) : null;
    multipleBirthBoolean = json['multipleBirthBoolean'];
    if (json['communication'] != null) {
      communication = new List<PatientCommunication>();
      json['communication'].forEach((v) {
        communication.add(new PatientCommunication.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resourceType'] = this.resourceType;
    if (this.id != null) data['id'] = this.id;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    if (this.text != null) {
      data['text'] = this.text.toJson();
    }
    if (this.extension != null && this.extension.length > 0) {
      data['extension'] = this.extension.map((v) => v.toJson()).toList();
    }
    if (this.identifier != null && this.identifier.length > 0) {
      data['identifier'] = this.identifier.map((v) => v.toJson()).toList();
    }
    if (this.name != null && this.name.length > 0) {
      data['name'] = this.name.map((v) => v.toJson()).toList();
    }
    if (this.telecom != null && this.telecom.length > 0) {
      data['telecom'] = this.telecom.map((v) => v.toJson()).toList();
    }
    if (this.gender != null) data['gender'] = this.gender.toString();
    if (this.birthDate != null) data['birthDate'] = this.birthDate;
    if (this.address != null && this.address.length > 0) {
      data['address'] = this.address.map((v) => v.toJson()).toList();
    }
    if (this.maritalStatus != null) {
      data['maritalStatus'] = this.maritalStatus.toJson();
    }
    if (this.multipleBirthBoolean != null) data['multipleBirthBoolean'] = this.multipleBirthBoolean;
    if (this.communication != null && this.communication.length > 0) {
      data['communication'] = this.communication.map((v) => v.toJson()).toList();
    }
    if (this.birthDate != null) data['birthDate'] = this.birthDate.toIso8601String();
    return data;
  }
}

class Meta {
  String versionId;
  String lastUpdated;

  Meta({this.versionId, this.lastUpdated});

  Meta.fromJson(Map<String, dynamic> json) {
    versionId = json['versionId'];
    lastUpdated = json['lastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['versionId'] = this.versionId;
    data['lastUpdated'] = this.lastUpdated;
    return data;
  }
}

class Narrative {
  String status;
  String div;

  Narrative({this.status, this.div});

  Narrative.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    div = json['div'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['div'] = this.div;
    return data;
  }
}

class HumanName {
  String use;
  String family;
  List<String> given;

  HumanName({this.use, this.family, this.given});

  HumanName.fromJson(Map<String, dynamic> json) {
    use = json['use'];
    family = json['family'];
    if (json['given'] != null) given = json['given'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.use != null) data['use'] = this.use;
    if (this.family != null) data['family'] = this.family;
    if (this.given != null && this.given.length > 0) data['given'] = this.given;
    return data;
  }
}

class ContactPoint {
  ContactPointSystem system;
  String value;
  String use;
  int rank;

  ContactPoint({this.system, this.value, this.use, this.rank});

  ContactPoint.fromJson(Map<String, dynamic> json) {
    if (json['system'] != null) system = ContactPointSystem.fromJson(json['system']);
    value = json['value'];
    use = json['use'];
    if (json['rank'] != null) rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.system != null) data['system'] = this.system.toString();
    if (this.value != null) data['value'] = this.value;
    if (this.use != null) data['use'] = this.use;
    if (this.rank != null) data['rank'] = this.rank;
    return data;
  }
}

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

  Address.fromJson(Map<String, dynamic> json) {
    if (json['extension'] != null) {
      extension = new List<Extension>();
      json['extension'].forEach((v) {
        extension.add(new Extension.fromJson(v));
      });
    }
    if (json['line'] != null) {
      line = json['line'].cast<String>();
    }
    city = json['city'];
    if (json['use'] != null) use = AddressUse.fromJson(json['use']);
    district = json['district'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.extension != null) {
      data['extension'] = this.extension.map((v) => v.toJson()).toList();
    }
    if (this.line != null) data['line'] = this.line;
    if (this.use != null) data['use'] = this.use.toString();
    if (this.city != null) data['city'] = this.city;
    if (this.district != null) data['district'] = this.district;
    if (this.state != null) data['state'] = this.state;
    if (this.postalCode != null) data['postalCode'] = this.postalCode;
    if (this.country != null) data['country'] = this.country;
    return data;
  }

  @override
  String toString() {
    return "${line.join(', ')}, $city, $state $postalCode";
  }
}

class PatientCommunication {
  CodeableConcept language;

  PatientCommunication({this.language});

  PatientCommunication.fromJson(Map<String, dynamic> json) {
    language = json['language'] != null ? new CodeableConcept.fromJson(json['language']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.language != null) {
      data['language'] = this.language.toJson();
    }
    return data;
  }
}

class AddressUse {
  final _value;

  const AddressUse._(this._value);

  toString() => _value;

  static fromJson(String key) {
    return _vals.firstWhere((v) => v._value == key,
        orElse: () => throw ArgumentError("Key does not match any Use"));
  }

  static const home = const AddressUse._('home');
  static const work = const AddressUse._('work');
  static const temp = const AddressUse._('temp');
  static const old = const AddressUse._('old');
  static const billing = const AddressUse._('billing');

  static const _vals = [home, work, temp, old, billing];
}

class ContactPointSystem {
  final _value;

  const ContactPointSystem._(this._value);

  toString() => _value;

  static fromJson(String key) {
    return _vals.firstWhere((v) => v._value == key,
        orElse: () => throw ArgumentError("Key does not match any ContactPointSystem"));
  }

  static const phone = const ContactPointSystem._('phone');
  static const fax = const ContactPointSystem._('fax');
  static const email = const ContactPointSystem._('email');
  static const pager = const ContactPointSystem._('pager');
  static const url = const ContactPointSystem._('url');
  static const sms = const ContactPointSystem._('sms');
  static const other = const ContactPointSystem._('other');

  static const _vals = [phone, fax, email, pager, url, sms, other];
}

class ProcedureStatus {
  final _value;

  const ProcedureStatus._(this._value);

  toString() => _value;

  static fromJson(String key) {
    return _vals.firstWhere((v) => v._value == key,
        orElse: () => throw ArgumentError("Key does not match any ProcedureStatus"));
  }

  static const preparation = const ProcedureStatus._('preparation');
  static const in_progress = const ProcedureStatus._('in-progress');
  static const not_done = const ProcedureStatus._('not-done');
  static const suspended = const ProcedureStatus._('suspended');
  static const aborted = const ProcedureStatus._('aborted');
  static const completed = const ProcedureStatus._('completed');
  static const entered_in_error = const ProcedureStatus._('entered-in-error');
  static const unknown = const ProcedureStatus._('unknown');

  static const _vals = [
    preparation,
    in_progress,
    not_done,
    suspended,
    aborted,
    completed,
    entered_in_error,
    unknown
  ];
}

class QuestionnaireResponseStatus {
  final _value;

  const QuestionnaireResponseStatus._(this._value);

  toString() => _value;

  static fromJson(String key) {
    return _vals.firstWhere((v) => v._value == key,
        orElse: () => throw ArgumentError("Key does not match any QuestionnaireResponseStatus"));
  }

  static const in_progress = const QuestionnaireResponseStatus._('in-progress');
  static const stopped = const QuestionnaireResponseStatus._('stopped');
  static const completed = const QuestionnaireResponseStatus._('completed');
  static const amended = const QuestionnaireResponseStatus._('amended');
  static const entered_in_error = const QuestionnaireResponseStatus._('entered-in-error');

  static const _vals = [in_progress, stopped, completed, amended, entered_in_error];
}

class Procedure extends Resource {
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
      {resourceType,
      id,
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
      this.instantiatesQuestionnaire})
      : super(resourceType: "Procedure", id: id);

  Procedure.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resourceType = json['resourceType'];
    text = json['text'] != null ? new Narrative.fromJson(json['text']) : null;
    if (json['identifier'] != null) {
      identifier = new List<Identifier>();
      json['identifier'].forEach((v) {
        identifier.add(new Identifier.fromJson(v));
      });
    }
    if (json['basedOn'] != null) {
      basedOnCarePlan = new List<Reference>();
      json['basedOn'].forEach((v) {
        basedOnCarePlan.add(new Reference.fromJson(v));
      });
    }
    if (json['instantiatesQuestionnaire'] != null)
      instantiatesQuestionnaire = json['instantiatesQuestionnaire'].cast<String>();
    if (json['status'] != null) {
      status = ProcedureStatus.fromJson(json['status']);
    }
    statusReason =
        json['statusReason'] != null ? new CodeableConcept.fromJson(json['statusReason']) : null;
    category = json['category'] != null ? new CodeableConcept.fromJson(json['category']) : null;
    code = json['code'] != null ? new CodeableConcept.fromJson(json['code']) : null;
    performedPeriod =
        json['performedPeriod'] != null ? new Period.fromJson(json['performedPeriod']) : null;
    subject = json['subject'] != null ? new Reference.fromJson(json['subject']) : null;
    if (json['performedDateTime'] != null) {
      performedDateTime = DateTime.parse(json['performedDateTime']);
    }
    if (json['reasonCode'] != null) {
      reasonCode = new List<CodeableConcept>();
      json['reasonCode'].forEach((v) {
        reasonCode.add(new CodeableConcept.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resourceType'] = this.resourceType;
    data['id'] = this.id;
    if (this.text != null) {
      data['text'] = this.text.toJson();
    }
    if (this.identifier != null) {
      data['identifier'] = this.identifier.map((v) => v.toJson()).toList();
    }
    if (this.basedOnCarePlan != null) {
      data['basedOn'] = this.basedOnCarePlan.map((v) => v.toJson()).toList();
    }
    if (this.instantiatesQuestionnaire != null) {
      data['instantiatesQuestionnaire'] = instantiatesQuestionnaire;
    }
    data['status'] = this.status.toString();
    if (this.statusReason != null) {
      data['statusReason'] = this.statusReason.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.code != null) {
      data['code'] = this.code.toJson();
    }
    if (this.subject != null) {
      data['subject'] = this.subject.toJson();
    }
    data['performedDateTime'] = this.performedDateTime.toIso8601String();
    if (this.reasonCode != null) {
      data['reasonCode'] = this.reasonCode.map((v) => v.toJson()).toList();
    }
    if (this.performedPeriod != null) {
      data['performedPeriod'] = this.performedPeriod.toJson();
    }
    return data;
  }

  Procedure.treatmentSession(int minutes, CarePlan carePlan,
      {resourceType, id, this.status, this.code})
      : super(resourceType: "Procedure", id: id) {
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

class CarePlan extends Resource {
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
      {resourceType,
      id,
      this.identifier,
      this.basedOn,
      this.status,
      this.intent,
      this.category,
      this.description,
      this.subject,
      this.period,
      this.created,
      this.activity})
      : super(resourceType: "CarePlan", id: id);

  CarePlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resourceType = json['resourceType'];
    if (json['identifier'] != null) {
      identifier = new List<Identifier>();
      json['identifier'].forEach((v) {
        identifier.add(new Identifier.fromJson(v));
      });
    }
    if (json['basedOn'] != null) {
      basedOn = new List<Reference>();
      json['basedOn'].forEach((v) {
        basedOn.add(Reference.fromJson(v));
      });
    }

    if (json['status'] != null) {
      status = CarePlanStatus.fromJson(json['status']);
    }
    intent = json['intent'];
    if (json['category'] != null) {
      category = new List<CodeableConcept>();
      json['category'].forEach((v) {
        category.add(new CodeableConcept.fromJson(v));
      });
    }
    description = json['description'];
    subject = json['subject'] != null ? new Reference.fromJson(json['subject']) : null;
    period = json['period'] != null ? new Period.fromJson(json['period']) : null;
    if (json['created'] != null) created = DateTime.parse(json["created"]);
    if (json['activity'] != null) {
      activity = new List<Activity>();
      json['activity'].forEach((v) {
        activity.add(new Activity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['resourceType'] = this.resourceType;
    if (this.identifier != null) {
      data['identifier'] = this.identifier.map((v) => v.toJson()).toList();
    }
    if (this.basedOn != null) {
      data['basedOn'] = this.basedOn.map((v) => v.toJson()).toList();
    }
    if (this.status != null) {
      data['status'] = this.status.toString();
    }
    data['intent'] = this.intent;
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    if (this.subject != null) {
      data['subject'] = this.subject.toJson();
    }
    if (this.period != null) {
      data['period'] = this.period.toJson();
    }
    if (this.created != null) {
      data['created'] = this.created.toIso8601String();
    }
    if (this.activity != null) {
      data['activity'] = this.activity.map((v) => v.toJson()).toList();
    }
    return data;
  }

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
          .any((String instantiated) => instantiated.startsWith(Questionnaire.resourceTypeName));
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
          return activity.detail.instantiatesCanonical[0]
              .startsWith(Questionnaire.resourceTypeName);
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

class Identifier {
  String value;
  String system;

  Identifier({this.value, this.system});

  Identifier.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    system = json['system'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['system'] = this.system;
    return data;
  }
}

class Period {
  DateTime start;
  DateTime end;

  Period({this.start, this.end});

  Period.fromJson(Map<String, dynamic> json) {
    if (json['start'] != null) start = DateTime.parse(json['start']);
    if (json['end'] != null) end = DateTime.parse(json['end']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start.toIso8601String();
    data['end'] = this.end.toIso8601String();
    return data;
  }
}

class Activity {
  Detail detail;

  Activity({this.detail});

  Activity.fromJson(Map<String, dynamic> json) {
    detail = json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detail != null) {
      data['detail'] = this.detail.toJson();
    }
    return data;
  }
}

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

  Detail.fromJson(Map<String, dynamic> json) {
    code = json['code'] != null ? new CodeableConcept.fromJson(json['code']) : null;
    if (json['status'] != null) {
      status = DetailStatus.fromJson(json['status']);
    }
    statusReason =
        json['statusReason'] != null ? new CodeableConcept.fromJson(json['statusReason']) : null;
    doNotPerform = json['doNotPerform'];
    scheduledTiming =
        json['scheduledTiming'] != null ? new Timing.fromJson(json['scheduledTiming']) : null;
    scheduledPeriod =
        json['scheduledPeriod'] != null ? new Period.fromJson(json['scheduledPeriod']) : null;
    description = json['description'];
    if (json['instantiatesCanonical'] != null) {
      instantiatesCanonical = new List<String>();
      json['instantiatesCanonical'].forEach((v) {
        instantiatesCanonical.add(v);
      });
    }
    if (json['reasonReference'] != null) {
      reasonReference = new List<Reference>();
      json['reasonReference'].forEach((v) {
        reasonReference.add(Reference.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.code != null) {
      data['code'] = this.code.toJson();
    }
    if (this.status != null) data['status'] = this.status.toString();
    if (this.statusReason != null) {
      data['statusReason'] = this.statusReason.toJson();
    }
    data['doNotPerform'] = this.doNotPerform;
    if (this.scheduledTiming != null) {
      data['scheduledTiming'] = this.scheduledTiming.toJson();
    }
    if (this.scheduledPeriod != null) {
      data['scheduledPeriod'] = this.scheduledPeriod.toJson();
    }
    data['description'] = description;
    if (this.instantiatesCanonical != null) {
      data['instantiatesCanonical'] = this.instantiatesCanonical.map((v) => v).toList();
    }
    if (this.reasonReference != null) {
      data['reasonReference'] = this.reasonReference.map((Reference v) => v.toJson()).toList();
    }
    return data;
  }
}

class Timing {
  Repeat repeat;
  CodeableConcept code;

  Timing({this.repeat});

  Timing.fromJson(Map<String, dynamic> json) {
    repeat = json['repeat'] != null ? new Repeat.fromJson(json['repeat']) : null;
    code = json['code'] != null ? CodeableConcept.fromJson(json['code']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.repeat != null) {
      data['repeat'] = this.repeat.toJson();
    }
    if (this.code != null) {
      data['code'] = this.code.toJson();
    }
    return data;
  }
}

class Repeat {
  double duration;
  String durationUnit;
  int frequency;
  double period;
  String periodUnit;

  Repeat({this.frequency, this.period, this.periodUnit, this.durationUnit, this.duration});

  Repeat.fromJson(Map<String, dynamic> json) {
    frequency = json['frequency'];
    period = json['period'].toDouble();
    if (json['duration'] != null) duration = json['duration'].toDouble();
    periodUnit = json['periodUnit'];
    durationUnit = json['durationUnit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['frequency'] = this.frequency;
    data['period'] = this.period;
    data['periodUnit'] = this.periodUnit;
    data['duration'] = this.duration;
    data['durationUnit'] = this.durationUnit;
    return data;
  }
}

class Range {
  SimpleQuantity low;
  SimpleQuantity high;

  Range({this.low, this.high});

  factory Range.fromJson(Map<String, dynamic> json) {
    return Range(
      low: SimpleQuantity.fromJson(json["low"]),
      high: SimpleQuantity.fromJson(json["high"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "low": this.low,
      "high": this.high,
    };
  }
}

class SimpleQuantity {
  double value;
  String unit;
  String system;
  String code;

  SimpleQuantity({this.value, this.unit, this.system, this.code});

  Map<String, dynamic> toJson() {
    return {
      "value": this.value,
      "unit": this.unit,
      "system": this.system,
      "code": this.code,
    };
  }

  factory SimpleQuantity.fromJson(Map<String, dynamic> json) {
    return SimpleQuantity(
      value: double.parse(json["value"]),
      unit: json["unit"],
      system: json["system"],
      code: json["code"],
    );
  }
}

class TimingAbbreviation {
  final String display;
  final String definition;

  const TimingAbbreviation._(this.display, this.definition);

  static const TimingAbbreviation BID = const TimingAbbreviation._("BID", "Two times a day");

  static const TimingAbbreviation TID =
      const TimingAbbreviation._("TID", "Three times a day at institution specified time");
  static const TimingAbbreviation QID =
      const TimingAbbreviation._("QID", "Four times a day at institution specified time");
  static const TimingAbbreviation AM =
      const TimingAbbreviation._("AM", "Every morning at institution specified times");
  static const TimingAbbreviation PM =
      const TimingAbbreviation._("PM", "Every afternoon at institution specified times");
  static const TimingAbbreviation QD =
      const TimingAbbreviation._("QD", "Every Day at institution specified times");
  static const TimingAbbreviation QOD =
      const TimingAbbreviation._("QOD", "Every Other Day at institution specified times");
  static const TimingAbbreviation Q1H =
      const TimingAbbreviation._("every hour", "Every hour at institution specified times");
  static const TimingAbbreviation Q2H =
      const TimingAbbreviation._("every 2 hours", "Every 2 hours at institution specified times");
  static const TimingAbbreviation Q3H =
      const TimingAbbreviation._("every 3 hours", "Every 3 hours at institution specified times");
  static const TimingAbbreviation Q4H =
      const TimingAbbreviation._("Q4H", "Every 4 hours at institution specified times");
  static const TimingAbbreviation Q6H =
      const TimingAbbreviation._("Q6H", "Every 6 Hours at institution specified times");
  static const TimingAbbreviation Q8H =
      const TimingAbbreviation._("every 8 hours", "Every 8 hours at institution specified times");
  static const TimingAbbreviation BED =
      const TimingAbbreviation._("at bedtime", "At bedtime (institution specified time)");
  static const TimingAbbreviation WK =
      const TimingAbbreviation._("weekly", "Weekly at institution specified time");
  static const TimingAbbreviation MO =
      const TimingAbbreviation._("monthly", "Monthly at institution specified time");

  TimingAbbreviation fromJson(String key) {
    switch (key) {
      case "TID":
        return TID;
      case "QID":
        return QID;
      case "AM":
        return AM;
      case "PM":
        return PM;
      case "QD":
        return QD;
      case "QOD":
        return QOD;
      case "Q1H":
        return Q1H;
      case "Q2H":
        return Q2H;
      case "Q3H":
        return Q3H;
      case "Q4H":
        return Q4H;
      case "Q6H":
        return Q6H;
      case "Q8H":
        return Q8H;
      case "BED":
        return BED;
      case "WK":
        return WK;
      case "MO":
        return MO;
    }
    return TID;
  }
}

class DetailStatus {
  final _value;

  const DetailStatus._(this._value);

  toString() => _value;

  static const DetailStatus not_started = DetailStatus._('not-started');
  static const DetailStatus scheduled = DetailStatus._('scheduled');
  static const DetailStatus in_progress = DetailStatus._('in-progress');
  static const DetailStatus on_hold = DetailStatus._('on-hold');
  static const DetailStatus completed = DetailStatus._('completed');
  static const DetailStatus cancelled = DetailStatus._('cancelled');
  static const DetailStatus stopped = DetailStatus._('stopped');
  static const DetailStatus unknown = DetailStatus._('unknown');
  static const DetailStatus entered_in_error = DetailStatus._('entered-in-error');

  static DetailStatus fromJson(String key) {
    switch (key) {
      case 'not-started':
        return not_started;
      case 'scheduled':
        return scheduled;
      case 'in-progress':
        return in_progress;
      case 'on-hold':
        return on_hold;
      case 'completed':
        return completed;
      case 'cancelled':
        return cancelled;
      case 'stopped':
        return stopped;
      case 'unknown':
        return unknown;
      case 'entered-in-error':
        return entered_in_error;
    }
    return unknown;
  }
}

class CarePlanStatus {
  final _value;

  const CarePlanStatus._(this._value);

  toString() => _value;
  static const draft = const CarePlanStatus._('draft');
  static const active = const CarePlanStatus._('active');
  static const suspended = const CarePlanStatus._('suspended');
  static const completed = const CarePlanStatus._('completed');
  static const entered_in_error = const CarePlanStatus._('entered-in-error');
  static const cancelled = const CarePlanStatus._('cancelled');
  static const unknown = const CarePlanStatus._('unknown');

  static fromJson(String key) {
    switch (key) {
      case 'draft':
        return draft;
      case 'active':
        return active;
      case 'suspended':
        return suspended;
      case 'completed':
        return completed;
      case 'entered-in-error':
        return entered_in_error;
      case 'cancelled':
        return cancelled;
      case 'unknown':
        return unknown;
    }
  }
}

class Questionnaire extends Resource {
  Meta meta;
  String version;
  String name;
  String title;
  String status;
  String description;
  List<QuestionnaireItem> item;

  static const resourceTypeName = "Questionnaire";

  Questionnaire(
      {this.name,
      String resourceType,
      String id,
      this.meta,
      this.version,
      this.title,
      this.status,
      this.description,
      this.item})
      : super(resourceType: resourceTypeName, id: id);

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

  Questionnaire.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resourceType = json['resourceType'];
    name = json['name'];

    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    version = json['version'];
    title = json['title'];
    status = json['status'];
    description = json['description'];
    if (json['item'] != null) {
      item = new List<QuestionnaireItem>();
      json['item'].forEach((v) {
        item.add(new QuestionnaireItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;

    data['resourceType'] = this.resourceType;
    data['id'] = this.id;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['version'] = this.version;
    data['title'] = this.title;
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.item != null) {
      data['item'] = this.item.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CodeableConcept {
  List<Coding> coding;
  String text;

  CodeableConcept({this.coding, this.text});

  @override
  String toString() {
    return coding.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coding != null) {
      data['coding'] = this.coding.map((v) => v.toJson()).toList();
    }
    data['text'] = this.text;
    return data;
  }

  CodeableConcept.fromJson(Map<String, dynamic> json) {
    if (json['coding'] != null) {
      coding = new List<Coding>();
      json['coding'].forEach((v) {
        coding.add(new Coding.fromJson(v));
      });
    }
    text = json['text'];
  }

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

class Coding implements ChoiceOption {
  String system;
  String code;
  String display;
  Answer get ifSelected => new Answer(valueCoding: this);

  Coding({this.system, this.code, this.display});

  @override
  String toString() {
    return display;
  }

  Coding.fromJson(Map<String, dynamic> json) {
    system = json['system'];
    code = json['code'];
    display = json['display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['system'] = this.system;
    data['code'] = this.code;
    data['display'] = this.display;
    return data;
  }

  @override
  bool operator ==(other) {
    if (other is! Coding) return false;
    Coding o = other;
    return o.system == this.system && o.code == this.code;
  }

  @override
  int get hashCode => system.hashCode ^ code.hashCode;
}

class Extension {
  Address valueAddress;

  String url;
  String valueCanonical;
  ValueExpression valueExpression;
  CodeableConcept valueCodeableConcept;
  Coding valueCoding;
  String valueString;
  int valueDecimal;

  Extension(
      {this.valueString,
      this.valueDecimal,
      this.url,
      this.valueCanonical,
      this.valueExpression,
      this.valueCodeableConcept,
      this.valueCoding,
      this.valueAddress});

  Extension.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    valueAddress = json['valueAddress'] != null ? new Address.fromJson(json['valueAddress']) : null;
    valueCanonical = json['valueCanonical'];
    valueExpression = json['valueExpression'] != null
        ? new ValueExpression.fromJson(json['valueExpression'])
        : null;
    valueCodeableConcept = json['valueCodeableConcept'] != null
        ? new CodeableConcept.fromJson(json['valueCodeableConcept'])
        : null;
    valueCoding = json['valueCoding'] != null ? new Coding.fromJson(json['valueCoding']) : null;
    valueString = json['valueString'];
    valueDecimal = json['valueDecimal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    if (this.valueAddress != null) {
      data['valueAddress'] = this.valueAddress.toJson();
    }
    data['valueCanonical'] = this.valueCanonical;
    if (this.valueExpression != null) {
      data['valueExpression'] = this.valueExpression.toJson();
    }
    if (this.valueCodeableConcept != null) {
      data['valueCodeableConcept'] = this.valueCodeableConcept.toJson();
    }
    if (this.valueCoding != null) {
      data['valueCoding'] = this.valueCoding.toJson();
    }
    data['valueString'] = this.valueString;
    data['valueDecimal'] = this.valueDecimal;
    return data;
  }
}

class ValueExpression {
  String language;
  String expression;

  ValueExpression({this.language, this.expression});

  ValueExpression.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    expression = json['expression'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['language'] = this.language;
    data['expression'] = this.expression;
    return data;
  }
}

class QuestionnaireItem {
  String linkId;
  String text;
  bool required;
  String type;
  List<Coding> code;
  List<AnswerOption> answerOption;
  String answerValueSetAddress;
  List<Coding> answerValueSet;
  List<Extension> extension;
  List<QuestionnaireItem> item;

  QuestionnaireItem(
      {this.linkId,
      this.text,
      this.required,
      this.type,
      this.code,
      this.answerOption,
      this.answerValueSetAddress,
      this.answerValueSet,
      this.extension,
      this.item});

  bool isSupported() {
    return type == "choice" ||
        type == "decimal" ||
        type == "string" ||
        type == "date" ||
        type == "dateTime";
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

  List<ChoiceOption> get choiceOptions => answerOption ?? answerValueSet;
  int get choiceCount => choiceOptions != null ? choiceOptions.length : 0;

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

  QuestionnaireItem.fromJson(Map<String, dynamic> json) {
    linkId = json['linkId'];
    text = json['text'];
    required = json['required'];
    type = json['type'];

    if (json['answerOption'] != null) {
      answerOption = new List<AnswerOption>();
      json['answerOption'].forEach((v) {
        answerOption.add(new AnswerOption.fromJson(v));
      });
    }
    if (json['code'] != null) {
      code = new List<Coding>();
      json['code'].forEach((v) {
        code.add(new Coding.fromJson(v));
      });
    }
    if (json['extension'] != null) {
      extension = new List<Extension>();
      json['extension'].forEach((v) {
        extension.add(new Extension.fromJson(v));
      });
    }

    answerValueSetAddress = json['answerValueSet'];
    // answerValueSet actual values are loaded separately

    if (json['code'] != null) {
      code = new List<Coding>();
      json['code'].forEach((v) {
        code.add(new Coding.fromJson(v));
      });
    }
    if (json['item'] != null) {
      item = new List<QuestionnaireItem>();
      json['item'].forEach((v) {
        item.add(new QuestionnaireItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['linkId'] = this.linkId;
    data['text'] = this.text;
    data['required'] = this.required;
    if (this.answerOption != null) {
      data['answerOption'] = this.answerOption.map((v) => v.toJson()).toList();
    }
    data['answerValueSet'] = this.answerValueSetAddress;
    if (this.extension != null) {
      data['extension'] = this.extension.map((v) => v.toJson()).toList();
    }
    if (this.code != null) {
      data['code'] = this.code.map((v) => v.toJson()).toList();
    }
    if (this.item != null) {
      data['item'] = this.item.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool isGroup() {
    return type == "group";
  }
}

abstract class ChoiceOption {
  Answer get ifSelected;
}

class AnswerOption implements ChoiceOption {
  int valueInteger;
  List<Extension> extension;
  Coding valueCoding;
  Answer get ifSelected => new Answer.fromAnswerOption(this);

  AnswerOption({this.valueInteger, this.extension, this.valueCoding});

  AnswerOption.fromJson(Map<String, dynamic> json) {
    valueInteger = json['valueInteger'];
    if (json['extension'] != null) {
      extension = new List<Extension>();
      json['extension'].forEach((v) {
        extension.add(new Extension.fromJson(v));
      });
    }
    valueCoding = json['valueCoding'] != null ? new Coding.fromJson(json['valueCoding']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valueInteger'] = this.valueInteger;
    if (this.extension != null) {
      data['extension'] = this.extension.map((v) => v.toJson()).toList();
    }
    if (this.valueCoding != null) {
      data['valueCoding'] = this.valueCoding.toJson();
    }
    return data;
  }

  @override
  String toString() {
    if (valueInteger != null) return '$valueInteger';
    if (valueCoding != null) return valueCoding.toString();
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
class QuestionnaireResponse extends Resource {
  Meta meta;
  String questionnaireReference;
  List<Reference> basedOnCarePlan;
  Reference subject;
  DateTime authored;
  List<QuestionnaireResponseItem> item;
  QuestionnaireResponseStatus status;

  QuestionnaireResponse(Questionnaire questionnaire, this.subject, CarePlan carePlan,
      {resourceType, id, this.meta, this.status, this.item})
      : super(resourceType: "QuestionnaireResponse", id: id) {
    if (this.item == null) {
      this.item = [];
    }
    this.questionnaireReference = questionnaire.reference;
    this.basedOnCarePlan = [Reference(reference: carePlan.reference)];
    var today = new DateTime.now();
    this.authored = new DateTime(today.year, today.month, today.day, today.hour, today.minute);
  }

  QuestionnaireResponse.fromJson(Map<String, dynamic> json) {
    resourceType = json['resourceType'];
    id = json['id'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    questionnaireReference = json['questionnaire'];

    if (json['basedOn'] != null) {
      basedOnCarePlan = new List<Reference>();
      json['basedOn'].forEach((v) {
        basedOnCarePlan.add(new Reference.fromJson(v));
      });
    }

    if (json['status'] != null) status = QuestionnaireResponseStatus.fromJson(json['status']);
    if (json['authored'] != null) authored = DateTime.parse(json['authored']);
    subject = json['subject'] != null ? new Reference.fromJson(json['subject']) : null;
    if (json['item'] != null) {
      item = new List<QuestionnaireResponseItem>();
      json['item'].forEach((v) {
        item.add(new QuestionnaireResponseItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resourceType'] = this.resourceType;
    data['id'] = this.id;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['basedOn'] = this.basedOnCarePlan;
    data['questionnaire'] = this.questionnaireReference;
    data['status'] = this.status.toString();
    if (this.subject != null) {
      data['subject'] = this.subject.toJson();
    }
    data['authored'] = this.authored.toIso8601String();
    if (this.item != null) {
      data['item'] = this.item.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void setAnswer(String linkId, Answer answer) {
    var responseItem = getResponseItem(linkId);
    if (responseItem != null) {
      responseItem.answer = [answer]; // single response
    } else {
      this.item.add(new QuestionnaireResponseItem(linkId: linkId, answer: [answer]));
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

class Content {
  Attachment attachment;

  Content({this.attachment});

  Content.fromJson(Map<String, dynamic> json) {
    if (json['attachment'] != null) {
      attachment = Attachment.fromJson(json['attachment']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attachment != null) {
      data['attachment'] = this.attachment.toJson();
    }
    return data;
  }
}

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

  DocumentReference.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    status = json['status'];
    if (json['type'] != null) {
      type = CodeableConcept.fromJson(json['type']);
    }
    if (json['content'] != null) {
      content = new List<Content>();
      json['content'].forEach((v) {
        content.add(new Content.fromJson(v));
      });
    }
  }

  bool isGroup() {
    return content != null && content.length > 1 && description != null;
  }

  String get url => content != null && content.length > 0 && content[0].attachment != null
      ? content[0].attachment.url
      : "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['status'] = this.status;
    if (this.content != null) {
      data['content'] = this.content.map((v) => v.toJson()).toList();
    }
    //TODO: type
    return data;
  }
}

class Attachment {
  String url;
  String title;

  Attachment({this.url, this.title});

  Attachment.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.url != null) data['url'] = this.url;
    if (this.title != null) data['title'] = this.title;
    return data;
  }
}

class Reference {
  String reference;

  Reference({this.reference});

  Reference.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reference'] = this.reference;
    return data;
  }

  Reference.from(Patient patient) : this(reference: patient.reference);
}

class QuestionnaireResponseItem {
  String linkId;
  List<Answer> answer;

  QuestionnaireResponseItem({this.linkId, this.answer});

  QuestionnaireResponseItem.fromJson(Map<String, dynamic> json) {
    linkId = json['linkId'];
    if (json['answer'] != null) {
      answer = new List<Answer>();
      json['answer'].forEach((v) {
        answer.add(new Answer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['linkId'] = this.linkId;
    if (this.answer != null) {
      data['answer'] = this.answer.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answer {
  int valueInteger;
  double valueDecimal;
  Coding valueCoding;
  String valueString;
  DateTime valueDate;
  DateTime valueDateTime;

  Answer(
      {this.valueDecimal,
      this.valueInteger,
      this.valueCoding,
      this.valueString,
      this.valueDate,
      this.valueDateTime});

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

  @override
  String toString() {
    if (valueInteger != null) return '$valueInteger';
    if (valueCoding != null) return valueCoding.toString();
    if (valueDecimal != null) return valueDecimal.toString();
    if (valueString != null) return valueString;
    if (valueDate != null) return valueDate.toString();
    if (valueDateTime != null) return valueDateTime.toString();
    return '';
  }

  factory Answer.fromAnswerOption(AnswerOption option) {
    return Answer.fromJson(option.toJson());
  }

  Answer.fromJson(Map<String, dynamic> json) {
    valueInteger = json['valueInteger'];
    if (json['valueDecimal'] != null) valueDecimal = json['valueDecimal'].toDouble();
    if (json['valueCoding'] != null) valueCoding = Coding.fromJson(json['valueCoding']);
    if (json['valueString'] != null) valueString = json['valueString'];
    if (json['valueDate'] != null) valueDate = DateTime.parse(json['valueDate']);
    if (json['valueDateTime'] != null) valueDateTime = DateTime.parse(json['valueDateTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.valueInteger != null) data['valueInteger'] = this.valueInteger;
    if (this.valueDecimal != null) data['valueDecimal'] = this.valueDecimal;
    if (this.valueCoding != null) data['valueCoding'] = this.valueCoding.toJson();
    if (this.valueString != null) data['valueString'] = this.valueString;
    if (this.valueDate != null) data['valueDate'] = this.valueDate.toIso8601String();
    if (this.valueDateTime != null) data['valueDateTime'] = this.valueDateTime.toIso8601String();
    return data;
  }
}

class ValueSet extends Resource {
  String language;
  String url;
  String status;
  Expansion expansion;

  ValueSet({String resourceType, String id, this.language, this.url, this.status, this.expansion})
      : super(resourceType: "ValueSet", id: id);

  ValueSet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resourceType = json['resourceType'];
    language = json['language'];
    url = json['url'];
    status = json['status'];
    expansion = json['expansion'] != null ? new Expansion.fromJson(json['expansion']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resourceType'] = this.resourceType;
    data['id'] = this.id;
    data['language'] = this.language;
    data['url'] = this.url;
    data['status'] = this.status;
    if (this.expansion != null) {
      data['expansion'] = this.expansion.toJson();
    }
    return data;
  }
}

class Expansion {
  String identifier;
  String timestamp;
  int total;
  List<Parameter> parameter;
  List<Coding> contains;

  Expansion({this.identifier, this.timestamp, this.total, this.parameter, this.contains});

  Expansion.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    timestamp = json['timestamp'];
    total = json['total'];
    if (json['parameter'] != null) {
      parameter = new List<Parameter>();
      json['parameter'].forEach((v) {
        parameter.add(new Parameter.fromJson(v));
      });
    }
    if (json['contains'] != null) {
      contains = new List<Coding>();
      json['contains'].forEach((v) {
        contains.add(new Coding.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.identifier;
    data['timestamp'] = this.timestamp;
    data['total'] = this.total;
    if (this.parameter != null) {
      data['parameter'] = this.parameter.map((v) => v.toJson()).toList();
    }
    if (this.contains != null) {
      data['contains'] = this.contains.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parameter {
  String name;
  String valueUri;
  int valueInteger;

  Parameter({this.name, this.valueUri, this.valueInteger});

  Parameter.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    valueUri = json['valueUri'];
    valueInteger = json['valueInteger'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['valueUri'] = this.valueUri;
    data['valueInteger'] = this.valueInteger;
    return data;
  }
}
