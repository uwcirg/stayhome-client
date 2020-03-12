/*
 * Copyright (c) 2020 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';

import 'platform_interface.dart'
    if (dart.library.io) 'package:map_app_flutter/mobile_defs.dart'
    if (dart.library.html) 'package:map_app_flutter/web_defs.dart';

abstract class PlatformDefs {
  String redirectUrl();

  Future launchUrl(String url, {bool newTab = false});

  Widget getAuthCallbackPage();

  factory PlatformDefs() => getPlatformDefs();
}
