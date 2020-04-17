import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:map_app_flutter/value_utils.dart';
import 'package:test/test.dart';

void main() {
  group("C to F conversion", () {
    test('ºC to ºF conversion', () => expect(cToF(0), 32));
    test('ºC to ºF conversion', () => expect(cToF(-40), -40));
    test('ºC to ºF conversion', () => expect(cToF(100), 212));
  });

  group("Consent updates", () {
    Patient patient = Patient(id: "dummyPat");
    Reference organization = Reference(reference: "Organization/dummyOrg");
    Coding contentClass1 = Coding(system: "dummySystem1", code: "dummyCode1");
    Coding contentClass2 = Coding(system: "dummySystem2", code: "dummyCode2");

    List<Consent> consents = [
      Consent.from(patient, organization, contentClass1, ProvisionType.deny),
      Consent.from(patient, organization, contentClass2, ProvisionType.deny)
    ];

    test('no updates', () {
      DataSharingConsents dataSharingConsents = DataSharingConsents.from(consents);
      int newConsentCount = dataSharingConsents.generateNewConsents(patient).length;
      expect(newConsentCount, 0);
    });

    test('set one to permit', () {
      DataSharingConsents dataSharingConsents = DataSharingConsents.from(consents);
      dataSharingConsents[organization][contentClass1] = ProvisionType.permit;
      int newConsentCount = dataSharingConsents.generateNewConsents(patient).length;
      expect(newConsentCount, 1);
    });

    test('set one to permit and then back to deny', () {
      DataSharingConsents dataSharingConsents = DataSharingConsents.from(consents);
      dataSharingConsents[organization][contentClass2] = ProvisionType.permit;
      dataSharingConsents[organization][contentClass2] = ProvisionType.deny;
      int newConsentCount = dataSharingConsents.generateNewConsents(patient).length;
      expect(newConsentCount, 0);
    });

    test('update both to permit, then reset', () {
      DataSharingConsents dataSharingConsents = DataSharingConsents.from(consents);
      dataSharingConsents[organization][contentClass1] = ProvisionType.permit;
      dataSharingConsents[organization][contentClass2] = ProvisionType.permit;
      dataSharingConsents.reset();
      int newConsentCount = dataSharingConsents.generateNewConsents(patient).length;
      expect(newConsentCount, 0);
    });
  });
}
