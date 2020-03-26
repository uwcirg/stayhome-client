/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/config/AppConfig.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/platform_stub.dart';

class HelpPage extends StatefulWidget {
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
  }

  void _updateTimeLeft() {
    DateTime tokenExpDate = MyApp.of(context).auth.accessTokenExpirationDateTime;
    if (tokenExpDate != null) {
      setState(() {
        _timeLeftInSeconds = tokenExpDate.difference(new DateTime.now()).inSeconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      child: _buildScreen(context),
      title: "About",
    );
  }

  Widget _buildScreen(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, i) {
        return _buildAboutPageContent(context);
      },
      itemCount: 1,
      shrinkWrap: true,
    ));
  }

  Widget _buildAboutPageContent(BuildContext context) {
    var sectionTitleStyle = Theme.of(context).textTheme.title;
    return Padding(
      padding: const EdgeInsets.all(Dimensions.fullMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "About Joylux",
            style: sectionTitleStyle,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
            child: Container(
              child: Image.asset('assets/photos/Joylux-team.jpg'),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: Dimensions.borderWidth)),
            ),
          ),
          Text(
              "Joylux, Inc., is a global women’s health technology company creating innovative products for pelvic floor wellness.\n\nColette Courtion, founder and CEO, was inspired by her journey into motherhood to create a product that improved the quality of life for women. Partnering with medical professionals and harnessing her expertise in the field of medical aesthetics, Colette started the company in 2014 in the tech hub of Seattle, Washington.\n\nAt Joylux, we take a leadership position in women’s pelvic floor wellness by spearheading meaningful conversations and driving results that make a positive impact. Ultimately, our mission is to empower women to live their best lives."),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
            child: Text(
              "About CIRG",
              style: sectionTitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Text(S.of(context).developedByCIRG),
          Text(""),
          Text(S.of(context).versionString("0.0")),
          Text(""),
          Text(S.of(context).time_left_until_token_expiration('$_timeLeftInSeconds')),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}

class StayHomeHelpPage extends HelpPage {
  @override
  State createState() {
    return new _StayHomeHelpPageState();
  }
}

class _StayHomeHelpPageState extends _HelpPageState {
  @override
  Widget _buildAboutPageContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.fullMargin),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SectionTitle("About StayHome"),
            Text(
                "The COVID-19 pandemic is straining existing public health processes and workflows. Many community members may be concerned about developing COVD-19. To meet this need we have developed StayHome, an app to help people who are staying home to minimize any risk they might present to others do things like track their symptoms and temperature, connect with relevant information and resources, and maintain a diary of people with whom they have had contact. We hope the app might also help people and public health connect more easily, when needed, in a situation where public health resources may be stretched thin."),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
              child: OutlineButton(
                  onPressed: () => PlatformDefs().launchUrl(WhatInfo.link, newTab: true),
                  child: Text("Read More")),
            ),
            SectionTitle("About CIRG"),
            Text(S.of(context).developedByCIRG),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
              child: OutlineButton(
                  onPressed: () => PlatformDefs().launchUrl(WhatInfo.cirgLink, newTab: true),
                  child: Text("Read More")),
            ),
            Text(""),
            Text(S.of(context).versionString(AppConfig.version)),
          ]),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    var sectionTitleStyle = Theme.of(context).textTheme.title;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.fullMargin,top:Dimensions.largeMargin),
      child: Text(
        text,
        style: sectionTitleStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
