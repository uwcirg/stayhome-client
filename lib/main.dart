import 'dart:async';
import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' show Response, get, post;
import 'package:toast/toast.dart';

import 'KeycloakAuth.dart';
import 'generated/i18n.dart';

void main() {
  Widget home = new LoginPage();
  runApp(MyApp(home));
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

  _MyAppState(Widget home) {
    _homePage = MyHomePage(this.onChangeLanguage, title: 'CIRG Map App');
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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: _defaultHome,
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => _homePage,
        "/profile": (BuildContext context) => ProfilePage(),
        "/help": (BuildContext context) => HelpPage(),
        "/about": (BuildContext context) => AboutPage(),
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

class HelpPage extends StatefulWidget {
  @override
  State createState() {
    return new _HelpPageState();
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).about),
        ),
        body: Column(
          children: <Widget>[
            DemoVersionWarningBanner(),
            Padding(
              padding: const EdgeInsets.all(padding),
              child: Column(
                children: [
                  Text(S.of(context).developedByCIRG),
                  Text(S.of(context).versionString("0.0")),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ],
        ));
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
    DateTime tokenExpDate =
        MyApp.of(context).auth.accessTokenExpirationDateTime;
    if (tokenExpDate != null) {
      setState(() {
        _timeLeftInSeconds =
            tokenExpDate.difference(new DateTime.now()).inSeconds;
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
        body: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  wordPair.asPascalCase,
                  style: Theme.of(context).textTheme.display1,
                ),
                Text(S
                    .of(context)
                    .time_left_until_token_expiration('$_timeLeftInSeconds')),
              ],
            )));
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
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pushReplacementNamed('/home')),
          backgroundColor: Colors.deepPurple.shade300,
          elevation: 0,
        ),
        body: Container(
            color: Colors.deepPurple.shade300,
            alignment: FractionalOffset.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/female.svg",
                  color: Colors.white,
                  height: 200,
                ),
                FlatButton(
                    onPressed: () => MyApp.of(context)
                        .auth
                        .mapAppLogin()
                        .then((value) =>
                            Navigator.of(context).pushReplacementNamed('/home'))
                        .catchError((error) => snack("$error", context)),
                    child: Text(
                      S.of(context).login,
                      style: Theme.of(context).primaryTextTheme.title,
                    ))
              ],
            )));
  }
}

class MyHomePage extends StatefulWidget {
  final void Function(String) onChangeLanguage;

  MyHomePage(this.onChangeLanguage, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(onChangeLanguage);
}

void snack(String text, context) {
  //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
  print(text);
  Toast.show(text, context,
      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
}

const double padding = 24.0;

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final void Function(String) onChangeLanguage;

  bool _updateState = false;

  _MyHomePageState(this.onChangeLanguage);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.help),
              onPressed: () {
                snack("Going to help page.", context);
                Navigator.pushNamed(context, "/help");
              }),
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: MyApp.of(context).auth.isLoggedIn
                  ? () => Navigator.pushNamed(context, "/profile")
                  : null)
        ],
      ),
      drawer: Drawer(
          child: ListView(children: [
        DrawerHeader(
            child: Text(
              "Map App",
              style: Theme.of(context).primaryTextTheme.title,
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor)),
        ListTile(
          title: Text(S.of(context).about),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/about');
          },
        ),
        ListTile(
          title: Text(S.of(context).languageName),
          trailing: DropdownButton(
              items: S.delegate.supportedLocales.map((locale) {
                return new DropdownMenuItem(
                  child: Text(locale.languageCode),
                  value: locale.languageCode,
                );
              }).toList(),
              onChanged: (item) {
                onChangeLanguage(item);
              }),
          leading: Icon(Icons.language),
        )
      ])),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(S.of(context).buttonPushText),
            Text('$_counter',style: Theme.of(context).textTheme.display1),
            RaisedButton(
              onPressed: () {
                if (MyApp.of(context).auth.isLoggedIn) {
                  MyApp.of(context).auth.mapAppLogout()
                      .then((value) => setState(() {
                            _updateState = !_updateState;
                          }));
                } else {
                  MyApp.of(context).auth.mapAppLogin()
                      .then((value) => setState(() {
                            _updateState = !_updateState;
                          }));
                }
              },
              child: MyApp.of(context).auth.isLoggedIn
                  ? Text(S.of(context).logout)
                  : Text(S.of(context).login),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
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
    MyApp.of(context).auth.getUserInfo().then((Response value) {
      if (value.statusCode == 200) {
        setState(() {
          _userInfo = jsonDecode(value.body);
        });
      } else if (value.statusCode == 401) {
        MyApp.of(context).auth.mapAppRefreshTokens().then((value) {
          MyApp.of(context).auth.getUserInfo().then((Response value) {
            if (value.statusCode == 200) {
              setState(() {
                _userInfo = jsonDecode(value.body);
              });
            } else {
              setState(() {
                _error = "Error: ${value.statusCode} ${value.reasonPhrase}";
              });
            }
          }).catchError((error) {
            setState(() {
              _error =
                  "Error getting user info after successfully refreshing tokens: $error";
            });
          });
        }).catchError((error) {
          setState(() {
            _error = "Error refreshing tokens: $error";
          });
        });
      } else {
        setState(() {
          _error = "Error: ${value.statusCode} ${value.reasonPhrase}";
        });
      }
    }).catchError((error) {
      setState(() {
        _error = "Error getting user info: $error";
      });
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
