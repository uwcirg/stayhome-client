/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:map_app_flutter/config/AppConfig.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/platform_stub.dart';
import 'package:url_launcher/url_launcher.dart';

class WebDefs implements PlatformDefs {
  String redirectUrl() {
    return '${rootUrl()}/#/authCallback';
  }

  String rootUrl() {
    return AppConfig.appRootUrl;
  }

  @override
  Future launchUrl(String url, {bool newTab = false, bool targetBlank}) async {
    if (await canLaunch(url).catchError((error) => print("Error: $error"))) {
      if (targetBlank) {
        window.open(url, "_blank");
      } else {
        if (newTab) {
          await launch(url);
        } else {
          window.open(url, "_self");
        }
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

  @override
  addToHomeScreen(Function onBeforeInstallPrompt) {
    var deferredPrompt;

    window.addEventListener('beforeinstallprompt', (prompt) {
      // Prevent Chrome 67 and earlier from automatically showing the prompt
      prompt.preventDefault();
      // Stash the event so it can be triggered later.
      onBeforeInstallPrompt(prompt);
    });
  }

  onAddToHomeScreenButtonPressed(deferredPrompt) {
    // hide our user interface that shows our A2HS button

    // Show the prompt
    deferredPrompt.prompt();
    // Wait for the user to respond to the prompt
    deferredPrompt.userChoice.then((choiceResult) {
      if (choiceResult.outcome == 'accepted') {
        print('User accepted the A2HS prompt');
      } else {
        print('User dismissed the A2HS prompt');
      }
      deferredPrompt = null;
    });
  }
}

class AuthCallbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyApp.of(context).auth.receivedCallback(window.location.href).then((d) {
      MyApp.of(context).dismissLoginScreen(context);
    }).catchError((error) {
      snack("$error", context);
      Navigator.of(context).pushReplacementNamed('/login');
    });
    return Center(child: CircularProgressIndicator());
  }
}

PlatformDefs getPlatformDefs() => WebDefs();
