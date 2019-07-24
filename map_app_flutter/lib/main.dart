import 'dart:async';
import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' show Response, get, post;
import 'package:toast/toast.dart';

import 'ProfilePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static _MyAppState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_MyAppState>());

  @override
  State<StatefulWidget> createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String _accessToken;
  DateTime _accessTokenExpirationDateTime;
  bool _isLoggedIn = false;
  String _refreshToken;
  final String _issuer = 'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp';
  final String _redirectUrl = 'edu.washington.cirg.mapapp:/callback';
  final String _clientSecret = 'b284cf4f-17e7-4464-987e-3c320b22cfac';
  final String _clientId = 'map-app-client';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MapAppFlutter',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: MyHomePage(title: 'CIRG Map App'),
        routes: <String, WidgetBuilder>{
          "/profile": (BuildContext context) => ProfilePage(),
          "/help": (BuildContext context) => HelpPage()
        });
  }

  void _mapAppLogin() {
    FlutterAppAuth appAuth = FlutterAppAuth();

    appAuth
        .authorizeAndExchangeCode(
      AuthorizationTokenRequest(_clientId, _redirectUrl,
          issuer: _issuer, scopes: ['openid', 'profile'], clientSecret: _clientSecret, promptValues: ['login']),
    )
        .then((AuthorizationTokenResponse value) {
      snack("Logged in", context);
      setState(() {
        _isLoggedIn = true;
        _accessToken = value.accessToken;
        _accessTokenExpirationDateTime = value.accessTokenExpirationDateTime;
        _refreshToken = value.refreshToken;
      });
    }).catchError((Object error) {
      snack("Login failed", context);
    });
  }

  void _mapAppLogout() {
    var url =
        'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp/protocol/openid-connect/logout?clientId=$_clientId&refresh_token=$_refreshToken&client_secret=$_clientSecret';

    get(url, headers: {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/x-www-form-urlencoded',
    }).then((value) {
      if (value.statusCode == 200) {
        snack("Logged out", context);
        setState(() {
          _isLoggedIn = false;
          _accessToken = null;
          _accessTokenExpirationDateTime = null;
          _refreshToken = null;
        });
      } else {
        snack("Log out not completed: ${value.statusCode}", context);
      }
    }).catchError((error) {
      snack("Log out error: $error", context);
    });
  }

  Future _mapAppRefreshTokens() async {
    FlutterAppAuth appAuth = FlutterAppAuth();
    return appAuth
        .token(TokenRequest(_clientId, _redirectUrl,
            issuer: _issuer, refreshToken: _refreshToken, scopes: ['openid', 'profile'], clientSecret: _clientSecret))
        .then((TokenResponse value) {
      setState(() {
        _isLoggedIn = true;
        _accessToken = value.accessToken;
        _accessTokenExpirationDateTime = value.accessTokenExpirationDateTime;
        _refreshToken = value.refreshToken;
      });
      return Future.value("Tokens updated successfully.");
    }).catchError((Object error) {
      snack("Token refresh failed", context);
      return Future.error(error);
    });
  }
}

class HelpPage extends StatefulWidget {
  @override
  @override
  State createState() {
    return new _HelpPageState();
  }
}

class _HelpPageState extends State<HelpPage> {
  int _timeLeftInSeconds;

  @override
  void initState() {
    super.initState();
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) => _updateTimeLeft());
    snack("Going to help page.", context);
  }

  void _updateTimeLeft() {
    DateTime tokenExpDate = MyApp.of(context)._accessTokenExpirationDateTime;
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
          title: Text('Help'),
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
                Text("Time left until token expiration: $_timeLeftInSeconds seconds")
              ],
            )));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

void snack(String text, context) {
  //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
  print(text);
  Toast.show(text, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
}

double padding = 24.0;

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

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
          IconButton(icon: Icon(Icons.help), onPressed: () => Navigator.pushNamed(context, "/help")),
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: MyApp.of(context)._isLoggedIn ? () => Navigator.pushNamed(context, "/profile") : null)
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
          title: Text("Test menu item"),
        ),
        ListTile(
          title: Text("Another item here"),
        ),
      ])),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            RaisedButton(
              onPressed:
                  MyApp.of(context)._isLoggedIn ? MyApp.of(context)._mapAppLogout : MyApp.of(context)._mapAppLogin,
              child: MyApp.of(context)._isLoggedIn ? Text("Logout") : Text("Login"),
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
    _getUserInfo().then((Response value) {
      if (value.statusCode == 200) {
        setState(() {
          _userInfo = jsonDecode(value.body);
        });
      } else if (value.statusCode == 401) {
        MyApp.of(context)._mapAppRefreshTokens().then((value) {
          _getUserInfo().then((Response value) {
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
              _error = "Error getting user info after successfully refreshing tokens: $error";
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
  }

  @override
  Widget build(BuildContext context) {
    if (_userInfo != null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
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
                  Text("Email: ${_userInfo['email']}"),
                ],
              )));
    }
    if (_error != null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: Padding(
            padding: EdgeInsets.all(padding),
            child: Text(_error),
          ));
    }
    return new Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(child: new CircularProgressIndicator()));
  }

  Future<Response> _getUserInfo() {
    var url = 'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp/protocol/openid-connect/userinfo';
    return post(url, headers: {
      'Authorization': 'Bearer ${MyApp.of(context)._accessToken}',
    });
  }
}
