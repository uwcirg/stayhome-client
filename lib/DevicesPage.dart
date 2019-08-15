/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/generated/i18n.dart';

class DevicesPage extends StatefulWidget {
  @override
  State createState() {
    return new _DevicesPageState();
  }
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      title: S.of(context).devices,
      child: Column(
        children: [
          Text(
            "Devices page",
            style: Theme.of(context).textTheme.display1,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
