/*
 * Copyright (c) 2020 Hannah Burkhardt. All rights reserved.
 */

import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthCallbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyApp.of(context).auth.receivedCallback(window.location.href).then((d) {
      dismissLoginScreen(context);
    });
    return Text("This is the /authCallback page. Url: \n${window.location.href}");
  }
  // TODO clean up duplicated code here
  void dismissLoginScreen(BuildContext context) {
    MyApp.of(context).auth.getUserInfo().then((value) {
      var keycloakUserId = MyApp.of(context).auth.userInfo.keycloakUserId;
      var templateRef = MyApp.of(context).themeAssets.careplanTemplateRef;
      ScopedModel.of<CarePlanModel>(context)
          .setUser(keycloakUserId, careplanTemplateRef: templateRef);
      Navigator.of(context).pushReplacementNamed('/home');
    }).catchError((error) {
      Navigator.of(context).pushReplacementNamed('/guestHome');
    });
  }

}
