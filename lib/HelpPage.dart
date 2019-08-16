/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
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
        MyApp.of(context).auth.accessTokenExpirationDateTime;
    if (tokenExpDate != null) {
      setState(() {
        _timeLeftInSeconds =
            tokenExpDate.difference(new DateTime.now()).inSeconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        title: S.of(context).help, child: buildChild(context));
  }

  Widget buildChild(BuildContext context) {
    var sectionTitleStyle = Theme.of(context).textTheme.subtitle;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "About Joylux",
              style: sectionTitleStyle,
            ),
            Text(
                "Joylux, Inc., is a global women’s health technology company creating innovative products for pelvic floor wellness.\n\nColette Courtion, founder and CEO, was inspired by her journey into motherhood to create a product that improved the quality of life for women. Partnering with medical professionals and harnessing her expertise in the field of medical aesthetics, Colette started the company in 2014 in the tech hub of Seattle, Washington.\n\nAt Joylux, we take a leadership position in women’s pelvic floor wellness by spearheading meaningful conversations and driving results that make a positive impact. Ultimately, our mission is to empower women to live their best lives."),
            Text(""),
            Text(
              "About CIRG",
              style: sectionTitleStyle,
            ),
            Text(S.of(context).developedByCIRG),
            Text(""),
            Text(S.of(context).versionString("0.0")),
            Text(""),
            Text(S
                .of(context)
                .time_left_until_token_expiration('$_timeLeftInSeconds')),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
