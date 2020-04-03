/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:map_app_flutter/LoginPage.dart';
import 'package:map_app_flutter/app_assets.dart';
import 'package:map_app_flutter/config/AppConfig.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:map_app_flutter/platform_stub.dart';
import 'package:map_app_flutter/services/Repository.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'KeycloakAuth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.init("app_settings.yaml");
  print("Version: ${AppConfig.version}");
  Repository.init(AppConfig.fhirBaseUrl);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();

  static _MyAppState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_MyAppState>());

  @override
  State<StatefulWidget> createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String _locale = 'en';
  KeycloakAuth auth;
  String title = 'StayHome.app';
  CarePlanModel _carePlanModel;

  // Theme can be changed on a code level here
  AppAssets appAssets;

  _MyAppState() {
    appAssets = StayHomeAppAssets();
    auth = KeycloakAuth(appAssets.issuer, appAssets.clientSecret, appAssets.clientId);
  }

  onChangeLanguage(String languageCode) {
    setState(() {
      _locale = languageCode;
    });
    S.load(Locale(_locale, ""));
    initializeDateFormatting(languageCode);
  }

  @override
  void initState() {
    initializeCareplanModel();
    super.initState();
  }

  @override
  void dispose() {
    _carePlanModel = null;
    super.dispose();
  }

  void initializeCareplanModel() {
    _carePlanModel =
        new CarePlanModel(appAssets.careplanTemplateRef, appAssets.keycloakIdentifierSystemName);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CarePlanModel>(
        model: _carePlanModel,
        child: MaterialApp(
          title: title,
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: appAssets.primarySwatch,
              accentColor: appAssets.accentColor,
              highlightColor: appAssets.highlightColor,
              textTheme: appAssets.textThemeOverride(Theme.of(context).textTheme),
              buttonTheme: ButtonThemeData(
                buttonColor: appAssets.accentColor,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                ),
              ),
              chipTheme: ChipTheme.of(context).copyWith(
                  selectedColor: appAssets.accentColor,
                  secondarySelectedColor: appAssets.accentColor,
                  labelStyle: Theme.of(context).textTheme.body1,
                  secondaryLabelStyle: Theme.of(context).accentTextTheme.body1),
              dividerTheme: DividerThemeData(thickness: 1)),
          home: new LoginPage(),
          // Will replace after login is complete
          routes: appAssets.navRoutes(context),
          locale: Locale(_locale, ""),
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
        ));
  }

  toggleAppMode() {
    if (appAssets is StayHomeAppAssets) {
      setState(() {
        // could toggle to a different AppAssets implementation here.
        appAssets = StayHomeAppAssets();
      });
    } else {
      setState(() {
        appAssets = StayHomeAppAssets();
      });
    }
  }

  /// provide context in order to go back to login back after logout is complete
  logout({bool pushLogin = true, BuildContext context}) {
    BuildContext c = context ?? this.context;
    auth.mapAppLogout().then((value) {
      logoutCompleted();
      if (pushLogin) Navigator.of(c).pushReplacementNamed("/login");
    }).catchError((error) => print("Logout error: $error"));
  }

  void logoutCompleted() {
    initializeCareplanModel();
    auth = new KeycloakAuth.from(auth);
  }

  void dismissLoginScreen(BuildContext context) {
    if (auth.isLoggedIn) {
      auth.getUserInfo().then((value) {
        String keycloakUserId = auth.userInfo.keycloakUserId;
        ScopedModel.of<CarePlanModel>(context).setUserAndAuthToken(keycloakUserId, auth);
        Navigator.of(context).pushReplacementNamed('/home');
      }).catchError((error) {
        ScopedModel.of<CarePlanModel>(context).setGuestUser(auth);
        Navigator.of(context).pushReplacementNamed('/guestHome');
      });
    } else {
      // clear credentials from browser by calling log out
      logout(pushLogin: false);
      ScopedModel.of<CarePlanModel>(context).setGuestUser(auth);
      Navigator.of(context).pushReplacementNamed('/guestHome');
    }
  }
}

void snack(String text, context) {
  //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
  print(text);
  Toast.show(text, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
}

void launchResourceUrl(CarePlanModel model) {
  PlatformDefs().launchUrl(WhatInfo.resourceLinkWithZip(model?.patient?.homeZip), newTab: true, targetBlank: true);
}
