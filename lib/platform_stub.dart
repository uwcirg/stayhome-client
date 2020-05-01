/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';

import 'platform_interface.dart'
    if (dart.library.io) 'package:map_app_flutter/mobile_defs.dart'
    if (dart.library.html) 'package:map_app_flutter/web_defs.dart';

abstract class PlatformDefs {
  String redirectUrl();
  String rootUrl();
  String currentUrl();
  addToHomeScreen(Function onBeforeInstallPrompt);
  onAddToHomeScreenButtonPressed(deferredPrompt);

  Future launchUrl(String url, {bool newTab = false});

  Widget getAuthCallbackPage();

  factory PlatformDefs() => getPlatformDefs();
}
