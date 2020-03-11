/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';
import 'dart:io' show HTTP, HttpClient, HttpClientRequest, HttpClientResponse;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Response, get, post, Client;
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class KeycloakAuth {
  static final String _issuer = 'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp';
  static final String _redirectUrl = 'https://stayhome.cirg.washington.edu/#/home';
  static final String _clientSecret = 'b284cf4f-17e7-4464-987e-3c320b22cfac';
  static final String _clientId = 'map-app-client';
  static final _authorizationEndpoint = Uri.parse('$_issuer/protocol/openid-connect/auth');
  static final _tokenEndpoint = Uri.parse("$_issuer/protocol/openid-connect/token");

  String _accessToken;
  DateTime accessTokenExpirationDateTime;
  bool isLoggedIn = false;
  String _refreshToken;

  KeycloakApi _api;

  UserInfo userInfo;

  bool refreshTokenExpired = false;

  bool isDummyLogin = false;

  KeycloakAuth() {
    _api = new KeycloakApi(_issuer, _clientId, _clientSecret, _redirectUrl,
        scopes: ["openid", "profile"]);
    var grant = oauth2.AuthorizationCodeGrant(_clientId, _authorizationEndpoint, _tokenEndpoint,
        secret: _clientSecret);
  }

  Future mapAppLogin() async {
    try {
      simpleAuth.OAuthAccount account = await _api.authenticate();
      print(account);
      _accessToken = account.token;
      _refreshToken = account.refreshToken;
      accessTokenExpirationDateTime = account.created.add(Duration(seconds: account.expiresIn));

      isLoggedIn = true;
      refreshTokenExpired = false;
    } catch (e) {
      print(e);
    }
  }

  Future dummyLogin() async {
    isDummyLogin = true;
    isLoggedIn = true;
    refreshTokenExpired = false;
  }

  Future mapAppLogout() async {
    if (isDummyLogin) {
      isLoggedIn = false;
      _accessToken = null;
      accessTokenExpirationDateTime = null;
      _refreshToken = null;
      userInfo = null;
      return Future.value("Logged out");
    }

    var url = '$_issuer/protocol/openid-connect/logout';

    try {
      var value = await post(url, headers: {
        "authorization": 'Bearer $_accessToken'
      }, body: {
        "refresh_token": _refreshToken,
        "client_id": _clientId,
        "client_secret": _clientSecret
      });

      if (value.statusCode == 204) {
        isLoggedIn = false;
        _accessToken = null;
        accessTokenExpirationDateTime = null;
        _refreshToken = null;
        userInfo = null;

        // local logout
        try {
          await _api.logOut();
          return Future.value("Logged out");
        } catch (e) {
          return Future.error("Logged out, but local logout failed: $e");
        }
      } else {
        return Future.error("Log out not completed: ${value.statusCode}");
      }
    } catch (error) {
      return Future.error("Log out error: $error");
    }
  }

  Future mapAppRefreshTokens() async {
    if (isDummyLogin) {
      return;
    }

    var success = await _api.refreshAccount(_api.currentAccount);
    if (success) {
      var account = _api.currentOauthAccount;
      _accessToken = account.token;
      _refreshToken = account.refreshToken;
      accessTokenExpirationDateTime = account.created.add(Duration(seconds: account.expiresIn));
    } else {
      return Future.error("Unable to refresh token");
    }
  }

  Future<Response> _getUserInfo() {
    var url = '$_issuer/protocol/openid-connect/userinfo';
    return post(url, headers: {
      'Authorization': 'Bearer $_accessToken',
    });
  }

  Future getUserInfo() async {
    if (isDummyLogin) {
      this.userInfo = UserInfo.from(
          jsonDecode('{"sub":"0df3e0be-bfd0-4602-b180-c3f1bb96b602","email_verified":true,'
              '"name":"Bumblebee Sugartoes","preferred_username":"demo",'
              '"given_name":"Bumblebee","family_name":"Sugartoes",'
              '"email":"bumblebee@sugartoes.net"}'));

      return Future.value(this.userInfo);
    }

    var userInfoJson;
    var returnError;

    try {
      Response value = await _getUserInfo();
      if (value.statusCode == 200) {
        userInfoJson = value.body;
      } else if (value.statusCode == 401) {
        try {
          var value = await mapAppRefreshTokens();
          try {
            var value = await _getUserInfo();

            if (value.statusCode == 200) {
              userInfoJson = value.body;
            } else {
              returnError = "Error: ${value.statusCode} ${value.reasonPhrase}";
            }
          } catch (error) {
            returnError = "Error getting user info after successfully refreshing tokens: $error";
          }
        } catch (error) {
          if (error.code == "token_failed") {
            refreshTokenExpired = true;
            isLoggedIn = false;
            userInfo = null;
          }
          returnError = "Error refreshing tokens: $error";
        }
      } else {
        returnError = "Error: ${value.statusCode} ${value.reasonPhrase}";
      }
    } catch (error) {
      returnError = "Error getting user info: $error";
    }

    if (returnError != null) return Future.error(returnError);
    this.userInfo = UserInfo.from(jsonDecode(userInfoJson));
    return Future.value(this.userInfo);
  }
}

class UserInfo {
  final String keycloakUserId;
  final bool emailVerified;
  final String name;
  final String preferredUsername;
  final String _givenName;
  final String familyName;
  final String email;

  UserInfo(this.keycloakUserId, this.emailVerified, this.name, this.preferredUsername,
      this._givenName, this.familyName, this.email);

  String get givenName {
    return this._givenName != null ? this._givenName : "";
  }

  static UserInfo from(Map userInfoMap) {
    return UserInfo(
        userInfoMap["sub"],
        userInfoMap["email_verified"],
        userInfoMap["name"],
        userInfoMap["preferred_username"],
        userInfoMap["given_name"],
        userInfoMap["family_name"],
        userInfoMap["email"]);
  }
}

class KeycloakApi extends simpleAuth.OAuthApi {
  KeycloakApi(
    String issuer,
    String clientId,
    String clientSecret,
    String redirectUrl, {
    List<String> scopes,
    Client client,
    simpleAuth.AuthStorage authStorage,
  }) : super(
          "keycloak",
          clientId,
          clientSecret,
          "$issuer/protocol/openid-connect/token",
          '$issuer/protocol/openid-connect/auth',
          redirectUrl,
          client: client,
          scopes: scopes,
          authStorage: authStorage,
        );

  @override
  get showAuthenticator {
    if (!kIsWeb) return super.showAuthenticator;
    print("Detected web authentication attempt.");

    return (simpleAuth.WebAuthenticator authenticator) async {
      if (authenticator.redirectUrl == null) {
        authenticator.onError("redirectUrl cannot be null");
        return;
      }
      var initialUrl = await authenticator.getInitialUrl();
      print("InitialUrl: $initialUrl");

      SimpleAuthFlutter.authenticators[authenticator.identifier] = authenticator;

      var grant = new oauth2.AuthorizationCodeGrant(
          identifier, Uri.parse(this.authorizationUrl), Uri.parse(this.tokenUrl),
          secret: this.clientSecret);
      var url = authenticator.redirectUrl;
      print("redirectUrl: $url");
      var auth_url = grant.getAuthorizationUrl(Uri.parse(url));
      print("auth_url: $auth_url");

      _launchURL(initialUrl);

      await new HttpClient().getUrl(auth_url)
          .then((HttpClientRequest request) => request.close(), onError: (error) => print("error1: $error"))
          .then((HttpClientResponse response) {
        print("this is the response");

      }, onError: (error) => print("error2: $error"));

//      var request = await listen


//      String url = await _channel.invokeMethod("showAuthenticator", {
//        "initialUrl": initialUrl.toString(),
//        "identifier": authenticator.identifier,
//        "title": authenticator.title,
//        "allowsCancel": authenticator.allowsCancel.toString(),
//        "redirectUrl": authenticator.redirectUrl,
//        "useEmbeddedBrowser": authenticator.useEmbeddedBrowser.toString()
//      });
//      if (url == "cancel") {
//        authenticator.cancel();
//        return;
//      }
    };
  }
  _launchURL(url) async {
    print("Launching with url_launcher1: $url");
    if (await canLaunch(url)) {
      print("Launching with url_launcher2");

      await launch(url);
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }
}
