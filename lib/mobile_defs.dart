/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/platform_stub.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileDefs implements PlatformDefs {
  String redirectUrl() {
    return 'edu.washington.cirg.mapapp:/callback';
  }

  String rootUrl() {
    return 'edu.washington.cirg.mapapp';
  }

  String currentUrl() {
    throw UnimplementedError("No URL for Mobile");
  }

  @override
  Future launchUrl(String url, {bool newTab = false}) async {
    if (await canLaunch(url).catchError((error) => print("Error: $error"))) {
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
  addToHomeScreen(Function onBeforeInstallPrompt) {}

  @override
  onAddToHomeScreenButtonPressed(deferredPrompt) {}

  dynamic evaluateFhirPathExpression(resource, expression) {
    if (expression != "answers().sum(value.ordinal())") {
      throw UnsupportedError("FhirPath expression not supported on mobile: ${expression}");
    }
    if (resource.resourceType != "QuestionnaireResponse") {
      throw ArgumentError(
          "Resource type not supported for FhirPath expression on mobile: ${resource.resourceType}");
    }
    QuestionnaireResponse r = resource;
    int sum = 0;
    r.item.forEach((QuestionnaireResponseItem r) {
      r.answer.forEach((Answer a) {
        int ordinalValue = a.ordinalValue();
        if (a.ordinalValue() != -1) sum += ordinalValue;
      });
    });
    return sum;
  }
}

PlatformDefs getPlatformDefs() => MobileDefs();
