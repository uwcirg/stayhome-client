/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppDrawer.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:map_app_flutter/platform_stub.dart';
import 'package:scoped_model/scoped_model.dart';

class ProgramEnrollmentPage extends StatelessWidget {
  final String programSiteName;

  ProgramEnrollmentPage({this.programSiteName});

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
      // no program specified. Go back home
      if (this.programSiteName == null) {
        goHomeOnNextOpportunity(context);
        return Center(child: CircularProgressIndicator());
      }

      Uri uri = Uri.tryParse(PlatformDefs().currentUrl());
      if (model.isLoading) {
        return Center(child: CircularProgressIndicator());
      }

      if (!model.hasNoUser && !model.hasNoPatient) {
        if (!model.hasConsentForProgram(this.programSiteName)) {
          print("Adding consent for: $programSiteName");
          model.addConsentForProgram(this.programSiteName).then((value) {
            goHomeOnNextOpportunity(context);
          });
        } else {
          print("No consent to add. Going back home.");
          goHomeOnNextOpportunity(context);
        }
      } else {
        bool hasAuthCode =
            !((uri?.query?.isEmpty ?? false) || !uri.queryParameters.containsKey("code"));

        if (!hasAuthCode) {
          // cannot establish account. Try login.
          MyApp.of(context).auth.mapAppLogin(redirectUrl: _redirectUrl());
        } else {
          // auth params available. receiveCallback and load!
          var auth = MyApp.of(context).auth;

          auth.receivedCallback(PlatformDefs().currentUrl(), redirectUrl: _redirectUrl()).then((d) {
            auth.getUserInfo().then((value) {
              String keycloakUserId = auth.userInfo.keycloakUserId;
              ScopedModel.of<CarePlanModel>(context).setUserAndAuthToken(keycloakUserId, auth);
            });
          }).catchError((error) {
            print("Error in ProgramLandingPage: $error");
          });
        }
      }

      return Center(child: CircularProgressIndicator());
    }));
  }

  void goHomeOnNextOpportunity(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      MapAppDrawer.navigate(context, '/home', fromDrawer: true);
    });
  }

  String _redirectUrl() => '${PlatformDefs().rootUrl()}/#/enroll?program=${this.programSiteName}';
}
