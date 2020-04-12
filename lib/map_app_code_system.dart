/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:map_app_flutter/fhir/FhirResources.dart';

class CommunicationCategory extends Coding {
  static const _system = "https://stayhome.app/CodeSystem/communication-category";

  CommunicationCategory._(String code) : super(system: _system, code: code);

  static CommunicationCategory systemAnnouncement = CommunicationCategory._("system-announcement");
}

class ConsentContentClass extends Coding {
  static const _system = "https://stayhome.app/CodeSystem/consent-content-class";

  ConsentContentClass._(String code) : super(system: _system, code: code);

  static ConsentContentClass location = ConsentContentClass._("location");
  static ConsentContentClass contactInformation = ConsentContentClass._("contact-information");
  static ConsentContentClass aboutYou = ConsentContentClass._("demographics");
}

class ConsentScope extends Coding {
  ConsentScope._(String code) : super(system: _system, code: code);
  static const _system = "http://terminology.hl7.org/CodeSystem/consentscope";
  static ConsentScope patientPrivacy = ConsentScope._("patient-privacy");
}
