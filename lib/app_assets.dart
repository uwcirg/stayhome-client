/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app_flutter/CommunicationsPage.dart';
import 'package:map_app_flutter/GuestHomePage.dart';
import 'package:map_app_flutter/HelpPage.dart';
import 'package:map_app_flutter/HomePage.dart';
import 'package:map_app_flutter/LoginPage.dart';
import 'package:map_app_flutter/ProfilePage.dart';
import 'package:map_app_flutter/ProgressInsightsPage.dart';
import 'package:map_app_flutter/color_palette.dart';
import 'package:map_app_flutter/config/AppConfig.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:map_app_flutter/platform_stub.dart';

abstract class AppAssets {
  final primarySwatch;
  final accentColor;
  final highlightColor;
  final completedCalendarItemColor;
  final loginBackgroundImagePath;
  final systemUiOverlayStyle;
  final textTheme;
  final careplanTemplateRef;

  String get appName;

  String get whatLinkTitle;

  String get whatLink;

  get issuer;

  get clientSecret;

  get clientId;

  get keycloakIdentifierSystemName => issuer;

  AppAssets(
      this.primarySwatch, this.accentColor, this.highlightColor, this.completedCalendarItemColor,
      {this.loginBackgroundImagePath,
      this.systemUiOverlayStyle = SystemUiOverlayStyle.light,
      this.textTheme,
      this.careplanTemplateRef});

  TextTheme textThemeOverride(TextTheme textTheme) {
    return textTheme;
  }

  Widget topLogos(BuildContext context);
  Widget loginBanner(BuildContext context);

  Widget drawerBanner(BuildContext context);

  List<Widget> additionalLoginPageViews(BuildContext context);

  Widget appBarTitle();

  Map<String, WidgetBuilder> navRoutes(BuildContext context);

  List<MenuItem> navItems(BuildContext context);

  loginBackgroundDecoration() {}

  String learningCenterPageTitle(BuildContext context);
}

class StayHomeAppAssets extends AppAssets {
  get issuer => AppConfig.issuerUrl;

  get clientSecret => AppConfig.clientSecret;

  get clientId => AppConfig.clientId;

  @override
  String get appName => "StayHome";

  @override
  String get whatLinkTitle => "What’s StayHome?";

  @override
  String get whatLink => WhatInfo.link;

  StayHomeAppAssets()
      : super(MapAppColors.stayHomePrimary, MapAppColors.stayHomeAccent,
            MapAppColors.stayHomeHighlight, MapAppColors.stayHomePrimary,
            careplanTemplateRef: "CarePlan/${AppConfig.careplanTemplateId}");

  @override
  Widget topLogos(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildCirgLogo(), _buildUWLogo()]);
  }

  @override
  Widget loginBanner(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildAppLogo(),
        _buildAppName(context),
        _buildSlogan(context),
      ],
    );
  }

  Widget _buildUWLogo() {
    return Padding(
        padding: EdgeInsets.only(
          left: Dimensions.fullMargin,
          top: Dimensions.fullMargin,
          right: Dimensions.fullMargin,
        ),
        child: Image.asset(
          'assets/stayhome/Signature_Stacked_White.png',
          height: 48,
        ));
  }

  Widget _buildSlogan(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: Dimensions.quarterMargin, right: Dimensions.quarterMargin, top: 10),
      child: Text(S.of(context).support_COVID19,
          style: Theme.of(context).primaryTextTheme.headline5.apply(color: Colors.white)),
    );
  }

  Widget _buildAppName(BuildContext context) {
    return Text(
      this.appName,
      style: Theme.of(context)
          .primaryTextTheme
          .headline2
          .apply(color: Colors.white, fontWeightDelta: 2),
    );
  }

  Widget _buildCirgLogo() {
    return Padding(
        padding: EdgeInsets.only(
            top: Dimensions.fullMargin, left: Dimensions.fullMargin, right: Dimensions.fullMargin),
        child: InkWell(
          onTap: () => PlatformDefs().launchUrl(WhatInfo.cirgLink, newTab: true),
          child: Image.asset(
            'assets/stayhome/CIRG_logo_white.png',
            height: 48,
          ),
        ));
  }

  Widget _buildAppLogo() {
    return Padding(
        padding: EdgeInsets.only(
            left: Dimensions.quarterMargin, right: Dimensions.quarterMargin, bottom: 12),
        child: Image.asset(
          'assets/stayhome/icon_white.png',
          height: 70,
        ));
  }

  TextTheme textThemeOverride(TextTheme textTheme) {
    return textTheme.copyWith(
        button: textTheme.subhead.apply(color: this.primarySwatch, fontWeightDelta: 2));
  }

  @override
  Widget drawerBanner(BuildContext context) {
    return Center(
        child: Text(
      this.appName,
      style: Theme.of(context).primaryTextTheme.headline6.apply(fontWeightDelta: 2),
    ));
  }

  @override
  Widget appBarTitle() {
    return Text(this.appName);
  }

  @override
  List<Widget> additionalLoginPageViews(BuildContext context) {
    return [];
  }

  @override
  loginBackgroundDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [primarySwatch, Color(0xFF5835BD)],
            stops: [0.0, 0.7],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter));
  }

  @override
  List<MenuItem> navItems(BuildContext context) {
    return [
      MenuItem(
        requiresLogin: true,
        title: S.of(context).home,
        icon: Icon(Icons.home),
        route: '/home',
      ),
      MenuItem(
        requiresLogin: true,
        title: S.of(context).calender_history,
        icon: Icon(Icons.show_chart),
        route: '/progress_insights',
      ),
      MenuItem(
        requiresLogin: true,
        title: S.of(context).communications,
        icon: Icon(Icons.chat_bubble),
        route: '/communications',
      ),
      MenuItem(
        title: learningCenterPageTitle(context),
        icon: Icon(Icons.lightbulb_outline),
        onPress: (context, model) => launchResourceUrl(model),
      ),
      MenuItem(
        title: S.of(context).about,
        icon: Icon(Icons.help),
        route: '/about',
      )
    ];
  }

  @override
  Map<String, WidgetBuilder> navRoutes(BuildContext context) {
    return <String, WidgetBuilder>{
      "/home": (BuildContext context) => HomePage(),
      "/guestHome": (BuildContext context) => new GuestHomePage(),
      "/profile": (BuildContext context) => ProfilePage(),
      "/progress_insights": (BuildContext context) => StayHomeTrendsPage(),
      "/about": (BuildContext context) => StayHomeHelpPage(),
      "/login": (BuildContext context) => LoginPage(),
      "/authCallback": (BuildContext context) => PlatformDefs().getAuthCallbackPage(),
      "/communications": (BuildContext context) => CommunicationsPage(),
    };
  }

  @override
  String learningCenterPageTitle(BuildContext context) {
    return S.of(context).info_resource;
  }
}

class MenuItem {
  final String title;
  final String loggedOutTitle;
  final Widget icon;
  final String route;
  final bool requiresLogin;
  final Function(BuildContext, CarePlanModel) onPress;

  MenuItem(
      {this.title = "Undefined",
      this.icon,
      this.route = "/home",
      this.requiresLogin = false,
      this.onPress,
      this.loggedOutTitle});
}
