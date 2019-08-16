import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:map_app_flutter/ContactCommunityPage.dart';
import 'package:map_app_flutter/DevicesPage.dart';
import 'package:map_app_flutter/HelpPage.dart';
import 'package:map_app_flutter/LearningCenterPage.dart';
import 'package:map_app_flutter/LoginPage.dart';
import 'package:map_app_flutter/PlanPage.dart';
import 'package:map_app_flutter/ProfilePage.dart';
import 'package:map_app_flutter/ProgressInsightsPage.dart';
import 'package:map_app_flutter/color_palette.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'KeycloakAuth.dart';
import 'Model.dart';
import 'generated/i18n.dart';

void main() {
  runApp(MyApp(new LoginPage()));
}

class MyApp extends StatefulWidget {
  Widget _home;

  MyApp(this._home);

  static _MyAppState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_MyAppState>());

  @override
  State<StatefulWidget> createState() {
    return new _MyAppState(_home);
  }
}

class _MyAppState extends State<MyApp> {
  Widget _defaultHome;
  Widget _homePage;
  String _locale = 'en';
  KeycloakAuth auth;
  String title = 'CIRG Map App';

  _MyAppState(Widget home) {
    _homePage = PlanPage();
    auth = KeycloakAuth();

    if (home != null) {
      _defaultHome = home;
    } else {
      _defaultHome = _homePage;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  onChangeLanguage(String languageCode) {
    setState(() {
      _locale = languageCode;
    });
    initializeDateFormatting(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme:
          ThemeData(primarySwatch: Colors.grey, accentColor: MapAppColors.vFitAccent),
      home: _defaultHome,
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => _homePage,
        "/guestHome": (BuildContext context) => LearningCenterPage(),
        "/profile": (BuildContext context) => new ScopedModel<AppModel>(
            model: new AppModel(), child: ProfilePage()),
        "/help": (BuildContext context) => HelpPage(),
        "/devices": (BuildContext context) => DevicesPage(),
        "/contact_community": (BuildContext context) => ContactCommunityPage(),
        "/progress_insights": (BuildContext context) => ProgressInsightsPage(),
        "/learning_center": (BuildContext context) => LearningCenterPage(),
        "/about": (BuildContext context) => HelpPage(),
        "/login": (BuildContext context) => LoginPage()
      },
      locale: Locale(_locale, ""),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback:
          S.delegate.resolution(fallback: new Locale("en", "")),
    );
  }
}



void snack(String text, context) {
  //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
  print(text);
  Toast.show(text, context,
      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
}
