/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:map_app_flutter/platform_stub.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simple_auth_flutter/simple_auth_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    SimpleAuthFlutter.init(context);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    double buttonContainerInsets = deviceInfo.size.width > 768 ? deviceInfo.size.width / 5 : 12;
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyApp.of(context).appAssets.systemUiOverlayStyle,
      child: DecoratedBox(
          position: DecorationPosition.background,
          decoration: MyApp.of(context).appAssets.loginBackgroundDecoration(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MyApp.of(context).appAssets.loginBanner(context),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: buttonContainerInsets),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Visibility(
                          visible: MyApp.of(context).auth.refreshTokenExpired,
                          child: Text(S.of(context).session_expired_please_log_in_again),
                        ),
                        RaisedButton(
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () => MyApp.of(context)
                                .auth
                                .mapAppLogin()
                                .then((value) => MyApp.of(context).dismissLoginScreen(context))
                                .catchError((error) => snack("$error", context)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  S.of(context).login,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .apply(color: Theme.of(context).primaryColor),
                                  textAlign: TextAlign.center,
                                ))),
                        ...MyApp.of(context).appAssets.additionalLoginPageViews(context),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: OutlineButton(
                              onPressed: () => MyApp.of(context).dismissLoginScreen(context),                              borderSide: BorderSide(color: Colors.white, width: 6),
                              highlightElevation: 0,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(S.of(context).not_now,
                                      style: Theme.of(context).primaryTextTheme.title))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: FlatButton(
                                  // onPressed: () => MyApp.of(context)
                                  //     .auth
                                  //     .dummyLogin()
                                  //     .then((value) => dismissLoginScreen(context))
                                  //     .catchError((error) => snack("$error", context)),
                                  onPressed: () => PlatformDefs().launchUrl(WhatInfo.link),
                                  child: Padding(
                                      padding: EdgeInsets.all(Dimensions.fullMargin),
                                      child: Text("What’s StayHome?",
                                          style: TextStyle(
                                              color: Colors.white,
                                              decoration: TextDecoration.underline)))),
                            ),
                            Text(VersionInfo.version,
                                style: Theme.of(context).primaryTextTheme.subtitle)
//                          FlatButton(
//                              onPressed: () => MyApp.of(context).toggleAppMode(),
//                              child: Text("Toggle app mode",
//                                  style: Theme.of(context).primaryTextTheme.subtitle)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    ));
  }

}
