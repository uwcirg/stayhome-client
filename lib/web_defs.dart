/*
 * Copyright (c) 2020 Hannah Burkhardt. All rights reserved.
 */

import 'dart:html';

import 'package:map_app_flutter/platform_stub.dart';

class WebDefs implements PlatformDefs {

  String redirectUrl() {
    return window.location.href + 'authCallback';
  }

}
PlatformDefs getPlatformDefs() => WebDefs();
