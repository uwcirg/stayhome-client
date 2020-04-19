/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:map_app_flutter/fhir/FhirResources.dart';

class FhirTranslationUtils {
  FhirTranslationUtils._();

  static String extractTranslation(String baseString, PrimitiveTypeExtension extension,
      String languageCode) {
    Extension translationExt = extension?.extension?.firstWhere(
            (Extension translationExt) =>
        translationExt.url == "http://hl7.org/fhir/StructureDefinition/translation" &&
            (translationExt.extension?.any((Extension langExtension) =>
            langExtension.url == "lang" && langExtension.valueCode == languageCode) ??
                false),
        orElse: () => null);
    Extension contentExt = translationExt?.extension
        ?.firstWhere((Extension e) => e.url == "content", orElse: () => null);
    if (contentExt == null) return baseString;
    return contentExt.valueString;
  }
}