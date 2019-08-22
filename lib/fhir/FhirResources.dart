/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
import 'dart:convert';

import 'package:map_app_flutter/services/Repository.dart';

class Resource {
  String resourceType;
  String id;

  Resource({this.resourceType, this.id});

  get reference => "$resourceType/$id";
}

class Patient extends Resource {
  Meta meta;
  Narrative text;
  List<Extension> extension;
  List<Identifier> identifier;
  List<HumanName> name;
  List<ContactPoint> telecom;
  String gender;
  String birthDate;
  List<Address> address;
  CodeableConcept maritalStatus;
  bool multipleBirthBoolean;
  List<Communication> communication;

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
      : super(resourceType: resourceType, id: id);

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
    gender = json['gender'];
    birthDate = json['birthDate'];
    if (json['address'] != null) {
      address = new List<Address>();
      json['address'].forEach((v) {
        address.add(new Address.fromJson(v));
      });
    }
    maritalStatus = json['maritalStatus'] != null
        ? new CodeableConcept.fromJson(json['maritalStatus'])
        : null;
    multipleBirthBoolean = json['multipleBirthBoolean'];
    if (json['communication'] != null) {
      communication = new List<Communication>();
      json['communication'].forEach((v) {
        communication.add(new Communication.fromJson(v));
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
    if (this.text != null) {
      data['text'] = this.text.toJson();
    }
    if (this.extension != null) {
      data['extension'] = this.extension.map((v) => v.toJson()).toList();
    }
    if (this.identifier != null) {
      data['identifier'] = this.identifier.map((v) => v.toJson()).toList();
    }
    if (this.name != null) {
      data['name'] = this.name.map((v) => v.toJson()).toList();
    }
    if (this.telecom != null) {
      data['telecom'] = this.telecom.map((v) => v.toJson()).toList();
    }
    data['gender'] = this.gender;
    data['birthDate'] = this.birthDate;
    if (this.address != null) {
      data['address'] = this.address.map((v) => v.toJson()).toList();
    }
    if (this.maritalStatus != null) {
      data['maritalStatus'] = this.maritalStatus.toJson();
    }
    data['multipleBirthBoolean'] = this.multipleBirthBoolean;
    if (this.communication != null) {
      data['communication'] =
          this.communication.map((v) => v.toJson()).toList();
    }
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
    given = json['given'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['use'] = this.use;
    data['family'] = this.family;
    data['given'] = this.given;
    return data;
  }
}

class ContactPoint {
  String system;
  String value;
  String use;

  ContactPoint({this.system, this.value, this.use});

  ContactPoint.fromJson(Map<String, dynamic> json) {
    system = json['system'];
    value = json['value'];
    use = json['use'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['system'] = this.system;
    data['value'] = this.value;
    data['use'] = this.use;
    return data;
  }
}

class Address {
  List<Extension> extension;
  List<String> line;
  String city;
  String state;
  String postalCode;
  String country;

  Address(
      {this.extension,
      this.line,
      this.city,
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
    line = json['line'].cast<String>();
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.extension != null) {
      data['extension'] = this.extension.map((v) => v.toJson()).toList();
    }
    data['line'] = this.line;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postalCode'] = this.postalCode;
    data['country'] = this.country;
    return data;
  }
}

class Communication {
  CodeableConcept language;

  Communication({this.language});

  Communication.fromJson(Map<String, dynamic> json) {
    language = json['language'] != null
        ? new CodeableConcept.fromJson(json['language'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.language != null) {
      data['language'] = this.language.toJson();
    }
    return data;
  }
}

class ProcedureStatus {
  final _value;

  const ProcedureStatus._(this._value);

  toString() => 'ProcedureStatus.$_value';
  static const preparation = const ProcedureStatus._('preparation');
  static const in_progress = const ProcedureStatus._('in-progress');
  static const not_done = const ProcedureStatus._('not-done');
  static const suspended = const ProcedureStatus._('suspended');
  static const aborted = const ProcedureStatus._('aborted');
  static const completed = const ProcedureStatus._('completed');
  static const entered_in_error = const ProcedureStatus._('entered-in-error');
  static const unknown = const ProcedureStatus._('unknown');

  static ProcedureStatus fromJson(String key) {
    switch (key) {
      case 'preparation':
        return preparation;
      case 'in-progress':
        return in_progress;
      case 'not-done':
        return not_done;
      case 'suspended':
        return suspended;
      case 'aborted':
        return aborted;
      case 'completed':
        return completed;
      case 'entered-in-error':
        return entered_in_error;
      case 'unknown':
        return unknown;
    }
    return unknown;
  }
}

class Procedure extends Resource {
  Identifier identifier;

  List<CarePlan> basedOn;
  ProcedureStatus status;

  CodeableConcept statusReason;
  CodeableConcept category;
  CodeableConcept code;

  DateTime performedDateTime;
  Period performedPeriod;

  List<CodeableConcept> reasonCode;

  Procedure(
      {String id,
      String resourceType,
      this.identifier,
      this.basedOn,
      this.status,
      this.statusReason,
      this.category,
      this.code,
      this.performedDateTime,
      this.performedPeriod,
      this.reasonCode})
      : super(resourceType: "Procedure", id: id);

  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure(
      identifier: Identifier.fromJson(json["id"]),
      basedOn: List.of(json["basedOn"])
          .map((i) => i /* can't generate it properly yet */)
          .toList(),
      status: ProcedureStatus.fromJson(json["status"]),
      statusReason: CodeableConcept.fromJson(json["statusReason"]),
      category: CodeableConcept.fromJson(json["category"]),
      code: CodeableConcept.fromJson(json["code"]),
      performedDateTime: DateTime.parse(json["performedDateTime"]),
      performedPeriod: Period.fromJson(json["performedPeriod"]),
      reasonCode: List.of(json["reasonCode"])
          .map((i) => i /* can't generate it properly yet */)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "resourceType": this.resourceType,
      "id": this.identifier,
      "basedOn": jsonEncode(this.basedOn),
      "status": this.status,
      "statusReason": this.statusReason,
      "category": this.category,
      "code": this.code,
      "performedDateTime": this.performedDateTime.toIso8601String(),
      "performedPeriod": this.performedPeriod,
      "reasonCode": jsonEncode(this.reasonCode),
    };
  }
}

class CarePlan extends Resource {
  String resourceType = "CarePlan";
  Identifier identifier;
  CarePlanStatus status;
  String title;
  String description;
  Period period;
  DateTime created;
  List<Activity> activities;
  List<Annotation> note;

  CarePlan(
      {String id,
      String resourceType,
      this.identifier,
      this.status,
      this.title,
      this.description,
      this.period,
      this.created,
      this.activities,
      this.note})
      : super(resourceType: "CarePlan", id: id);

  Map<String, dynamic> toJson() {
    return {
      "resourceType": this.resourceType,
      "id": this.identifier,
      "status": this.status,
      "title": this.title,
      "description": this.description,
      "period": this.period,
      "created": this.created.toIso8601String(),
      "activities": jsonEncode(this.activities),
      "note": jsonEncode(this.note),
    };
  }

  factory CarePlan.fromJson(Map<String, dynamic> json) {
    return CarePlan(
      resourceType: json["resourceType"],
      identifier: Identifier.fromJson(json["id"]),
      status: CarePlanStatus.fromJson(json["status"]),
      title: json["title"],
      description: json["description"],
      period: Period.fromJson(json["period"]),
      created: DateTime.parse(json["created"]),
      activities:
          List.of(json["activities"]).map((i) => Activity.fromJson(i)).toList(),
      note: List.of(json["note"]).map((i) => Annotation.fromJson(i)).toList(),
    );
  }
}

class Activity {
  List<Annotation> progress;
  Detail detail;

  Map<String, dynamic> toJson() {
    return {
      "progress": jsonEncode(this.progress),
      "detail": this.detail,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      progress:
          List.of(json["progress"]).map((i) => Annotation.fromJson(i)).toList(),
      detail: Detail.fromJson(json["detail"]),
    );
  }

  Activity({this.progress, this.detail});
}

class Detail {
  String kind;
  CodeableConcept code;
  List<CodeableConcept> reasonCode;
  DetailStatus status;
  CodeableConcept statusReason;
  Timing scheduledTiming;
  Period scheduledPeriod;

  Detail(
      {this.kind,
      this.code,
      this.reasonCode,
      this.status,
      this.statusReason,
      this.scheduledTiming,
      this.scheduledPeriod});

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      kind: json["kind"],
      code: CodeableConcept.fromJson(json["code"]),
      reasonCode: List.of(json["reasonCode"])
          .map((i) => CodeableConcept.fromJson(i))
          .toList(),
      status: DetailStatus.fromJson(json["status"]),
      statusReason: CodeableConcept.fromJson(json["statusReason"]),
      scheduledTiming: Timing.fromJson(json["scheduledTiming"]),
      scheduledPeriod: Period.fromJson(json["scheduledPeriod"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "kind": this.kind,
      "code": this.code,
      "reasonCode": jsonEncode(this.reasonCode),
      "status": this.status,
      "statusReason": this.statusReason,
      "scheduledTiming": this.scheduledTiming,
      "scheduledPeriod": this.scheduledPeriod,
    };
  }
}

class Timing {
  List<DateTime> event;
  Repeat repeat;
  CodeableConcept code;

  Timing({this.event, this.repeat, this.code});

  factory Timing.fromJson(Map<String, dynamic> json) {
    return Timing(
      event: List.of(json["event"]).map((i) => DateTime.parse(i)).toList(),
      repeat: Repeat.fromJson(json["repeat"]),
      code: CodeableConcept.fromJson(json["code"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "event": jsonEncode(this.event),
      "repeat": this.repeat,
      "code": this.code,
    };
  }
}

class Repeat {
  SimpleQuantity boundsDuration;
  Range boundsRange;
  Period boundsPeriod;
  int count;
  int countMax;

  Repeat(
      {this.boundsDuration,
      this.boundsRange,
      this.boundsPeriod,
      this.count,
      this.countMax});

  Map<String, dynamic> toJson() {
    return {
      "boundsDuration": this.boundsDuration,
      "boundsRange": this.boundsRange,
      "boundsPeriod": this.boundsPeriod,
      "count": this.count,
      "countMax": this.countMax,
    };
  }

  factory Repeat.fromJson(Map<String, dynamic> json) {
    return Repeat(
      boundsDuration: SimpleQuantity.fromJson(json["boundsDuration"]),
      boundsRange: Range.fromJson(json["boundsRange"]),
      boundsPeriod: Period.fromJson(json["boundsPeriod"]),
      count: int.parse(json["count"]),
      countMax: int.parse(json["countMax"]),
    );
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

  static const TimingAbbreviation BID =
      const TimingAbbreviation._("BID", "Two times a day");

  static const TimingAbbreviation TID = const TimingAbbreviation._(
      "TID", "Three times a day at institution specified time");
  static const TimingAbbreviation QID = const TimingAbbreviation._(
      "QID", "Four times a day at institution specified time");
  static const TimingAbbreviation AM = const TimingAbbreviation._(
      "AM", "Every morning at institution specified times");
  static const TimingAbbreviation PM = const TimingAbbreviation._(
      "PM", "Every afternoon at institution specified times");
  static const TimingAbbreviation QD = const TimingAbbreviation._(
      "QD", "Every Day at institution specified times");
  static const TimingAbbreviation QOD = const TimingAbbreviation._(
      "QOD", "Every Other Day at institution specified times");
  static const TimingAbbreviation Q1H = const TimingAbbreviation._(
      "every hour", "Every hour at institution specified times");
  static const TimingAbbreviation Q2H = const TimingAbbreviation._(
      "every 2 hours", "Every 2 hours at institution specified times");
  static const TimingAbbreviation Q3H = const TimingAbbreviation._(
      "every 3 hours", "Every 3 hours at institution specified times");
  static const TimingAbbreviation Q4H = const TimingAbbreviation._(
      "Q4H", "Every 4 hours at institution specified times");
  static const TimingAbbreviation Q6H = const TimingAbbreviation._(
      "Q6H", "Every 6 Hours at institution specified times");
  static const TimingAbbreviation Q8H = const TimingAbbreviation._(
      "every 8 hours", "Every 8 hours at institution specified times");
  static const TimingAbbreviation BED = const TimingAbbreviation._(
      "at bedtime", "At bedtime (institution specified time)");
  static const TimingAbbreviation WK = const TimingAbbreviation._(
      "weekly", "Weekly at institution specified time");
  static const TimingAbbreviation MO = const TimingAbbreviation._(
      "monthly", "Monthly at institution specified time");

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

  toString() => 'DetailStatus.$_value';

  static const DetailStatus not_started = DetailStatus._('not-started');
  static const DetailStatus scheduled = DetailStatus._('scheduled');
  static const DetailStatus in_progress = DetailStatus._('in-progress');
  static const DetailStatus on_hold = DetailStatus._('on-hold');
  static const DetailStatus completed = DetailStatus._('completed');
  static const DetailStatus cancelled = DetailStatus._('cancelled');
  static const DetailStatus stopped = DetailStatus._('stopped');
  static const DetailStatus unknown = DetailStatus._('unknown');
  static const DetailStatus entered_in_error =
      DetailStatus._('entered-in-error');

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

class Annotation {
  Reference authorReference;
  String authorString;
  DateTime time;
  String text;

  Annotation({this.authorReference, this.authorString, this.time, this.text});

  factory Annotation.fromJson(Map<String, dynamic> json) {
    return Annotation(
      authorReference: Reference.fromJson(json["authorReference"]),
      authorString: json["authorString"],
      time: DateTime.parse(json["time"]),
      text: json["text"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "authorReference": this.authorReference,
      "authorString": this.authorString,
      "time": this.time.toIso8601String(),
      "text": this.text,
    };
  }
}

class Reference {
  String reference;
  String type;
  Identifier identifier;
  String display;

  Reference({this.reference, this.type, this.identifier, this.display});

  Map<String, dynamic> toJson() {
    return {
      "reference": this.reference,
      "type": this.type,
      "identifier": this.identifier,
      "display": this.display,
    };
  }

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      reference: json["reference"],
      type: json["type"],
      identifier: Identifier.fromJson(json["identifier"]),
      display: json["display"],
    );
  }
}

class CarePlanStatus {
  final _value;

  const CarePlanStatus._(this._value);

  toString() => 'CarePlanStatus.$_value';
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

class Identifier {
  Use use;
  CodeableConcept type;
  String system;
  String value;
  Period period;

  Identifier({this.use, this.type, this.system, this.value, this.period});

  factory Identifier.fromJson(Map<String, dynamic> json) {
    return Identifier(
      use: Use.fromJson(json["use"]),
      type: CodeableConcept.fromJson(json["type"]),
      system: json["system"],
      value: json["value"],
      period: Period.fromJson(json["period"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "use": this.use,
      "type": this.type,
      "system": this.system,
      "value": this.value,
      "period": this.period,
    };
  }
}

class Period {
  DateTime start;
  DateTime end;

  Period({this.start, this.end});

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      start: DateTime.parse(json["start"]),
      end: DateTime.parse(json["end"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start": this.start.toIso8601String(),
      "end": this.end.toIso8601String(),
    };
  }
}

class Use {
  final _value;

  const Use._(this._value);

  toString() => 'Use.$_value';

  static const usual = const Use._('usual');
  static const official = const Use._('official');
  static const temp = const Use._('temp');
  static const secondary = const Use._('secondary');
  static const old = const Use._('old');

  static fromJson(String key) {
    switch (key) {
      case 'usual':
        return usual;
      case 'official':
        return official;
      case 'temp':
        return temp;
      case 'secondary':
        return secondary;
      case 'old':
        return old;
    }
  }
}

class Coding {
  String system;
  String code;
  String version;
  bool userSelected;
  String display;

  Coding(
      {this.system, this.code, this.display, this.version, this.userSelected});

  Coding.fromJson(Map<String, dynamic> json) {
    system = json['system'];
    code = json['code'];
    display = json['display'];
    userSelected = json['userSelected'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['system'] = this.system;
    data['code'] = this.code;
    data['display'] = this.display;
    data['version'] = this.version;
    data['userSelected'] = this.userSelected;
    return data;
  }
}

class ReasonCode {
  String text;

  ReasonCode({this.text});

  ReasonCode.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
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
      : super(resourceType: "Questionnaire", id: id);

  Future<void> loadValueSets() async {
    return Future.wait(item.map((QuestionnaireItem questionnaireItem) async {
      await questionnaireItem.loadValueSet();
    }));
  }

  Questionnaire.fromJson(Map<String, dynamic> json) {
    resourceType = json['resourceType'];
    id = json['id'];
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
  String system;
  String code;
  String display;

  CodeableConcept({this.system, this.code, this.display});


  @override
  String toString() {
    return display;
  }

  CodeableConcept.fromJson(Map<String, dynamic> json) {
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
}

class Extension {
  Address valueAddress;

  String url;
  String valueCanonical;
  ValueExpression valueExpression;
  ValueCodeableConcept valueCodeableConcept;
  CodeableConcept valueCoding;
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
    valueAddress = json['valueAddress'] != null
        ? new Address.fromJson(json['valueAddress'])
        : null;
    valueCanonical = json['valueCanonical'];
    valueExpression = json['valueExpression'] != null
        ? new ValueExpression.fromJson(json['valueExpression'])
        : null;
    valueCodeableConcept = json['valueCodeableConcept'] != null
        ? new ValueCodeableConcept.fromJson(json['valueCodeableConcept'])
        : null;
    valueCoding = json['valueCoding'] != null
        ? new CodeableConcept.fromJson(json['valueCoding'])
        : null;
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

class ValueCodeableConcept {
  List<CodeableConcept> coding;
  String text;

  ValueCodeableConcept({this.coding, this.text});

  ValueCodeableConcept.fromJson(Map<String, dynamic> json) {
    if (json['coding'] != null) {
      coding = new List<CodeableConcept>();
      json['coding'].forEach((v) {
        coding.add(new CodeableConcept.fromJson(v));
      });
    }
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coding != null) {
      data['coding'] = this.coding.map((v) => v.toJson()).toList();
    }
    data['text'] = this.text;
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
  List<CodeableConcept> code;
  List<AnswerOption> answerOption;
  String answerValueSetAddress;
  List<CodeableConcept> answerValueSet;
  List<Extension> extension;
  List<QuestionnaireItem> item;

  QuestionnaireItem(
      {this.linkId,
      this.text,
      this.required,
      this.answerOption,
      this.answerValueSetAddress,
      this.extension,
      this.item});

  bool isSupported() {
    return answerOption != null || answerValueSet != null;
  }

  loadValueSet() async {
    if (answerValueSetAddress != null) {
      ValueSet answers = await Repository.getValueSet(answerValueSetAddress);
      answerValueSet = answers.expansion.contains;
    }
  }

  QuestionnaireItem.fromJson(Map<String, dynamic> json) {
    linkId = json['linkId'];
    text = json['text'];
    required = json['required'];
    if (json['answerOption'] != null) {
      answerOption = new List<AnswerOption>();
      json['answerOption'].forEach((v) {
        answerOption.add(new AnswerOption.fromJson(v));
      });
    }
    if (json['extension'] != null) {
      extension = new List<Extension>();
      json['extension'].forEach((v) {
        extension.add(new Extension.fromJson(v));
      });
    }

    answerValueSetAddress = json['answerValueSet'];

    if (json['code'] != null) {
      code = new List<CodeableConcept>();
      json['code'].forEach((v) {
        code.add(new CodeableConcept.fromJson(v));
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
}

class AnswerOption {
  int valueInteger;
  List<Extension> extension;
  CodeableConcept valueCoding;

  AnswerOption({this.valueInteger, this.extension, this.valueCoding});

  AnswerOption.fromJson(Map<String, dynamic> json) {
    valueInteger = json['valueInteger'];
    if (json['extension'] != null) {
      extension = new List<Extension>();
      json['extension'].forEach((v) {
        extension.add(new Extension.fromJson(v));
      });
    }
    valueCoding = json['valueCoding'] != null
        ? new CodeableConcept.fromJson(json['valueCoding'])
        : null;
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


}

/// https://www.hl7.org/fhir/questionnaireresponse.html
class QuestionnaireResponse extends Resource {
  Meta meta;
  String questionnaireReference;
  String status;
  Subject subject;
  List<QuestionnaireResponseItem> item;

  QuestionnaireResponse(this.questionnaireReference, this.subject,
      {resourceType, id, this.meta, this.status, this.item})
      : super(resourceType: "QuestionnaireResponse", id: id) {
    if (this.item == null) {
      this.item = [];
    }
  }

  QuestionnaireResponse.fromJson(Map<String, dynamic> json) {
    resourceType = json['resourceType'];
    id = json['id'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    questionnaireReference = json['questionnaire'];
    status = json['status'];
    subject =
        json['subject'] != null ? new Subject.fromJson(json['subject']) : null;
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
    data['questionnaire'] = this.questionnaireReference;
    data['status'] = this.status;
    if (this.subject != null) {
      data['subject'] = this.subject.toJson();
    }
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
      this
          .item
          .add(new QuestionnaireResponseItem(linkId: linkId, answer: [answer]));
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

class Subject {
  String reference;

  Subject({this.reference});

  Subject.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reference'] = this.reference;
    return data;
  }
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
  CodeableConcept valueCoding;

  Answer({this.valueInteger, this.valueCoding});

  bool operator ==(dynamic o) {
    if (o is Answer) {
      Answer other = o;
      return valueInteger == other.valueInteger && valueCoding == other.valueCoding;
    } else if (o is AnswerOption) {
      AnswerOption other = o;
      return valueInteger == other.valueInteger && valueCoding == other.valueCoding;
    } else if (o is CodeableConcept) {
      CodeableConcept other = o;
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
    return result;
  }

  @override
  String toString() {
    if (valueInteger != null) return '$valueInteger';
    if (valueCoding != null) return valueCoding.toString();
    return '';
  }

  Answer.fromAnswerOption(AnswerOption option) {
    valueInteger = option.valueInteger;
    valueCoding = option.valueCoding;
  }

  Answer.fromJson(Map<String, dynamic> json) {
    valueInteger = json['valueInteger'];
    valueCoding = CodeableConcept.fromJson(json['valueCoding']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valueInteger'] = this.valueInteger;
    data['valueCoding'] = this.valueCoding.toJson();
    return data;
  }
}

class ValueSet extends Resource {
  String language;
  String url;
  String status;
  Expansion expansion;

  ValueSet(
      {String resourceType,
      String id,
      this.language,
      this.url,
      this.status,
      this.expansion})
      : super(resourceType: "ValueSet", id: id);

  ValueSet.fromJson(Map<String, dynamic> json) {
    resourceType = json['resourceType'];
    language = json['language'];
    url = json['url'];
    status = json['status'];
    expansion = json['expansion'] != null
        ? new Expansion.fromJson(json['expansion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resourceType'] = this.resourceType;
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
  List<CodeableConcept> contains;

  Expansion(
      {this.identifier,
      this.timestamp,
      this.total,
      this.parameter,
      this.contains});

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
      contains = new List<CodeableConcept>();
      json['contains'].forEach((v) {
        contains.add(new CodeableConcept.fromJson(v));
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
