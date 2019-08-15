/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:map_app_flutter/DemoVersionWarningBanner.dart';
import 'package:map_app_flutter/MapAppDrawer.dart';
import 'package:map_app_flutter/const.dart';

class MapAppPageScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  MapAppPageScaffold({this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        drawer: MapAppDrawer(),
        body: Column(
          children: <Widget>[
            DemoVersionWarningBanner(),
            Padding(
                padding: const EdgeInsets.all(Dimensions.fullMargin),
                child: child),
          ],
        ));
  }
}
