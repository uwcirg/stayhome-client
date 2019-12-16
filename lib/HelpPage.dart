/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';
import 'package:map_app_flutter/main.dart';

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
    DateTime tokenExpDate =
        MyApp
            .of(context)
            .auth
            .accessTokenExpirationDateTime;
    if (tokenExpDate != null) {
      setState(() {
        _timeLeftInSeconds =
            tokenExpDate
                .difference(new DateTime.now())
                .inSeconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(child: buildChild(context));
  }

  Widget buildChild(BuildContext context) {
//    return LayoutBuilder(
//        builder: (BuildContext context, BoxConstraints viewportConstraints) {
//      return SingleChildScrollView(
//        padding: EdgeInsets.all(Dimensions.fullMargin),
//        child: ConstrainedBox(
//          constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
//          child: _buildAboutPageContent(context),
//        ),
//      );
//    });
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
    var sectionTitleStyle = Theme
        .of(context)
        .textTheme
        .title;
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
                      color: Theme
                          .of(context)
                          .primaryColor,
                      width: Dimensions.borderWidth)),
            ),
          ),
          Text(
              "Joylux, Inc., is a global women’s health technology company creating innovative products for pelvic floor wellness.\n\nColette Courtion, founder and CEO, was inspired by her journey into motherhood to create a product that improved the quality of life for women. Partnering with medical professionals and harnessing her expertise in the field of medical aesthetics, Colette started the company in 2014 in the tech hub of Seattle, Washington.\n\nAt Joylux, we take a leadership position in women’s pelvic floor wellness by spearheading meaningful conversations and driving results that make a positive impact. Ultimately, our mission is to empower women to live their best lives."),
          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
            child: Text(
              "About CIRG",
              style: sectionTitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Text(S
              .of(context)
              .developedByCIRG),
          Text(""),
          Text(S.of(context).versionString("0.0")),
          Text(""),
          Text(S
              .of(context)
              .time_left_until_token_expiration('$_timeLeftInSeconds')),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}
