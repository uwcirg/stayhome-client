/*
 * Copyright (c) 2020 Hannah Burkhardt. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:map_app_flutter/platform_stub.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileDefs implements PlatformDefs {

  String redirectUrl() {
    return 'edu.washington.cirg.mapapp:/callback';
  }
  String rootUrl() {
    return 'edu.washington.cirg.mapapp';
  }

  @override
  Future launchUrl(String url, {bool newTab = false}) async {
    if (await canLaunch(url)
        .catchError((error) => print("Error: $error"))) {
      await launch(url);
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }

  @override
  Widget getAuthCallbackPage() {
    return Container();
  }

  @override
  addToHomeScreen(Function onBeforeInstallPrompt) {
  }

  @override
  onAddToHomeScreenButtonPressed(deferredPrompt) {
  }



}



PlatformDefs getPlatformDefs() => MobileDefs();
