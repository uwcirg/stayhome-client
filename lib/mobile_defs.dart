/*
 * Copyright (c) 2020 Hannah Burkhardt. All rights reserved.
 */
import 'package:map_app_flutter/platform_stub.dart';

class MobileDefs implements PlatformDefs {

  String redirectUrl() {
    return 'edu.washington.cirg.mapapp:/callback';
  }

}
PlatformDefs getPlatformDefs() => MobileDefs();
