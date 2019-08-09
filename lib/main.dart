import 'dart:async';
import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' show Response, get, post;
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toast/toast.dart';

import 'KeycloakAuth.dart';
import 'Model.dart';
import 'color_palette.dart';
import 'generated/i18n.dart';

void main() {
  Widget home = new LoginPage();
  runApp(MyApp(home));
}

class MyApp extends StatefulWidget {
  Widget _home;

  MyApp(this._home);

  static _MyAppState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_MyAppState>());

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

  _MyAppState(Widget home) {
    _homePage = PlanPage(this.onChangeLanguage, title: 'CIRG Map App');
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapAppFlutter',
      theme: ThemeData(primarySwatch: Colors.grey, accentColor: Colors.redAccent),
      home: _defaultHome,
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => _homePage,
        "/profile": (BuildContext context) => new ScopedModel<AppModel>(model: new AppModel(), child: ProfilePage()),
        "/help": (BuildContext context) => HelpPage(),
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
      localeResolutionCallback: S.delegate.resolution(fallback: new Locale("en", "")),
    );
  }
}

class HelpPage extends StatefulWidget {
  @override
  State createState() {
    return new _HelpPageState();
  }
}

class DemoVersionWarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: !Foundation.kReleaseMode,
        child: Container(
            color: Colors.amber.shade100,
            alignment: FractionalOffset.center,
            child: Text(S.of(context).demoVersionBannerText)));
  }
}

class _HelpPageState extends State<HelpPage> {
  int _timeLeftInSeconds;

  @override
  void initState() {
    super.initState();
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) => _updateTimeLeft());
  }

  void _updateTimeLeft() {
    DateTime tokenExpDate = MyApp.of(context).auth.accessTokenExpirationDateTime;
    if (tokenExpDate != null) {
      setState(() {
        _timeLeftInSeconds = tokenExpDate.difference(new DateTime.now()).inSeconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).help),
        ),
        body: Column(
          children: <Widget>[
            DemoVersionWarningBanner(),
            Padding(
              padding: const EdgeInsets.all(padding),
              child: Column(
                children: [
                  Text(
                    wordPair.asPascalCase,
                    style: Theme.of(context).textTheme.display1,
                  ),
                  Text(S.of(context).time_left_until_token_expiration('$_timeLeftInSeconds')),
                  Text(""),
                  Text(S.of(context).developedByCIRG),
                  Text(""),
                  Text(S.of(context).versionString("0.0")),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ],
        ));
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading:
              IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.of(context).pushReplacementNamed('/home')),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
            color: Colors.white,
            alignment: FractionalOffset.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Visibility(
                  visible: MyApp.of(context).auth.refreshTokenExpired,
                  child: Text("Session expired, please log in again."),
                ),
                Image.asset('assets/vfit.png'),
                FlatButton(
                    onPressed: () => MyApp.of(context)
                        .auth
                        .mapAppLogin()
                        .then((value) => Navigator.of(context).pushReplacementNamed('/home'))
                        .catchError((error) => snack("$error", context)),
                    child: Padding(
                        padding: EdgeInsets.all(padding),
                        child: Text(
                          S.of(context).login,
                          style: Theme.of(context).primaryTextTheme.title,
                        ))),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.all(padding),
                        child: Image.asset('assets/JOYLUX-Black.jpg', height: 48))
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                )
              ],
            )));
  }
}

class PlanPage extends StatefulWidget {
  final void Function(String) onChangeLanguage;

  PlanPage(this.onChangeLanguage, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PlanPageState createState() => _PlanPageState(onChangeLanguage);
}

void snack(String text, context) {
  //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
  print(text);
  Toast.show(text, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
}

const double padding = 24.0;

class _PlanPageState extends State<PlanPage> {
  int _counter = 0;
  final void Function(String) onChangeLanguage;
  CalendarController _calendarController;

  bool _updateState = false;

  _PlanPageState(this.onChangeLanguage);

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.caption;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: MyApp.of(context).auth.isLoggedIn ? () => Navigator.pushNamed(context, "/profile") : null)
        ],
      ),
      drawer: Drawer(
          child: ListView(padding: const EdgeInsets.all(0.0), children: [
        DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: Theme.of(context).primaryIconTheme.color,
                    size: 64,
                  ),
                  onPressed: () {
                    if (MyApp.of(context).auth.isLoggedIn) {
                      Navigator.of(context).pushNamed("/profile");
                    } else {
                      Navigator.of(context).pushNamed("/login");
                    }
                  },
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Text(
                    "Map App",
                    style: Theme.of(context).primaryTextTheme.title,
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Theme.of(context).primaryIconTheme.color),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                  )
                ])
              ],
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor)),
        ListTile(
          title: Text("Plan"),
          leading: Icon(Icons.calendar_today),
        ),
        ListTile(
          title: Text("Progress & Insights"),
          leading: Icon(Icons.healing),
        ),
        ListTile(
          title: Text("Devices"),
          leading: Icon(Icons.bluetooth),
        ),
        ListTile(
          title: Text("Learning Center"),
          leading: Icon(Icons.lightbulb_outline),
        ),
        ListTile(
          title: Text("Contact & Community"),
          leading: Icon(Icons.chat),
        ),
        Divider(),
        ListTile(
          title: Text(S.of(context).about),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/about');
          },
          trailing: Icon(Icons.info),
        ),
        ListTile(
          title: DropdownButton(
            underline: Container(
              height: 0,
            ),
            items: S.delegate.supportedLocales.map((locale) {
              return new DropdownMenuItem<String>(
                child: Text(locale.languageCode),
                value: locale.languageCode,
              );
            }).toList(),
            onChanged: (item) {
              onChangeLanguage(item);
            },
            hint: Text(S.of(context).languageName,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.subtitle.fontSize,
                    color: Theme.of(context).textTheme.subtitle.color)),
          ),
          trailing: Icon(Icons.language),
        )
      ])),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(calendarStyle: CalendarStyle(weekendStyle: textStyle, weekdayStyle: textStyle, todayStyle: TextStyle(color: Colors.black), selectedColor: Theme.of(context).accentColor, todayColor: Theme.of(context).primaryColor, outsideDaysVisible: false),
              calendarController: _calendarController,
              events: { DateTime(2019, 8, 9): ['Event A'] },
            ),

            RaisedButton(
              onPressed: () {
                if (MyApp.of(context).auth.isLoggedIn) {
                  MyApp.of(context).auth.mapAppLogout().then((value) {
                    setState(() {
                      _updateState = !_updateState;
                    });
                    Navigator.of(context).pushNamed("/login");
                  });
                } else {
                  MyApp.of(context).auth.mapAppLogin().then((value) => setState(() {
                        _updateState = !_updateState;
                      }));
                }
              },
              child: MyApp.of(context).auth.isLoggedIn ? Text(S.of(context).logout) : Text(S.of(context).login),
            )
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _userInfo;
  var _error;

  @override
  void initState() {
    MyApp.of(context).auth.getUserInfo().then((value) {
      setState(() {
        _userInfo = value;
      });
    }).catchError((error) {
      setState(() {
        _error = "Error getting user info: $error";
      });
      if (MyApp.of(context).auth.refreshTokenExpired) {
        Navigator.of(context).popUntil(ModalRoute.withName("/home"));
        Navigator.of(context).pushNamed("/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_userInfo != null) {
      return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).profile),
          ),
          body: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${_userInfo['name']}",
                    style: Theme.of(context).textTheme.display1,
                  ),
                  Text(S.of(context).email(_userInfo['email'])),
                  Text(
                    "Couchbase",
                    style: Theme.of(context).textTheme.display1,
                  ),
                  ScopedModelDescendant<AppModel>(
                    builder: (context, child, model) =>
                        Text("Couchbase object content: ${model.docExample.getString("click")}"),
                    rebuildOnChange: true,
                  )
                ],
              )));
    }
    if (_error != null) {
      return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).profile),
          ),
          body: Padding(
            padding: EdgeInsets.all(padding),
            child: Text(_error),
          ));
    }
    return new Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).profile),
        ),
        body: Center(child: new CircularProgressIndicator()));
  }
}
