/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Response, post, Client;
import 'package:map_app_flutter/platform_stub.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';

class KeycloakAuth {
  String _issuer;
  String _clientSecret;
  String _clientId;
  static final String _defaultRedirectUrl = PlatformDefs().redirectUrl();
  DateTime accessTokenExpirationDateTime;
  bool isLoggedIn = false;
  String site;

  KeycloakApi _api;

  UserInfo userInfo;

  bool refreshTokenExpired = false;

  final String keycloakKey = "keycloak";

  KeycloakAuth(this._issuer, this._clientSecret, this._clientId) {
    if (kIsWeb) {
      _setInitialLoginState();
      _api = new KeycloakApi(_issuer, _clientId, _clientSecret, _defaultRedirectUrl,
          scopes: ["openid"], authStorage: MapAppWebAuthStorage());
    } else {
      _api = new KeycloakApi(_issuer, _clientId, _clientSecret, _defaultRedirectUrl,
          scopes: ["openid"]);
    }
  }

  factory KeycloakAuth.from(KeycloakAuth other) {
    return KeycloakAuth(other._issuer, other._clientSecret, other._clientId);
  }

  simpleAuth.OAuthApi get api => _api;

  String authToken() {
    return _api.currentOauthAccount.token;
  }

  void resetRedirectUrl() {
    _api.authenticator.redirectUrl = _defaultRedirectUrl;
  }

  void setRedirectUrlForSite(String site) {
    var redirectUrl = PlatformDefs().redirectUrl(site: site);
    print("Redirect URL with site: $redirectUrl");
    _api.authenticator.redirectUrl = redirectUrl;
  }

  Future mapAppLogin({String site}) async {
    if (site != null) {
      setRedirectUrlForSite(site);
    }
    try {
      simpleAuth.OAuthAccount account = await _api.authenticate();
      accessTokenExpirationDateTime = account.created.add(Duration(seconds: account.expiresIn));

      isLoggedIn = true;
      refreshTokenExpired = false;
    } catch (e) {
      print(e);
      return Future.error('Authentication canceled');
    }
  }

  Future mapAppLogout() async {
    var url;
    if (kIsWeb) {
      String redirectUrl = Uri.encodeComponent(PlatformDefs().rootUrl());
      url = "$_issuer/protocol/openid-connect/logout?redirect_uri=$redirectUrl";
    } else {
      url = "$_issuer/protocol/openid-connect/logout";
    }

    try {
      simpleAuth.OAuthAccount account = _api.currentOauthAccount;
      if (account == null) {
        // lost account...
        return await _completeWithLocalLogout();
      } else {
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
          //for Web platform, launching the logout url directly after local logout to clear Keycloak session if encounter error?
          _completeWebLogout(url);
          return Future.error("Log out not completed: ${value.statusCode}");
        }
      }
    } catch (error) {
      //for Web platform, launching the logout url directly after local logout to clear Keycloak session if encounter error?
      _completeWebLogout(url);
      return Future.error("Log out error: $error");
    }
  }

  _completeWebLogout(url) {
    if (kIsWeb) {
      _clearWebLocalStorage();
      PlatformDefs().launchUrl(url);
    }
  }

  _completeWithLocalLogout() async {
    isLoggedIn = false;
    accessTokenExpirationDateTime = null;
    userInfo = null;
    _clearWebLocalStorage();
    try {
      await _api.logOut();
      return Future.value("Logged out");
    } catch (e) {
      return Future.error("Logged out, but local logout failed: $e");
    }
  }

  _clearWebLocalStorage() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(keycloakKey);
    }
  }

  _setInitialLoginState() async {
    /*
     * has authentication information stored in localstorage
     */
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString(keycloakKey) != null) {
        isLoggedIn = true;
      }
    }
  }

  Future mapAppRefreshTokens() async {
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
      _clearWebLocalStorage();
      return Future.error("Error getting user info. Please log in again.");
    }
    return post(url, headers: {
      'Authorization': 'Bearer ${_api.currentOauthAccount.token}',
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
    print("Change: $change");
    if (change.contains("canceled")) {
      authenticator.cancel();
      return Future.error("Authentication canceled");
    } else if (change.contains("error")) {
      authenticator.onError("Error: $change");
      return Future.error("Authentication canceled");
    }

    Uri uri = Uri.tryParse(change);
    print("Uri: $uri");

    if (authenticator.checkUrl(uri)) {
      // --- copy pasted sections - need cleanup!
      // from API code
      var token = await authenticator.getAuthCode();
      print("Token: $token");
      if (token?.isEmpty ?? true) {
        throw new Exception("Null Token");
      }
      simpleAuth.OAuthAccount account = await _api.getAccountFromAuthCode(authenticator);
      _api.saveAccountToCache(account);
      _api.currentAccount = account;
      print("Oauth account updated and token non-null: ${_api.currentOauthAccount.token!=null}");

      //from KeycloakAuth mapAppLogin callback
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
  final String preferredUsername;
  final String email;

  UserInfo(this.keycloakUserId, this.emailVerified, this.preferredUsername, this.email);

  static UserInfo from(Map userInfoMap) {
    return UserInfo(userInfoMap["sub"], userInfoMap["email_verified"],
        userInfoMap["preferred_username"], userInfoMap["email"]);
  }
}

class MapAppWebAuthStorage implements simpleAuth.AuthStorage {
  @override
  Future<String> read({String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> write({String key, String value}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}

class NoneConverter implements simpleAuth.Converter {
  @override
  Future<simpleAuth.Response> decode(
      simpleAuth.Response response, Type responseType, bool responseIsList) {
    return Future.value(response);
  }

  @override
  Future<simpleAuth.Request> encode(simpleAuth.Request request) {
    return Future.value(request);
  }
}

class KeycloakApi extends simpleAuth.OAuthApi {
  KeycloakApi(
    String issuer,
    String clientId,
    String clientSecret,
    String defaultRedirectUrl, {
    List<String> scopes,
    Client client,
    simpleAuth.AuthStorage authStorage,
  }) : super(
          "keycloak",
          clientId,
          clientSecret,
          "$issuer/protocol/openid-connect/token",
          '$issuer/protocol/openid-connect/auth',
          defaultRedirectUrl,
          client: client,
          scopes: scopes,
          authStorage: authStorage,
          converter: NoneConverter(),
        );

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

      SimpleAuthFlutter.authenticators[authenticator.identifier] = authenticator;

      await PlatformDefs().launchUrl(initialUrl.toString());
    };
  }
}
