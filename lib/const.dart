/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';

import 'fhir/FhirResources.dart';

class Dimensions {
  static const double largeMargin = 24;
  static const double fullMargin = 16;
  static const double halfMargin = fullMargin / 2;
  static const double quarterMargin = fullMargin / 4;

  static const double profileImageSize = 60;

  static const double borderWidth = 0.5;

  Dimensions._();
}

class MapAppPadding {
  static const buttonIconEdgeInsets = const EdgeInsets.only(right: Dimensions.halfMargin);
  static const cardPageMargins = const EdgeInsets.all(Dimensions.halfMargin);
  static const pageMargins = const EdgeInsets.all(Dimensions.fullMargin);
  static const largeButtonPadding = const EdgeInsets.all(10);

  MapAppPadding._();
}

class FhirConstants {
  static const SNOMED_PELVIC_FLOOR_EXERCISES = "183306002";

  static const String ASSESSMENT_SCALES = "273249006";
}

class IconSize {
  static const double small = 18;
  static const double small_medium = 21;
  static const double medium = 24;
  static const double large = 36;
  static const double xlarge = 48;

  IconSize._();
}

class VersionInfo {
  //TODO possible to get this dynamically? package_info package?
  static const String version = "v0.1";
}

class WhatInfo {
  static const String link = "https://uwcirg.github.io/stayhomelanding/";
}
