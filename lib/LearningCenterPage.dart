/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/generated/i18n.dart';

class LearningCenterPage extends StatefulWidget {
  @override
  State createState() {
    return new _LearningCenterPageState();
  }
}

class _LearningCenterPageState extends State<LearningCenterPage> {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      title: S.of(context).learning_center,
      child: Column(
        children: [
          Text(
            "Learning center page",
            style: Theme.of(context).textTheme.display1,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
