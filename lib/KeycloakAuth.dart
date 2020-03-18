/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Response, post, Client;
import 'package:map_app_flutter/platform_stub.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';

class KeycloakAuth {
  String _issuer;
  String _clientSecret;
  String _clientId;
  static final String _redirectUrl = PlatformDefs().redirectUrl();

  DateTime accessTokenExpirationDateTime;
  bool isLoggedIn = false;

  KeycloakApi _api;

  UserInfo userInfo;

  bool refreshTokenExpired = false;

  bool isDummyLogin = false;

  KeycloakAuth(this._issuer, this._clientSecret, this._clientId) {
    _api = new KeycloakApi(_issuer, _clientId, _clientSecret, _redirectUrl, scopes: ["openid"]);
  }

  factory KeycloakAuth.from(KeycloakAuth other) {
    return KeycloakAuth(other._issuer, other._clientSecret, other._clientId);
  }

  Future mapAppLogin() async {
    try {
      simpleAuth.OAuthAccount account = await _api.authenticate();
      print("Account has been returned mapAppLogin");
      accessTokenExpirationDateTime = account.created.add(Duration(seconds: account.expiresIn));

      isLoggedIn = true;
      refreshTokenExpired = false;
    } catch (e) {
      print(e);
      return Future.error('Authentication canceled');
    }
  }

  Future dummyLogin() async {
    isDummyLogin = true;
    isLoggedIn = true;
    refreshTokenExpired = false;
  }

  Future mapAppCreateAccount(String firstName, String lastName, String email,
      {String userName}) async {
    var url = '$_issuer/users';
    if (userName == null) {
      userName = email;
    }
    try {
      var value = await post(url, body: {
        "origin": "MapApp",
        "username": userName,
        "firstName": firstName,
        "lastName": lastName,
        "email": email
      });
    } catch (error) {
      print(error);
      return Future.error("Error creating user: $error");
    }
  }

  Future mapAppLogout() async {
    if (isDummyLogin) {
      isLoggedIn = false;
      accessTokenExpirationDateTime = null;
      userInfo = null;
      return Future.value("Logged out");
    }
    String redirectUrl = Uri.encodeComponent(PlatformDefs().rootUrl());
    var url = "$_issuer/protocol/openid-connect/logout";

    try {
      simpleAuth.OAuthAccount account = _api.currentOauthAccount;
      if (account == null) {
        // lost account...
        return await _completeWithLocalLogout();
      } else {
        print("Account token: ${account.token}");
        print("Account refresh token: ${account.refreshToken}");
        var value = await post(url, headers: {
          "authorization": 'Bearer ${account.token}'
        }, body: {
          "refresh_token": '${account.refreshToken}',
          "client_id": _clientId,
          "client_secret": _clientSecret
        });

        if (value.statusCode == 204) {
          return await _completeWithLocalLogout();
        } else {
          return Future.error("Log out not completed: ${value.statusCode}");
        }
      }
    } catch (error) {
      return Future.error("Log out error: $error");
    }
  }

  _completeWithLocalLogout() async {
    isLoggedIn = false;
    accessTokenExpirationDateTime = null;
    userInfo = null;
    try {
      await _api.logOut();
      return Future.value("Logged out");
    } catch (e) {
      return Future.error("Logged out, but local logout failed: $e");
    }
  }

  Future mapAppRefreshTokens() async {
    if (isDummyLogin) {
      return;
    }

    var success = await _api.refreshAccount(_api.currentAccount);
    if (success) {
      var account = _api.currentOauthAccount;
      accessTokenExpirationDateTime = account.created.add(Duration(seconds: account.expiresIn));
    } else {
      return Future.error("Unable to refresh token");
    }
  }

  Future<Response> _getUserInfo() {
    var url = '$_issuer/protocol/openid-connect/userinfo';
    if (_api == null ||
        _api.currentOauthAccount == null ||
        _api.currentOauthAccount.token == null) {
      print("_api.currentOauthAccount.token not set");
      print(StackTrace.current);
      return Future.error("Error getting user info. Please log in again.");
    }
    return post(url, headers: {
      'Authorization': 'Bearer ${_api.currentOauthAccount.token}',
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
//          var value = await mapAppRefreshTokens();
          await _api.refreshAccount(_api.currentAccount);
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

  Future receivedCallback(String change) async {
    var authenticator = _api.authenticator;
//    var authenticator = SimpleAuthFlutter.authenticators[_api.authenticator.identifier];
    if (change == "canceled") {
      authenticator.cancel();
      return;
    } else if (change == "error") {
      authenticator.onError("Error: $change");
      return;
    }

    Uri uri = Uri.tryParse(change);
    print("The URI was: $uri\n it contained code: ${uri.queryParameters.containsKey("code")}");

    if (authenticator.checkUrl(uri)) {
      // --- copy pasted sections - need cleanup!
      // from API code
      var token = await authenticator.getAuthCode();
      print("Token: $token");
      if (token?.isEmpty ?? true) {
        throw new Exception("Null Token");
      }
      simpleAuth.OAuthAccount account = await _api.getAccountFromAuthCode(authenticator);
      print("account received: $account");
      _api.saveAccountToCache(account);
      _api.currentAccount = account;

      //from KeycloakAuth mapAppLogin callback
      print("Account has been returned receivedCallback");
      accessTokenExpirationDateTime = account.created.add(Duration(seconds: account.expiresIn));

      isLoggedIn = true;
      refreshTokenExpired = false;

      return;
    } else {
      authenticator.onError("Unable to get an AuthToken from the server");
    }
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
  Future<simpleAuth.OAuthAccount> getAccountFromAuthCode(
      simpleAuth.WebAuthenticator authenticator) async {
    //TODO: Figure out why how to fix callback URL getting mangled
//    authenticator.redirectUrl = "http://localhost:61615/#/authCallback";
    return super.getAccountFromAuthCode(authenticator);
  }

  @override
  get showAuthenticator {
    if (!kIsWeb) return super.showAuthenticator;

    return (simpleAuth.WebAuthenticator authenticator) async {
      print("Detected web authentication attempt.");
      if (authenticator.redirectUrl == null) {
        authenticator.onError("redirectUrl cannot be null");
        return;
      }
      Uri initialUrl = await authenticator.getInitialUrl();
      print("InitialUrl: $initialUrl");

      SimpleAuthFlutter.authenticators[authenticator.identifier] = authenticator;

      await PlatformDefs().launchUrl(initialUrl.toString());
    };
  }
}
