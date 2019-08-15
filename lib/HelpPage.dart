/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:async';

import 'package:english_words/english_words.dart';
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
    final wordPair = WordPair.random();
    return MapAppPageScaffold(
      title: S.of(context).help,
      child: Column(
        children: [
          Text(
            wordPair.asPascalCase,
            style: Theme.of(context).textTheme.display1,
          ),
          Text(S
              .of(context)
              .time_left_until_token_expiration('$_timeLeftInSeconds')),
          Text(""),
          Text(S.of(context).developedByCIRG),
          Text(""),
          Text(S.of(context).versionString("0.0")),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
