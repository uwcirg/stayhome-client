/*
 * Copyright (c) 2020 Hannah Burkhardt. All rights reserved.
 */

import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:map_app_flutter/platform_stub.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class WebDefs implements PlatformDefs {
  String redirectUrl() {
//    return 'http://[::1]:59201/#/authCallback';
    return 'https://stayhome.cirg.washington.edu/#/authCallback';
  }
  String rootUrl() {
//    return 'http://[::1]:59201';
    return 'https://stayhome.cirg.washington.edu';
  }

  @override
  Future launchUrl(String url, {bool newTab = false}) async {
    if (await canLaunch(url).catchError((error) => print("Error: $error"))) {
      if (newTab) {
        await launch(url);
      } else {
        window.open(url, "_self");
      }
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }

  @override
  Widget getAuthCallbackPage() {
    return AuthCallbackPage();
  }
}

class AuthCallbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyApp.of(context).auth.receivedCallback(window.location.href).then((d) {
      dismissLoginScreen(context);
    });
    return Center(child: CircularProgressIndicator());
  }

  // TODO clean up duplicated code here
  void dismissLoginScreen(BuildContext context) {
    MyApp.of(context).auth.getUserInfo().then((value) {
      var keycloakUserId = MyApp.of(context).auth.userInfo.keycloakUserId;
      ScopedModel.of<CarePlanModel>(context).setUser(keycloakUserId);
      Navigator.of(context).pushReplacementNamed('/home');
    }).catchError((error) {
      Navigator.of(context).pushReplacementNamed('/guestHome');
    });
  }
}

PlatformDefs getPlatformDefs() => WebDefs();
