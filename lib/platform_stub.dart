/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';

import 'platform_interface.dart'
    if (dart.library.io) 'package:map_app_flutter/mobile_defs.dart'
    if (dart.library.html) 'package:map_app_flutter/web_defs.dart';

abstract class PlatformDefs {
  String redirectUrl({String site});
  String rootUrl();
  addToHomeScreen(Function onBeforeInstallPrompt);
  onAddToHomeScreenButtonPressed(deferredPrompt);

  String extractSiteName();

  Future launchUrl(String url, {bool newTab = false});

  Widget getAuthCallbackPage({String site});

  factory PlatformDefs() => getPlatformDefs();
}
