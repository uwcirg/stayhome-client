/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/platform_stub.dart';

class Dimensions {
  static const double extraLargeMargin = 42;
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
  static const largeButtonPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: Dimensions.largeMargin);

  MapAppPadding._();
}

class IconSize {
  static const double small = 18;
  static const double small_medium = 21;
  static const double medium = 24;
  static const double large = 36;
  static const double xlarge = 48;

  IconSize._();
}

class WhatInfo {
  static const String link = "https://uwcirg.github.io/stayhome-project/";
  static String changelogLink = "https://uwcirg.github.io/stayhome-project/?return_uri=" +
      Uri.encodeComponent(PlatformDefs().rootUrl()) +
      "#change-log";
  static const String cirgLink = "https://www.cirg.washington.edu/";
  static const String resourceLink = "https://uwcirg.github.io/stayhomeresources";
  static const String _resourceLinkZipPrefix = "https://uwcirg.github.io/stayhomeresources?zip=";
  static const String contactLink = "mailto:help@stayhome-app.on.spiceworks.com";
  static const String cdcSymptomSelfCheckerLink =
      "https://uwcirg.github.io/stayhome-project/gotoCDCbot.html";

  static String resourceLinkWithZip(String zip) {
    if (_resourceLinkZipPrefix == null || zip == null) return resourceLink;
    // append the zip code string
    return _resourceLinkZipPrefix + zip;
  }
}

class QuestionnaireConstants {
  static const double minF = 90;
  static const double maxF = 115;
  static const double minC = 32;
  static const double maxC = 46;
}

/*
 * media query constants to allow setting breakpoints for responsiveness 
 */
class MediaQueryConstants {
  static const double minTabletWidth = 699;
  static const double minDesktopWidth = 768;
}
