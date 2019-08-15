/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/generated/i18n.dart';

class ProgressInsightsPage extends StatefulWidget {
  @override
  State createState() {
    return new _ProgressInsightsPageState();
  }
}

class _ProgressInsightsPageState extends State<ProgressInsightsPage> {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      title: S.of(context).progress__insights,
      child: Column(
        children: [
          Text(
            "Progress & Insights page",
            style: Theme.of(context).textTheme.display1,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
