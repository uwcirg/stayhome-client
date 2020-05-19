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
  static ConsentContentClass symptomsTestingConditions = ConsentContentClass._("symptoms-testing-conditions");
  static ConsentContentClass contactInformation = ConsentContentClass._("contact-information");
  static ConsentContentClass all = ConsentContentClass._("location_contact-information_symptoms-testing-conditions");
}

class ConsentScope extends Coding {
  ConsentScope._(String code) : super(system: _system, code: code);
  static const _system = "http://terminology.hl7.org/CodeSystem/consentscope";
  static ConsentScope patientPrivacy = ConsentScope._("patient-privacy");
}

class ConsentCategory extends Coding {
  static const _system = "http://loinc.org";
  ConsentCategory._(String code): super(system: _system, code: code);
  static ConsentCategory patientConsent = ConsentCategory._("59284-0");
}

class CommunicationLanguage extends Coding {
  static const _system = "urn:ietf:bcp:47";
  CommunicationLanguage(String code): super(system: _system, code: code);
}

class OrganizationReference extends Reference {
  static const _resourceType = "Organization";

  static OrganizationReference fromName(String site) {
    switch (site) {
      case 'scan': return OrganizationReference.scan;
      case 'fiuNeighborhoodHelp': return OrganizationReference.fiuNeighborhoodHelp;
      case 'fiu': return OrganizationReference.fiu;
      case 'publicHealthAgencies': return OrganizationReference.publicHealthAgencies;
      case 'researchers': return OrganizationReference.researchers;
      case 'socialDistancingStudy': return OrganizationReference.socialDistancingStudy;
    }
    return null;
  }

  OrganizationReference._(String id): super(reference: "$_resourceType/$id");
  static OrganizationReference scan = OrganizationReference._("1463");
  static OrganizationReference fiuNeighborhoodHelp = OrganizationReference._("1464");
  static OrganizationReference fiu = OrganizationReference._("1465");
  static OrganizationReference publicHealthAgencies = OrganizationReference._("1466");
  static OrganizationReference researchers = OrganizationReference._("1467");
  static OrganizationReference socialDistancingStudy = OrganizationReference._("1737");
}