/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simple_auth_flutter/simple_auth_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!kIsWeb) SimpleAuthFlutter.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyApp.of(context).themeAssets.systemUiOverlayStyle,
      child: DecoratedBox(
          position: DecorationPosition.background,
          decoration: MyApp.of(context).themeAssets.loginBackgroundImagePath != null
              ? BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(MyApp.of(context).themeAssets.loginBackgroundImagePath),
                      fit: BoxFit.fitHeight,
                      alignment: FractionalOffset(0.8, 0)))
              : BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MyApp.of(context).themeAssets.loginBanner(context),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Visibility(
                        visible: MyApp.of(context).auth.refreshTokenExpired,
                        child: Text(S.of(context).session_expired_please_log_in_again),
                      ),
                      RaisedButton(
                          color: Color.fromRGBO(255, 255, 255, 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                          ),
                          elevation: 0,
                          onPressed: () => MyApp.of(context)
                              .auth
                              .mapAppLogin()
                              .then((value) => dismissLoginScreen(context))
                              .catchError((error) => snack("$error", context)),
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                S.of(context).login,
                                style:
                                    Theme.of(context).textTheme.subhead.apply(color: Colors.black),
                                textAlign: TextAlign.center,
                              ))),
                      ...MyApp.of(context).themeAssets.additionalLoginPageViews(context),
                      FlatButton(
                          onPressed: () => dismissLoginScreen(context),
                          child: Padding(
                              padding: EdgeInsets.all(Dimensions.fullMargin),
                              child: Text(S.of(context).not_now,
                                  style: Theme.of(context).primaryTextTheme.subtitle))),
                      Row(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () => MyApp.of(context)
                                  .auth
                                  .dummyLogin()
                                  .then((value) => dismissLoginScreen(context))
                                  .catchError((error) => snack("$error", context)),
                              child: Padding(
                                  padding: EdgeInsets.all(Dimensions.fullMargin),
                                  child: Text("Demo",
                                      style: Theme.of(context).primaryTextTheme.subtitle))),
//                          FlatButton(
//                              onPressed: () => MyApp.of(context).toggleAppMode(),
//                              child: Text("Toggle app mode",
//                                  style: Theme.of(context).primaryTextTheme.subtitle)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    ));
  }

  void dismissLoginScreen(BuildContext context) {
    if (MyApp.of(context).auth.isLoggedIn) {
      MyApp.of(context).auth.getUserInfo().then((value) {
        var keycloakUserId = MyApp.of(context).auth.userInfo.keycloakUserId;
        var templateRef = MyApp.of(context).themeAssets.careplanTemplateRef;
        ScopedModel.of<CarePlanModel>(context)
            .setUser(keycloakUserId, careplanTemplateRef: templateRef);
        Navigator.of(context).pushReplacementNamed('/home');
      }).catchError((error) {
        Navigator.of(context).pushReplacementNamed('/guestHome');
      });
    } else {
      // clear credentials from browser by calling log out
      MyApp.of(context).auth.mapAppLogout();

      Navigator.of(context).pushReplacementNamed('/guestHome');
    }
  }
}
