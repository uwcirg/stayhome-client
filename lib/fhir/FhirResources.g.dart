// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FhirResources.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Consent _$ConsentFromJson(Map<String, dynamic> json) {
  return Consent(
    resourceType: json['resourceType'] as String,
    id: json['id'] as String,
    meta: json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    status: _$enumDecodeNullable(_$ConsentStatusEnumMap, json['status']),
    scope: json['scope'] == null
        ? null
        : CodeableConcept.fromJson(json['scope'] as Map<String, dynamic>),
    category: (json['category'] as List)
        ?.map((e) => e == null
            ? null
            : CodeableConcept.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    patient: json['patient'] == null
        ? null
        : Reference.fromJson(json['patient'] as Map<String, dynamic>),
    provision: json['provision'] == null
        ? null
        : Provision.fromJson(json['provision'] as Map<String, dynamic>),
    organization: (json['organization'] as List)
        ?.map((e) =>
            e == null ? null : Reference.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ConsentToJson(Consent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resourceType', instance.resourceType);
  writeNotNull('id', instance.id);
  writeNotNull('meta', instance.meta?.toJson());
  writeNotNull('status', _$ConsentStatusEnumMap[instance.status]);
  writeNotNull('scope', instance.scope?.toJson());
  writeNotNull(
      'category', instance.category?.map((e) => e?.toJson())?.toList());
  writeNotNull('patient', instance.patient?.toJson());
  writeNotNull('provision', instance.provision?.toJson());
  writeNotNull(
      'organization', instance.organization?.map((e) => e?.toJson())?.toList());
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ConsentStatusEnumMap = {
  ConsentStatus.draft: 'draft',
  ConsentStatus.proposed: 'proposed',
  ConsentStatus.active: 'active',
  ConsentStatus.rejected: 'rejected',
  ConsentStatus.inactive: 'inactive',
  ConsentStatus.entered_in_error: 'entered-in-error',
};

Provision _$ProvisionFromJson(Map<String, dynamic> json) {
  return Provision(
    type: _$enumDecodeNullable(_$ProvisionTypeEnumMap, json['type']),
    provisionClass: (json['class'] as List)
        ?.map((e) =>
            e == null ? null : Coding.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    period: json['period'] == null
        ? null
        : Period.fromJson(json['period'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProvisionToJson(Provision instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', _$ProvisionTypeEnumMap[instance.type]);
  writeNotNull(
      'class', instance.provisionClass?.map((e) => e?.toJson())?.toList());
  writeNotNull('period', instance.period?.toJson());
  return val;
}

const _$ProvisionTypeEnumMap = {
  ProvisionType.deny: 'deny',
  ProvisionType.permit: 'permit',
};

Communication _$CommunicationFromJson(Map<String, dynamic> json) {
  return Communication(
    resourceType: json['resourceType'] as String,
    id: json['id'] as String,
    meta: json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    status: _$enumDecodeNullable(_$CommunicationStatusEnumMap, json['status']),
    priority: _$enumDecodeNullable(_$PriorityEnumMap, json['priority']),
    category: (json['category'] as List)
        ?.map((e) => e == null
            ? null
            : CodeableConcept.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    recipient: (json['recipient'] as List)
        ?.map((e) =>
            e == null ? null : Reference.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    payload: (json['payload'] as List)
        ?.map((e) =>
            e == null ? null : Payload.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    sent: json['sent'] == null ? null : DateTime.parse(json['sent'] as String),
  );
}

Map<String, dynamic> _$CommunicationToJson(Communication instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resourceType', instance.resourceType);
  writeNotNull('id', instance.id);
  writeNotNull('meta', instance.meta?.toJson());
  writeNotNull('status', _$CommunicationStatusEnumMap[instance.status]);
  writeNotNull('priority', _$PriorityEnumMap[instance.priority]);
  writeNotNull(
      'category', instance.category?.map((e) => e?.toJson())?.toList());
  writeNotNull(
      'recipient', instance.recipient?.map((e) => e?.toJson())?.toList());
  writeNotNull('payload', instance.payload?.map((e) => e?.toJson())?.toList());
  writeNotNull('sent', instance.sent?.toIso8601String());
  return val;
}

const _$CommunicationStatusEnumMap = {
  CommunicationStatus.preparation: 'preparation',
  CommunicationStatus.in_progress: 'in-progress',
  CommunicationStatus.not_done: 'not-done',
  CommunicationStatus.on_hold: 'on-hold',
  CommunicationStatus.stopped: 'stopped',
  CommunicationStatus.completed: 'completed',
  CommunicationStatus.entered_in_error: 'entered-in-error',
  CommunicationStatus.unknown: 'unknown',
};

const _$PriorityEnumMap = {
  Priority.routine: 'routine',
  Priority.urgent: 'urgent',
  Priority.asap: 'asap',
  Priority.stat: 'stat',
};

PrimitiveTypeExtension _$PrimitiveTypeExtensionFromJson(
    Map<String, dynamic> json) {
  return PrimitiveTypeExtension(
    extension: (json['extension'] as List)
        ?.map((e) =>
            e == null ? null : Extension.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PrimitiveTypeExtensionToJson(
    PrimitiveTypeExtension instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'extension', instance.extension?.map((e) => e?.toJson())?.toList());
  return val;
}

Payload _$PayloadFromJson(Map<String, dynamic> json) {
  return Payload(
    contentStringBase: json['contentString'] as String,
    contentAttachment: json['contentAttachment'] == null
        ? null
        : Attachment.fromJson(
            json['contentAttachment'] as Map<String, dynamic>),
    contentReference: json['contentReference'] == null
        ? null
        : Reference.fromJson(json['contentReference'] as Map<String, dynamic>),
    contentStringExt: json['_contentString'] == null
        ? null
        : PrimitiveTypeExtension.fromJson(
            json['_contentString'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PayloadToJson(Payload instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('contentAttachment', instance.contentAttachment?.toJson());
  writeNotNull('contentReference', instance.contentReference?.toJson());
  writeNotNull('contentString', instance.contentStringBase);
  writeNotNull('_contentString', instance.contentStringExt?.toJson());
  return val;
}

Patient _$PatientFromJson(Map<String, dynamic> json) {
  return Patient(
    resourceType: json['resourceType'] as String,
    id: json['id'] as String,
    meta: json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    text: json['text'] == null
        ? null
        : Narrative.fromJson(json['text'] as Map<String, dynamic>),
    extension: (json['extension'] as List)
        ?.map((e) =>
            e == null ? null : Extension.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    identifier: (json['identifier'] as List)
        ?.map((e) =>
            e == null ? null : Identifier.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    name: (json['name'] as List)
        ?.map((e) =>
            e == null ? null : HumanName.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    telecom: (json['telecom'] as List)
        ?.map((e) =>
            e == null ? null : ContactPoint.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    gender: _$enumDecodeNullable(_$GenderEnumMap, json['gender']),
    birthDate: json['birthDate'] == null
        ? null
        : DateTime.parse(json['birthDate'] as String),
    address: (json['address'] as List)
        ?.map((e) =>
            e == null ? null : Address.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    maritalStatus: json['maritalStatus'] == null
        ? null
        : CodeableConcept.fromJson(
            json['maritalStatus'] as Map<String, dynamic>),
    multipleBirthBoolean: json['multipleBirthBoolean'] as bool,
    communication: (json['communication'] as List)
        ?.map((e) => e == null
            ? null
            : PatientCommunication.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PatientToJson(Patient instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resourceType', instance.resourceType);
  writeNotNull('id', instance.id);
  writeNotNull('meta', instance.meta?.toJson());
  writeNotNull('text', instance.text?.toJson());
  writeNotNull(
      'extension', instance.extension?.map((e) => e?.toJson())?.toList());
  writeNotNull(
      'identifier', instance.identifier?.map((e) => e?.toJson())?.toList());
  writeNotNull('name', instance.name?.map((e) => e?.toJson())?.toList());
  writeNotNull('telecom', instance.telecom?.map((e) => e?.toJson())?.toList());
  writeNotNull('gender', _$GenderEnumMap[instance.gender]);
  writeNotNull('birthDate', instance.birthDate?.toIso8601String());
  writeNotNull('address', instance.address?.map((e) => e?.toJson())?.toList());
  writeNotNull('maritalStatus', instance.maritalStatus?.toJson());
  writeNotNull('multipleBirthBoolean', instance.multipleBirthBoolean);
  writeNotNull('communication',
      instance.communication?.map((e) => e?.toJson())?.toList());
  return val;
}

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
  Gender.unknown: 'unknown',
};

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta(
    versionId: json['versionId'] as String,
    lastUpdated: json['lastUpdated'] == null
        ? null
        : DateTime.parse(json['lastUpdated'] as String),
  );
}

Map<String, dynamic> _$MetaToJson(Meta instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('versionId', instance.versionId);
  writeNotNull('lastUpdated', instance.lastUpdated?.toIso8601String());
  return val;
}

Narrative _$NarrativeFromJson(Map<String, dynamic> json) {
  return Narrative(
    status: json['status'] as String,
    div: json['div'] as String,
  );
}

Map<String, dynamic> _$NarrativeToJson(Narrative instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', instance.status);
  writeNotNull('div', instance.div);
  return val;
}

HumanName _$HumanNameFromJson(Map<String, dynamic> json) {
  return HumanName(
    use: json['use'] as String,
    family: json['family'] as String,
    given: (json['given'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$HumanNameToJson(HumanName instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('use', instance.use);
  writeNotNull('family', instance.family);
  writeNotNull('given', instance.given);
  return val;
}

ContactPoint _$ContactPointFromJson(Map<String, dynamic> json) {
  return ContactPoint(
    system: _$enumDecodeNullable(_$ContactPointSystemEnumMap, json['system']),
    value: json['value'] as String,
    use: json['use'] as String,
    rank: json['rank'] as int,
  );
}

Map<String, dynamic> _$ContactPointToJson(ContactPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('system', _$ContactPointSystemEnumMap[instance.system]);
  writeNotNull('value', instance.value);
  writeNotNull('use', instance.use);
  writeNotNull('rank', instance.rank);
  return val;
}

const _$ContactPointSystemEnumMap = {
  ContactPointSystem.phone: 'phone',
  ContactPointSystem.fax: 'fax',
  ContactPointSystem.email: 'email',
  ContactPointSystem.pager: 'pager',
  ContactPointSystem.url: 'url',
  ContactPointSystem.sms: 'sms',
  ContactPointSystem.other: 'other',
};

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    extension: (json['extension'] as List)
        ?.map((e) =>
            e == null ? null : Extension.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    line: (json['line'] as List)?.map((e) => e as String)?.toList(),
    use: _$enumDecodeNullable(_$AddressUseEnumMap, json['use']),
    city: json['city'] as String,
    district: json['district'] as String,
    state: json['state'] as String,
    postalCode: json['postalCode'] as String,
    country: json['country'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'extension', instance.extension?.map((e) => e?.toJson())?.toList());
  writeNotNull('line', instance.line);
  writeNotNull('use', _$AddressUseEnumMap[instance.use]);
  writeNotNull('city', instance.city);
  writeNotNull('district', instance.district);
  writeNotNull('state', instance.state);
  writeNotNull('postalCode', instance.postalCode);
  writeNotNull('country', instance.country);
  return val;
}

const _$AddressUseEnumMap = {
  AddressUse.home: 'home',
  AddressUse.work: 'work',
  AddressUse.temp: 'temp',
  AddressUse.old: 'old',
  AddressUse.billing: 'billing',
};

PatientCommunication _$PatientCommunicationFromJson(Map<String, dynamic> json) {
  return PatientCommunication(
    language: json['language'] == null
        ? null
        : CodeableConcept.fromJson(json['language'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PatientCommunicationToJson(
    PatientCommunication instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('language', instance.language?.toJson());
  return val;
}

Procedure _$ProcedureFromJson(Map<String, dynamic> json) {
  return Procedure(
    resourceType: json['resourceType'] as String,
    id: json['id'] as String,
    meta: json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    text: json['text'] == null
        ? null
        : Narrative.fromJson(json['text'] as Map<String, dynamic>),
    identifier: (json['identifier'] as List)
        ?.map((e) =>
            e == null ? null : Identifier.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    basedOnCarePlan: (json['basedOnCarePlan'] as List)
        ?.map((e) =>
            e == null ? null : Reference.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    status: _$enumDecodeNullable(_$ProcedureStatusEnumMap, json['status']),
    statusReason: json['statusReason'] == null
        ? null
        : CodeableConcept.fromJson(
            json['statusReason'] as Map<String, dynamic>),
    category: json['category'] == null
        ? null
        : CodeableConcept.fromJson(json['category'] as Map<String, dynamic>),
    code: json['code'] == null
        ? null
        : CodeableConcept.fromJson(json['code'] as Map<String, dynamic>),
    subject: json['subject'] == null
        ? null
        : Reference.fromJson(json['subject'] as Map<String, dynamic>),
    performedDateTime: json['performedDateTime'] == null
        ? null
        : DateTime.parse(json['performedDateTime'] as String),
    reasonCode: (json['reasonCode'] as List)
        ?.map((e) => e == null
            ? null
            : CodeableConcept.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    performedPeriod: json['performedPeriod'] == null
        ? null
        : Period.fromJson(json['performedPeriod'] as Map<String, dynamic>),
    instantiatesQuestionnaire: (json['instantiatesQuestionnaire'] as List)
        ?.map((e) => e as String)
        ?.toList(),
  );
}

Map<String, dynamic> _$ProcedureToJson(Procedure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resourceType', instance.resourceType);
  writeNotNull('id', instance.id);
  writeNotNull('meta', instance.meta?.toJson());
  writeNotNull('text', instance.text?.toJson());
  writeNotNull(
      'identifier', instance.identifier?.map((e) => e?.toJson())?.toList());
  writeNotNull('basedOnCarePlan',
      instance.basedOnCarePlan?.map((e) => e?.toJson())?.toList());
  writeNotNull('instantiatesQuestionnaire', instance.instantiatesQuestionnaire);
  writeNotNull('status', _$ProcedureStatusEnumMap[instance.status]);
  writeNotNull('statusReason', instance.statusReason?.toJson());
  writeNotNull('category', instance.category?.toJson());
  writeNotNull('code', instance.code?.toJson());
  writeNotNull('subject', instance.subject?.toJson());
  writeNotNull(
      'performedDateTime', instance.performedDateTime?.toIso8601String());
  writeNotNull('performedPeriod', instance.performedPeriod?.toJson());
  writeNotNull(
      'reasonCode', instance.reasonCode?.map((e) => e?.toJson())?.toList());
  return val;
}

const _$ProcedureStatusEnumMap = {
  ProcedureStatus.preparation: 'preparation',
  ProcedureStatus.in_progress: 'in-progress',
  ProcedureStatus.not_done: 'not-done',
  ProcedureStatus.suspended: 'suspended',
  ProcedureStatus.aborted: 'aborted',
  ProcedureStatus.completed: 'completed',
  ProcedureStatus.entered_in_error: 'entered-in-error',
  ProcedureStatus.unknown: 'unknown',
};

CarePlan _$CarePlanFromJson(Map<String, dynamic> json) {
  return CarePlan(
    resourceType: json['resourceType'] as String,
    id: json['id'] as String,
    meta: json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    identifier: (json['identifier'] as List)
        ?.map((e) =>
            e == null ? null : Identifier.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    basedOn: (json['basedOn'] as List)
        ?.map((e) =>
            e == null ? null : Reference.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    status: _$enumDecodeNullable(_$CarePlanStatusEnumMap, json['status']),
    intent: json['intent'] as String,
    category: (json['category'] as List)
        ?.map((e) => e == null
            ? null
            : CodeableConcept.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    description: json['description'] as String,
    subject: json['subject'] == null
        ? null
        : Reference.fromJson(json['subject'] as Map<String, dynamic>),
    period: json['period'] == null
        ? null
        : Period.fromJson(json['period'] as Map<String, dynamic>),
    created: json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String),
    activity: (json['activity'] as List)
        ?.map((e) =>
            e == null ? null : Activity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CarePlanToJson(CarePlan instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resourceType', instance.resourceType);
  writeNotNull('id', instance.id);
  writeNotNull('meta', instance.meta?.toJson());
  writeNotNull(
      'identifier', instance.identifier?.map((e) => e?.toJson())?.toList());
  writeNotNull('basedOn', instance.basedOn?.map((e) => e?.toJson())?.toList());
  writeNotNull('status', _$CarePlanStatusEnumMap[instance.status]);
  writeNotNull('intent', instance.intent);
  writeNotNull(
      'category', instance.category?.map((e) => e?.toJson())?.toList());
  writeNotNull('description', instance.description);
  writeNotNull('subject', instance.subject?.toJson());
  writeNotNull('period', instance.period?.toJson());
  writeNotNull('created', instance.created?.toIso8601String());
  writeNotNull(
      'activity', instance.activity?.map((e) => e?.toJson())?.toList());
  return val;
}

const _$CarePlanStatusEnumMap = {
  CarePlanStatus.draft: 'draft',
  CarePlanStatus.active: 'active',
  CarePlanStatus.suspended: 'suspended',
  CarePlanStatus.completed: 'completed',
  CarePlanStatus.entered_in_error: 'entered-in-error',
  CarePlanStatus.cancelled: 'cancelled',
  CarePlanStatus.unknown: 'unknown',
};

Identifier _$IdentifierFromJson(Map<String, dynamic> json) {
  return Identifier(
    value: json['value'] as String,
    system: json['system'] as String,
  );
}

Map<String, dynamic> _$IdentifierToJson(Identifier instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('value', instance.value);
  writeNotNull('system', instance.system);
  return val;
}

Period _$PeriodFromJson(Map<String, dynamic> json) {
  return Period(
    start:
        json['start'] == null ? null : DateTime.parse(json['start'] as String),
    end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
  );
}

Map<String, dynamic> _$PeriodToJson(Period instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('start', instance.start?.toIso8601String());
  writeNotNull('end', instance.end?.toIso8601String());
  return val;
}

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return Activity(
    detail: json['detail'] == null
        ? null
        : Detail.fromJson(json['detail'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ActivityToJson(Activity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('detail', instance.detail?.toJson());
  return val;
}

Detail _$DetailFromJson(Map<String, dynamic> json) {
  return Detail(
    code: json['code'] == null
        ? null
        : CodeableConcept.fromJson(json['code'] as Map<String, dynamic>),
    status: _$enumDecodeNullable(_$DetailStatusEnumMap, json['status']),
    statusReason: json['statusReason'] == null
        ? null
        : CodeableConcept.fromJson(
            json['statusReason'] as Map<String, dynamic>),
    doNotPerform: json['doNotPerform'] as bool,
    scheduledTiming: json['scheduledTiming'] == null
        ? null
        : Timing.fromJson(json['scheduledTiming'] as Map<String, dynamic>),
    scheduledPeriod: json['scheduledPeriod'] == null
        ? null
        : Period.fromJson(json['scheduledPeriod'] as Map<String, dynamic>),
    description: json['description'] as String,
    instantiatesCanonical: (json['instantiatesCanonical'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    reasonReference: (json['reasonReference'] as List)
        ?.map((e) =>
            e == null ? null : Reference.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DetailToJson(Detail instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code?.toJson());
  writeNotNull('status', _$DetailStatusEnumMap[instance.status]);
  writeNotNull('statusReason', instance.statusReason?.toJson());
  writeNotNull('doNotPerform', instance.doNotPerform);
  writeNotNull('scheduledTiming', instance.scheduledTiming?.toJson());
  writeNotNull('scheduledPeriod', instance.scheduledPeriod?.toJson());
  writeNotNull('description', instance.description);
  writeNotNull('instantiatesCanonical', instance.instantiatesCanonical);
  writeNotNull('reasonReference',
      instance.reasonReference?.map((e) => e?.toJson())?.toList());
  return val;
}

const _$DetailStatusEnumMap = {
  DetailStatus.not_started: 'not-started',
  DetailStatus.scheduled: 'scheduled',
  DetailStatus.in_progress: 'in-progress',
  DetailStatus.on_hold: 'on-hold',
  DetailStatus.completed: 'completed',
  DetailStatus.cancelled: 'cancelled',
  DetailStatus.stopped: 'stopped',
  DetailStatus.unknown: 'unknown',
  DetailStatus.entered_in_error: 'entered-in-error',
};

Timing _$TimingFromJson(Map<String, dynamic> json) {
  return Timing(
    repeat: json['repeat'] == null
        ? null
        : Repeat.fromJson(json['repeat'] as Map<String, dynamic>),
  )..code = json['code'] == null
      ? null
      : CodeableConcept.fromJson(json['code'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TimingToJson(Timing instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('repeat', instance.repeat?.toJson());
  writeNotNull('code', instance.code?.toJson());
  return val;
}

Repeat _$RepeatFromJson(Map<String, dynamic> json) {
  return Repeat(
    frequency: json['frequency'] as int,
    period: (json['period'] as num)?.toDouble(),
    periodUnit: json['periodUnit'] as String,
    durationUnit: json['durationUnit'] as String,
    duration: (json['duration'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$RepeatToJson(Repeat instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('duration', instance.duration);
  writeNotNull('durationUnit', instance.durationUnit);
  writeNotNull('frequency', instance.frequency);
  writeNotNull('period', instance.period);
  writeNotNull('periodUnit', instance.periodUnit);
  return val;
}

Range _$RangeFromJson(Map<String, dynamic> json) {
  return Range(
    low: json['low'] == null
        ? null
        : SimpleQuantity.fromJson(json['low'] as Map<String, dynamic>),
    high: json['high'] == null
        ? null
        : SimpleQuantity.fromJson(json['high'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RangeToJson(Range instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('low', instance.low?.toJson());
  writeNotNull('high', instance.high?.toJson());
  return val;
}

SimpleQuantity _$SimpleQuantityFromJson(Map<String, dynamic> json) {
  return SimpleQuantity(
    value: (json['value'] as num)?.toDouble(),
    unit: json['unit'] as String,
    system: json['system'] as String,
    code: json['code'] as String,
  );
}

Map<String, dynamic> _$SimpleQuantityToJson(SimpleQuantity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('value', instance.value);
  writeNotNull('unit', instance.unit);
  writeNotNull('system', instance.system);
  writeNotNull('code', instance.code);
  return val;
}

TimingAbbreviation _$TimingAbbreviationFromJson(Map<String, dynamic> json) {
  return TimingAbbreviation()
    ..display = json['display'] as String
    ..definition = json['definition'] as String;
}

Map<String, dynamic> _$TimingAbbreviationToJson(TimingAbbreviation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('display', instance.display);
  writeNotNull('definition', instance.definition);
  return val;
}

Questionnaire _$QuestionnaireFromJson(Map<String, dynamic> json) {
  return Questionnaire(
    resourceType: json['resourceType'] as String,
    name: json['name'] as String,
    id: json['id'] as String,
    meta: json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    version: json['version'] as String,
    titleBase: json['title'] as String,
    status: json['status'] as String,
    description: json['description'] as String,
    item: (json['item'] as List)
        ?.map((e) => e == null
            ? null
            : QuestionnaireItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    contained: (json['contained'] as List)
        ?.map((e) =>
            e == null ? null : ValueSet.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..titleExt = json['_title'] == null
      ? null
      : PrimitiveTypeExtension.fromJson(json['_title'] as Map<String, dynamic>);
}

Map<String, dynamic> _$QuestionnaireToJson(Questionnaire instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resourceType', instance.resourceType);
  writeNotNull('id', instance.id);
  writeNotNull('meta', instance.meta?.toJson());
  writeNotNull('version', instance.version);
  writeNotNull('name', instance.name);
  writeNotNull('status', instance.status);
  writeNotNull('description', instance.description);
  writeNotNull('item', instance.item?.map((e) => e?.toJson())?.toList());
  writeNotNull(
      'contained', instance.contained?.map((e) => e?.toJson())?.toList());
  writeNotNull('title', instance.titleBase);
  writeNotNull('_title', instance.titleExt?.toJson());
  return val;
}

CodeableConcept _$CodeableConceptFromJson(Map<String, dynamic> json) {
  return CodeableConcept(
    coding: (json['coding'] as List)
        ?.map((e) =>
            e == null ? null : Coding.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    text: json['text'] as String,
  );
}

Map<String, dynamic> _$CodeableConceptToJson(CodeableConcept instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('coding', instance.coding?.map((e) => e?.toJson())?.toList());
  writeNotNull('text', instance.text);
  return val;
}

Coding _$CodingFromJson(Map<String, dynamic> json) {
  return Coding(
    system: json['system'] as String,
    code: json['code'] as String,
    displayBase: json['display'] as String,
  )..displayExt = json['_display'] == null
      ? null
      : PrimitiveTypeExtension.fromJson(
          json['_display'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CodingToJson(Coding instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('system', instance.system);
  writeNotNull('code', instance.code);
  writeNotNull('display', instance.displayBase);
  writeNotNull('_display', instance.displayExt?.toJson());
  return val;
}

Extension _$ExtensionFromJson(Map<String, dynamic> json) {
  return Extension(
    valueString: json['valueString'] as String,
    valueCode: json['valueCode'] as String,
    valueBoolean: json['valueBoolean'] as bool,
    valueDecimal: json['valueDecimal'] as int,
    url: json['url'] as String,
    valueCanonical: json['valueCanonical'] as String,
    valueExpression: json['valueExpression'] == null
        ? null
        : ValueExpression.fromJson(
            json['valueExpression'] as Map<String, dynamic>),
    valueCodeableConcept: json['valueCodeableConcept'] == null
        ? null
        : CodeableConcept.fromJson(
            json['valueCodeableConcept'] as Map<String, dynamic>),
    valueCoding: json['valueCoding'] == null
        ? null
        : Coding.fromJson(json['valueCoding'] as Map<String, dynamic>),
    valueAddress: json['valueAddress'] == null
        ? null
        : Address.fromJson(json['valueAddress'] as Map<String, dynamic>),
    valueUri: json['valueUri'] as String,
    extension: (json['extension'] as List)
        ?.map((e) =>
            e == null ? null : Extension.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ExtensionToJson(Extension instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('valueAddress', instance.valueAddress?.toJson());
  writeNotNull('url', instance.url);
  writeNotNull('valueCanonical', instance.valueCanonical);
  writeNotNull('valueExpression', instance.valueExpression?.toJson());
  writeNotNull('valueCodeableConcept', instance.valueCodeableConcept?.toJson());
  writeNotNull('valueCoding', instance.valueCoding?.toJson());
  writeNotNull('valueString', instance.valueString);
  writeNotNull('valueCode', instance.valueCode);
  writeNotNull('valueBoolean', instance.valueBoolean);
  writeNotNull('valueDecimal', instance.valueDecimal);
  writeNotNull('valueUri', instance.valueUri);
  writeNotNull(
      'extension', instance.extension?.map((e) => e?.toJson())?.toList());
  return val;
}

ValueExpression _$ValueExpressionFromJson(Map<String, dynamic> json) {
  return ValueExpression(
    language: json['language'] as String,
    expression: json['expression'] as String,
  );
}

Map<String, dynamic> _$ValueExpressionToJson(ValueExpression instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('language', instance.language);
  writeNotNull('expression', instance.expression);
  return val;
}

QuestionnaireItem _$QuestionnaireItemFromJson(Map<String, dynamic> json) {
  return QuestionnaireItem(
    linkId: json['linkId'] as String,
    textBase: json['text'] as String,
    required: json['required'] as bool,
    type: _$enumDecodeNullable(_$QuestionTypeEnumMap, json['type']),
    code: (json['code'] as List)
        ?.map((e) =>
            e == null ? null : Coding.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    answerOption: (json['answerOption'] as List)
        ?.map((e) =>
            e == null ? null : AnswerOption.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    answerValueSet: json['answerValueSet'] as String,
    extension: (json['extension'] as List)
        ?.map((e) =>
            e == null ? null : Extension.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    item: (json['item'] as List)
        ?.map((e) => e == null
            ? null
            : QuestionnaireItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..textExt = json['_text'] == null
      ? null
      : PrimitiveTypeExtension.fromJson(json['_text'] as Map<String, dynamic>);
}

Map<String, dynamic> _$QuestionnaireItemToJson(QuestionnaireItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('linkId', instance.linkId);
  writeNotNull('required', instance.required);
  writeNotNull('type', _$QuestionTypeEnumMap[instance.type]);
  writeNotNull('code', instance.code?.map((e) => e?.toJson())?.toList());
  writeNotNull(
      'answerOption', instance.answerOption?.map((e) => e?.toJson())?.toList());
  writeNotNull('answerValueSet', instance.answerValueSet);
  writeNotNull(
      'extension', instance.extension?.map((e) => e?.toJson())?.toList());
  writeNotNull('item', instance.item?.map((e) => e?.toJson())?.toList());
  writeNotNull('text', instance.textBase);
  writeNotNull('_text', instance.textExt?.toJson());
  return val;
}

const _$QuestionTypeEnumMap = {
  QuestionType.group: 'group',
  QuestionType.display: 'display',
  QuestionType.boolean: 'boolean',
  QuestionType.decimal: 'decimal',
  QuestionType.integer: 'integer',
  QuestionType.date: 'date',
  QuestionType.dateTime: 'dateTime',
  QuestionType.time: 'time',
  QuestionType.string: 'string',
  QuestionType.text: 'text',
  QuestionType.url: 'url',
  QuestionType.choice: 'choice',
  QuestionType.open_choice: 'open-choice',
  QuestionType.attachment: 'attachment',
  QuestionType.reference: 'reference',
  QuestionType.quantity: 'quantity',
};

SupportLink _$SupportLinkFromJson(Map<String, dynamic> json) {
  return SupportLink(
    title: json['title'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$SupportLinkToJson(SupportLink instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('url', instance.url);
  return val;
}

AnswerOption _$AnswerOptionFromJson(Map<String, dynamic> json) {
  return AnswerOption(
    valueInteger: json['valueInteger'] as int,
    extension: (json['extension'] as List)
        ?.map((e) =>
            e == null ? null : Extension.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    valueCoding: json['valueCoding'] == null
        ? null
        : Coding.fromJson(json['valueCoding'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AnswerOptionToJson(AnswerOption instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('valueInteger', instance.valueInteger);
  writeNotNull(
      'extension', instance.extension?.map((e) => e?.toJson())?.toList());
  writeNotNull('valueCoding', instance.valueCoding?.toJson());
  return val;
}

QuestionnaireResponse _$QuestionnaireResponseFromJson(
    Map<String, dynamic> json) {
  return QuestionnaireResponse(
    resourceType: json['resourceType'] as String,
    id: json['id'] as String,
    meta: json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    questionnaire: json['questionnaire'] as String,
    basedOn: (json['basedOn'] as List)
        ?.map((e) =>
            e == null ? null : Reference.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    subject: json['subject'] == null
        ? null
        : Reference.fromJson(json['subject'] as Map<String, dynamic>),
    authored: json['authored'] == null
        ? null
        : DateTime.parse(json['authored'] as String),
    item: (json['item'] as List)
        ?.map((e) => e == null
            ? null
            : QuestionnaireResponseItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    status: _$enumDecodeNullable(
        _$QuestionnaireResponseStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$QuestionnaireResponseToJson(
    QuestionnaireResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resourceType', instance.resourceType);
  writeNotNull('id', instance.id);
  writeNotNull('meta', instance.meta?.toJson());
  writeNotNull('questionnaire', instance.questionnaire);
  writeNotNull('basedOn', instance.basedOn?.map((e) => e?.toJson())?.toList());
  writeNotNull('subject', instance.subject?.toJson());
  writeNotNull('authored', instance.authored?.toIso8601String());
  writeNotNull('item', instance.item?.map((e) => e?.toJson())?.toList());
  writeNotNull('status', _$QuestionnaireResponseStatusEnumMap[instance.status]);
  return val;
}

const _$QuestionnaireResponseStatusEnumMap = {
  QuestionnaireResponseStatus.in_progress: 'in-progress',
  QuestionnaireResponseStatus.stopped: 'stopped',
  QuestionnaireResponseStatus.completed: 'completed',
  QuestionnaireResponseStatus.amended: 'amended',
  QuestionnaireResponseStatus.entered_in_error: 'entered-in-error',
};

Content _$ContentFromJson(Map<String, dynamic> json) {
  return Content(
    attachment: json['attachment'] == null
        ? null
        : Attachment.fromJson(json['attachment'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ContentToJson(Content instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('attachment', instance.attachment?.toJson());
  return val;
}

DocumentReference _$DocumentReferenceFromJson(Map<String, dynamic> json) {
  return DocumentReference(
    description: json['description'] as String,
    content: (json['content'] as List)
        ?.map((e) =>
            e == null ? null : Content.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    type: json['type'] == null
        ? null
        : CodeableConcept.fromJson(json['type'] as Map<String, dynamic>),
    status: json['status'] as String,
  );
}

Map<String, dynamic> _$DocumentReferenceToJson(DocumentReference instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('content', instance.content?.map((e) => e?.toJson())?.toList());
  writeNotNull('type', instance.type?.toJson());
  writeNotNull('status', instance.status);
  return val;
}

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return Attachment(
    url: json['url'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$AttachmentToJson(Attachment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
  writeNotNull('title', instance.title);
  return val;
}

Reference _$ReferenceFromJson(Map<String, dynamic> json) {
  return Reference(
    reference: json['reference'] as String,
  );
}

Map<String, dynamic> _$ReferenceToJson(Reference instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('reference', instance.reference);
  return val;
}

QuestionnaireResponseItem _$QuestionnaireResponseItemFromJson(
    Map<String, dynamic> json) {
  return QuestionnaireResponseItem(
    linkId: json['linkId'] as String,
    answer: (json['answer'] as List)
        ?.map((e) =>
            e == null ? null : Answer.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$QuestionnaireResponseItemToJson(
    QuestionnaireResponseItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('linkId', instance.linkId);
  writeNotNull('answer', instance.answer?.map((e) => e?.toJson())?.toList());
  return val;
}

Answer _$AnswerFromJson(Map<String, dynamic> json) {
  return Answer(
    valueDecimal: (json['valueDecimal'] as num)?.toDouble(),
    valueInteger: json['valueInteger'] as int,
    valueCoding: json['valueCoding'] == null
        ? null
        : Coding.fromJson(json['valueCoding'] as Map<String, dynamic>),
    valueString: json['valueString'] as String,
    valueDate: json['valueDate'] == null
        ? null
        : DateTime.parse(json['valueDate'] as String),
    valueDateTime: json['valueDateTime'] == null
        ? null
        : DateTime.parse(json['valueDateTime'] as String),
  );
}

Map<String, dynamic> _$AnswerToJson(Answer instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('valueInteger', instance.valueInteger);
  writeNotNull('valueDecimal', instance.valueDecimal);
  writeNotNull('valueCoding', instance.valueCoding?.toJson());
  writeNotNull('valueString', instance.valueString);
  writeNotNull('valueDate', instance.valueDate?.toIso8601String());
  writeNotNull('valueDateTime', instance.valueDateTime?.toIso8601String());
  return val;
}

ValueSet _$ValueSetFromJson(Map<String, dynamic> json) {
  return ValueSet(
    resourceType: json['resourceType'] as String,
    id: json['id'] as String,
    language: json['language'] as String,
    url: json['url'] as String,
    status: json['status'] as String,
    expansion: json['expansion'] == null
        ? null
        : Expansion.fromJson(json['expansion'] as Map<String, dynamic>),
    compose: json['compose'] == null
        ? null
        : Compose.fromJson(json['compose'] as Map<String, dynamic>),
  )..meta = json['meta'] == null
      ? null
      : Meta.fromJson(json['meta'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ValueSetToJson(ValueSet instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resourceType', instance.resourceType);
  writeNotNull('id', instance.id);
  writeNotNull('meta', instance.meta?.toJson());
  writeNotNull('language', instance.language);
  writeNotNull('url', instance.url);
  writeNotNull('status', instance.status);
  writeNotNull('expansion', instance.expansion?.toJson());
  writeNotNull('compose', instance.compose?.toJson());
  return val;
}

Compose _$ComposeFromJson(Map<String, dynamic> json) {
  return Compose(
    include: (json['include'] as List)
        ?.map((e) =>
            e == null ? null : Include.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ComposeToJson(Compose instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('include', instance.include?.map((e) => e?.toJson())?.toList());
  return val;
}

Include _$IncludeFromJson(Map<String, dynamic> json) {
  return Include(
    concept: (json['concept'] as List)
        ?.map((e) =>
            e == null ? null : Coding.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$IncludeToJson(Include instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('concept', instance.concept?.map((e) => e?.toJson())?.toList());
  return val;
}

Concept _$ConceptFromJson(Map<String, dynamic> json) {
  return Concept(
    concept: (json['concept'] as List)
        ?.map((e) =>
            e == null ? null : Concept.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ConceptToJson(Concept instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('concept', instance.concept?.map((e) => e?.toJson())?.toList());
  return val;
}

Expansion _$ExpansionFromJson(Map<String, dynamic> json) {
  return Expansion(
    identifier: json['identifier'] as String,
    timestamp: json['timestamp'] as String,
    total: json['total'] as int,
    parameter: (json['parameter'] as List)
        ?.map((e) =>
            e == null ? null : Parameter.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    contains: (json['contains'] as List)
        ?.map((e) =>
            e == null ? null : Coding.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ExpansionToJson(Expansion instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('identifier', instance.identifier);
  writeNotNull('timestamp', instance.timestamp);
  writeNotNull('total', instance.total);
  writeNotNull(
      'parameter', instance.parameter?.map((e) => e?.toJson())?.toList());
  writeNotNull(
      'contains', instance.contains?.map((e) => e?.toJson())?.toList());
  return val;
}

Parameter _$ParameterFromJson(Map<String, dynamic> json) {
  return Parameter(
    name: json['name'] as String,
    valueUri: json['valueUri'] as String,
    valueInteger: json['valueInteger'] as int,
  );
}

Map<String, dynamic> _$ParameterToJson(Parameter instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('valueUri', instance.valueUri);
  writeNotNull('valueInteger', instance.valueInteger);
  return val;
}
