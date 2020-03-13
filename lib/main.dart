import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:map_app_flutter/LoginPage.dart';
import 'package:map_app_flutter/ThemeAssets.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'KeycloakAuth.dart';

void main() {
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
  ThemeAssets themeAssets;

  _MyAppState() {
//    if (!kIsWeb) {
    auth = KeycloakAuth();
//    }
    themeAssets = StayHomeThemeAssets();
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
    _carePlanModel = new CarePlanModel();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CarePlanModel>(
        model: _carePlanModel,
        child: MaterialApp(
          title: title,
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: themeAssets.primarySwatch,
              accentColor: themeAssets.accentColor,
              highlightColor: themeAssets.highlightColor,
              textTheme: themeAssets.textThemeOverride(Theme.of(context).textTheme),
              buttonTheme: ButtonThemeData(
                  buttonColor: themeAssets.accentColor,
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0),
                  ),
              ),
              chipTheme: ChipTheme.of(context).copyWith(
                  selectedColor: themeAssets.accentColor,
                  secondarySelectedColor: themeAssets.accentColor,
                  labelStyle: Theme.of(context).textTheme.body1,
                  secondaryLabelStyle: Theme.of(context).accentTextTheme.body1),
              dividerTheme: DividerThemeData(thickness: 1)),
          home: new LoginPage(),
          // Will replace after login is complete
          routes: themeAssets.navRoutes(context),
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
    if (themeAssets is JoyluxThemeAssets) {
      setState(() {
        themeAssets = StayHomeThemeAssets();
      });
    } else {
      setState(() {
        themeAssets = JoyluxThemeAssets();
      });
    }
  }

  /// provide context in order to go back to login back after logout is complete
  logout({BuildContext context}) {
    auth.mapAppLogout().then((value) {
      logoutCompleted();
      if (context != null) Navigator.of(context).pushReplacementNamed("/login");
    });
  }

  void logoutCompleted() {
    initializeCareplanModel();
    auth = new KeycloakAuth();
  }
}

void snack(String text, context) {
  //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
  print(text);
  Toast.show(text, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
}
