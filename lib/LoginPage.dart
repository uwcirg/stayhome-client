/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app_flutter/config/AppConfig.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/platform_stub.dart';
import 'package:simple_auth_flutter/simple_auth_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  var _deferredPrompt;

  @override
  void initState() {
    super.initState();
    SimpleAuthFlutter.init(context);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    double buttonContainerInsets = deviceInfo.size.width > MediaQueryConstants.minDesktopWidth
        ? deviceInfo.size.width / 4.5
        : 12;

    PlatformDefs().addToHomeScreen((deferredPrompt) {
      setState(() {
        _deferredPrompt = deferredPrompt;
      });
    });

    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyApp.of(context).appAssets.systemUiOverlayStyle,
      child: DecoratedBox(
          position: DecorationPosition.background,
          decoration: MyApp.of(context).appAssets.loginBackgroundDecoration(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildAddToHomeScreenButton(),
                  Expanded(child: MyApp.of(context).appAssets.loginBanner(context)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: buttonContainerInsets),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildSessionExpiredMessage(context),
                        _buildWhatLink(),
                        _buildLoginButton(context),
                        ...MyApp.of(context).appAssets.additionalLoginPageViews(context),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: _buildNotNowButton(context),
                        ),
                        _buildVersionLink(),
                        _buildCommitShaText(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    ));
  }

  Widget _buildAddToHomeScreenButton() {
    return Visibility(
      visible: _deferredPrompt != null,
      child: OutlineButton(
          child: Text("Add to homescreen"),
          onPressed: () {
            if (_deferredPrompt != null) {
              PlatformDefs().onAddToHomeScreenButtonPressed(_deferredPrompt);
            }
          }),
    );
  }

  Widget _buildSessionExpiredMessage(BuildContext context) {
    return Visibility(
      visible: MyApp.of(context).auth.refreshTokenExpired,
      child: Text(S.of(context).session_expired_please_log_in_again),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return RaisedButton(
        color: Colors.white,
        elevation: 0,
        onPressed: () => MyApp.of(context)
            .auth
            .mapAppLogin()
            .then((value) => MyApp.of(context).dismissLoginScreen(context))
            .catchError((error) => snack("$error", context)),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              S.of(context).login,
              style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            )));
  }

  Widget _buildNotNowButton(BuildContext context) {
    return OutlineButton(
        onPressed: () => MyApp.of(context).dismissLoginScreen(context),
        borderSide: BorderSide(color: Colors.white, width: 6),
        highlightElevation: 0,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              S.of(context).not_now,
              style: Theme.of(context).primaryTextTheme.title,
              textAlign: TextAlign.center,
            )));
  }

  Widget _buildVersionLink() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: _buildTextLink(AppConfig.version, WhatInfo.changelogLink),
    );
  }

  Widget _buildCommitShaText() {
    String commitSha = AppConfig.commitSha;
    return Visibility(
        visible: commitSha != null && !AppConfig.isProd,
        child: Text(
          commitSha ?? "",
          style: Theme.of(context).primaryTextTheme.caption,
          textAlign: TextAlign.center,
        ));
  }

  Widget _buildWhatLink() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _buildTextLink(
          MyApp.of(context).appAssets.whatLinkTitle, MyApp.of(context).appAssets.whatLink,
          large: true),
    );
  }

  Widget _buildTextLink(String linkName, String url, {bool large = false}) {
    var style = large
        ? Theme.of(context).primaryTextTheme.headline6
        : Theme.of(context).primaryTextTheme.bodyText1;

    style = style.apply(decoration: TextDecoration.underline);
    return FlatButton(
        onPressed: () => PlatformDefs().launchUrl(url),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
            child: Text(linkName, style: style)));
  }
}
