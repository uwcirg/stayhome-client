/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' show Response, get, post;

class KeycloakAuth {
  String _accessToken;
  DateTime accessTokenExpirationDateTime;
  bool isLoggedIn = false;
  String _refreshToken;
  final String _issuer =
      'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp';
  final String _redirectUrl = 'edu.washington.cirg.mapapp:/callback';
  final String _clientSecret = 'b284cf4f-17e7-4464-987e-3c320b22cfac';
  final String _clientId = 'map-app-client';

  FlutterAppAuth _appAuth;

  UserInfo userInfo;

  bool refreshTokenExpired = false;

  KeycloakAuth() {
    _appAuth = FlutterAppAuth();
  }

  Future mapAppLogin() async {
    AuthorizationTokenResponse value = await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(_clientId, _redirectUrl,
          issuer: _issuer,
          scopes: ['openid', 'profile'],
          clientSecret: _clientSecret,
          promptValues: ['login']),
    );


    isLoggedIn = true;
    _accessToken = value.accessToken;
    accessTokenExpirationDateTime = value.accessTokenExpirationDateTime;
    _refreshToken = value.refreshToken;
    refreshTokenExpired = false;
  }

  Future mapAppLogout() async {
    var url =
        'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp/protocol/openid-connect/logout?clientId=$_clientId&refresh_token=$_refreshToken&client_secret=$_clientSecret';

    try {
      var value = await get(url, headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      });

      if (value.statusCode == 200) {
        isLoggedIn = false;
        _accessToken = null;
        accessTokenExpirationDateTime = null;
        _refreshToken = null;
        userInfo = null;
        return Future.value("Logged out");
      } else {
        return Future.error("Log out not completed: ${value.statusCode}");
      }
    } catch (error) {
      return Future.error("Log out error: $error");
    }
  }

  Future mapAppRefreshTokens() async {
    FlutterAppAuth appAuth = FlutterAppAuth();
    TokenResponse value = await appAuth.token(TokenRequest(
        _clientId, _redirectUrl,
        issuer: _issuer,
        refreshToken: _refreshToken,
        scopes: ['openid', 'profile'],
        clientSecret: _clientSecret));

    isLoggedIn = true;
    _accessToken = value.accessToken;
    accessTokenExpirationDateTime = value.accessTokenExpirationDateTime;
    _refreshToken = value.refreshToken;
  }

  Future<Response> _getUserInfo() {
    var url =
        'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp/protocol/openid-connect/userinfo';
    return post(url, headers: {
      'Authorization': 'Bearer $_accessToken',
    });
  }

  Future getUserInfo() async {
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
            returnError =
                "Error getting user info after successfully refreshing tokens: $error";
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
  final String sub;
  final bool emailVerified;
  final String name;
  final String preferredUsername;
  final String givenName;
  final String familyName;
  final String email;

  String patientResourceID = "23";

  UserInfo(this.sub, this.emailVerified, this.name, this.preferredUsername,
      this.givenName, this.familyName, this.email);

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
