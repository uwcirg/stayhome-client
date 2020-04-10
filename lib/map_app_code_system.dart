/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:map_app_flutter/fhir/FhirResources.dart';

class CommunicationCategory extends Coding {
  static const _system = "https://stayhome.app/CodeSystem/communication-category";

  CommunicationCategory._(String code) : super(system: _system, code: code);

  static CommunicationCategory systemAnnouncement = CommunicationCategory._("system-announcement");
}
