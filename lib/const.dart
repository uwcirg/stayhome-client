/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';

class Dimensions {
  static const double largeMargin = 24;
  static const double fullMargin = 16;
  static const double halfMargin = fullMargin / 2;
  static const double quarterMargin = fullMargin / 4;

  static const double profileImageSize = 64;

  Dimensions._();
}

class MapAppPadding {
  static const buttonIconEdgeInsets =
      const EdgeInsets.only(right: Dimensions.halfMargin);
  static const cardPageMargins = const EdgeInsets.all(Dimensions.halfMargin);
  static const pageMargins = const EdgeInsets.all(Dimensions.fullMargin);

  MapAppPadding._();
}

class IconSize {
  static const double small = 18;
  static const double medium = 24;
  static const double large = 36;
  static const double xlarge = 48;

  IconSize._();
}
