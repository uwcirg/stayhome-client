/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/generated/i18n.dart';

class ContactCommunityPage extends StatefulWidget {
  @override
  State createState() {
    return new _ContactCommunityPageState();
  }
}

class _ContactCommunityPageState extends State<ContactCommunityPage> {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      title: S.of(context).contact__community,
      child: Column(
        children: [
          Text(
            "CC page",
            style: Theme.of(context).textTheme.display1,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
