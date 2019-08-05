/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

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

  KeycloakAuth() {
    _appAuth = FlutterAppAuth();
  }

  Future mapAppLogin() async {
    try {
      AuthorizationTokenResponse value =
          await _appAuth.authorizeAndExchangeCode(
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
      return Future.value("Logged in");
    } catch (error) {
      return Future.error(error);
    }
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
    return appAuth
        .token(TokenRequest(_clientId, _redirectUrl,
            issuer: _issuer,
            refreshToken: _refreshToken,
            scopes: ['openid', 'profile'],
            clientSecret: _clientSecret))
        .then((TokenResponse value) {
      isLoggedIn = true;
      _accessToken = value.accessToken;
      accessTokenExpirationDateTime = value.accessTokenExpirationDateTime;
      _refreshToken = value.refreshToken;

      return Future.value("Tokens updated successfully.");
    }).catchError((Object error) {
      return Future.error("Token refresh failed: $error");
    });
  }

  Future<Response> getUserInfo() {
    var url =
        'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp/protocol/openid-connect/userinfo';
    return post(url, headers: {
      'Authorization': 'Bearer $_accessToken',
    });
  }
}
