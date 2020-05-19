/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:map_app_flutter/LoginPage.dart';
import 'package:map_app_flutter/ProgramLandingPage.dart';
import 'package:map_app_flutter/app_assets.dart';
import 'package:map_app_flutter/config/AppConfig.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/fhir_translations.dart';
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
    initializeFhirTranslations(languageCode);

    if (!_carePlanModel.hasNoUser && !_carePlanModel.hasNoPatient) {
      if (_locale != _carePlanModel.patient.language) {
        print("updating preferred language to: $_locale");
        _carePlanModel.updateUserLanguage(_locale);
      }
    }
  }

  void initializeFhirTranslations(String languageCode) {
    FhirTranslations.languageCode = languageCode;
  }

  @override
  void initState() {
    initializeCareplanModel();
    // set default language for FHIR resources with multiple languages
    initializeFhirTranslations("en");
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
                textTheme: ButtonTextTheme.accent,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      // secondary will be the textColor, when the textTheme is set to accent
                      secondary: appAssets.buttonTextColor,
                      primary: appAssets.buttonTextColor,
                    ),
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
          routes: appAssets.navRoutes(context),
          locale: Locale(_locale, ""),
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: this.supportedLocales,
          onGenerateRoute: (settings) {
            // URL param parsing
            var uri = Uri.parse(settings.name);
            print("onGenerateRoute path name: ${uri.path}");
            print("onGenerateRoute queryParams: ${uri.queryParameters}");
            if (uri.path == '/enroll') {
              String program = uri.queryParameters['program'];
              return MaterialPageRoute(
                builder: (context) {
                  return ProgramEnrollmentPage(programSiteName: program);
                },
              );
            }
            return null;
          },
        ));
  }

  List<Locale> get supportedLocales {
    List<Locale> definedLocales = S.delegate.supportedLocales;
    List<String> configuredLocales = AppConfig.supportedLocales;
    return definedLocales
        .where((Locale locale) =>
            configuredLocales.contains(locale.languageCode) ||
            configuredLocales.contains(locale.toString()))
        .toList();
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
      print(
          "Dismiss login screen. Token is not null: ${auth.api.currentOauthAccount?.token != null}");
      completePostLoginSetup(context).then((loggedIn) {
        if (loggedIn) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          Navigator.of(context).pushReplacementNamed('/guestHome');
        }
      });
    } else {
      // clear credentials from browser by calling log out
      logout(pushLogin: false);
      ScopedModel.of<CarePlanModel>(context).setGuestUser(auth);
      Navigator.of(context).pushReplacementNamed('/guestHome');
    }
  }

  Future completeLoginFromCallback(String href, {String redirectUrl}) {
    return auth
        .receivedCallback(href, redirectUrl: redirectUrl)
        .then((value) => completePostLoginSetup(context));
  }

  Future<bool> completePostLoginSetup(BuildContext context) {
    return auth.getUserInfo().then((value) {
      String keycloakUserId = auth.userInfo.keycloakUserId;
      ScopedModel.of<CarePlanModel>(context).setUserAndAuthToken(keycloakUserId, auth);
      return true;
    }).catchError((error) {
      ScopedModel.of<CarePlanModel>(context).setGuestUser(auth);
      return false;
    });
  }

  Future<bool> getLoginStatus() async {
    print("getLoginStatus");
    if (auth.isLoggedIn) {
      print("Dismiss login screen. Token is now: ${auth.api.currentOauthAccount.token != null}");
      return await auth.getUserInfo().then((value) {
        String keycloakUserId = auth.userInfo.keycloakUserId;
        ScopedModel.of<CarePlanModel>(context).setUserAndAuthToken(keycloakUserId, auth);
        return true;
      }).catchError((error) {
        ScopedModel.of<CarePlanModel>(context).setGuestUser(auth);
        return false;
      });
    } else {
      // clear credentials from browser by calling log out
      logout(pushLogin: false);
      ScopedModel.of<CarePlanModel>(context).setGuestUser(auth);
      print("returning Future.value(false)");
      return Future.value(false);
    }
  }

  Future<void> nav(BuildContext context) async {
    print("nav");
    bool loggedIn = await getLoginStatus();
    print("Nav received value: $loggedIn");
    if (loggedIn)
      Navigator.of(context).pushReplacementNamed('/home');
    else
      Navigator.of(context).pushReplacementNamed('/guestHome');
  }

  void checkLanguage() {
    if (_carePlanModel?.patient?.language != null && _carePlanModel.patient.language != _locale) {
      onChangeLanguage(_carePlanModel.patient.language);
    }
  }
}

void snack(String text, context) {
  //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
  print(text);
  Toast.show(text, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
}

void launchResourceUrl(CarePlanModel model) {
  PlatformDefs().launchUrl(WhatInfo.resourceLinkWithZip(model?.patient?.homeZip), newTab: true);
}
