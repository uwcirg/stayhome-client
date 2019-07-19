import 'dart:async';
import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' show Response, get, post;
import 'package:toast/toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
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
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isLoggedIn = false;
  String _accessToken;
  DateTime _accessTokenExpirationDateTime;
  String _refreshToken;
  int _timeLeftInSeconds;

  double padding = 24.0;
  final String _clientId = 'map-app-client';

  final String _issuer =
      'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp';
  final String _redirectUrl = 'edu.washington.cirg.mapapp:/callback';

  final String _clientSecret = 'b284cf4f-17e7-4464-987e-3c320b22cfac';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _updateTimeLeft() {
    setState(() {
      _timeLeftInSeconds = _accessTokenExpirationDateTime
          .difference(new DateTime.now())
          .inSeconds;
    });
  }

  @override
  void initState() {
    super.initState();
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) => _updateTimeLeft());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.help), onPressed: _goToHelp),
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () => _isLoggedIn ? _goToProfile(context) : null)
        ],
      ),
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
              onPressed: _isLoggedIn ? _mapAppLogout : _mapAppLogin,
              child: _isLoggedIn ? Text("Logout") : Text("Login"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _goToHelp() {
    snack("Going to help page.");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
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
                      Text(
                          "Time left until token expiration: ${_timeLeftInSeconds} seconds")
                    ],
                  )));
        },
      ),
    );
  }

  void _mapAppLogin() {
    FlutterAppAuth appAuth = FlutterAppAuth();

    appAuth
        .authorizeAndExchangeCode(
      AuthorizationTokenRequest(_clientId, _redirectUrl,
          issuer: _issuer,
          scopes: ['openid', 'profile'],
          clientSecret: _clientSecret,
          promptValues: ['login']),
    )
        .then((AuthorizationTokenResponse value) {
      snack("Logged in");
      setState(() {
        _isLoggedIn = true;
        _accessToken = value.accessToken;
        _accessTokenExpirationDateTime = value.accessTokenExpirationDateTime;
        _refreshToken = value.refreshToken;
      });
    }).catchError((Object error) {
      snack("Login failed");
    });
  }

  Future _mapAppRefreshTokens() async {
    FlutterAppAuth appAuth = FlutterAppAuth();
    return appAuth
        .token(TokenRequest(_clientId, _redirectUrl,
            issuer: _issuer,
            refreshToken: _refreshToken,
            scopes: ['openid', 'profile'],
            clientSecret: _clientSecret))
        .then((TokenResponse value) {
      setState(() {
        _isLoggedIn = true;
        _accessToken = value.accessToken;
        _accessTokenExpirationDateTime = value.accessTokenExpirationDateTime;
        _refreshToken = value.refreshToken;
      });
      return Future.value("Tokens updated successfully.");
    }).catchError((Object error) {
      snack("Token refresh failed");
      return Future.error(error);
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
        snack("Logged out");
        setState(() {
          _isLoggedIn = false;
          _accessToken = null;
          _accessTokenExpirationDateTime = null;
          _refreshToken = null;
        });
      } else {
        snack("Log out not completed: ${value.statusCode}");
      }
    }).catchError((error) {
      snack("Log out error: $error");
    });
  }

  Future<Response> _getUserInfo() {
    var url =
        'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp/protocol/openid-connect/userinfo';
    return post(url, headers: {
      'Authorization': 'Bearer $_accessToken',
    });
  }

  void snack(String text) {
    //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
    print(text);
    Toast.show(text, context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  void _goToProfile(context) {
    _getUserInfo().then((Response value) {
      if (value.statusCode == 200) {
        displayUserProfilePage(value, context);
      } else if (value.statusCode == 401) {
        _mapAppRefreshTokens().then((value) {
          _getUserInfo().then((Response value) {
            if (value.statusCode == 200) {
              displayUserProfilePage(value, context);
            } else {
              snack("Error: ${value.statusCode} ${value.reasonPhrase}");
            }
          }).catchError((error) {
            snack(
                "Error getting user info after successfully refreshing tokens: $error");
          });
        }).catchError((error) {
          snack("Error refreshing tokens: $error");
        });
      } else {
        snack("Error: ${value.statusCode} ${value.reasonPhrase}");
      }
    }).catchError((error) {
      snack("Error getting user info: $error");
    });
  }

  void displayUserProfilePage(Response value, context) {
    var userInfo = jsonDecode(value.body);
    snack("User info loaded");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
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
                        "${userInfo['name']}",
                        style: Theme.of(context).textTheme.display1,
                      ),
                      Text("Email: ${userInfo['email']}"),
                    ],
                  )));
        },
      ),
    );
  }

  Future<Response> webServiceCall(
      Future<Response> Function() serviceCallFunction) async {
    return serviceCallFunction().then((value) {
      if (value.statusCode == 401) {
        return _mapAppRefreshTokens().then((value) {
          // token refreshed successfully - return Future for service call
          return serviceCallFunction();
        });
      }
    });
  }
}
