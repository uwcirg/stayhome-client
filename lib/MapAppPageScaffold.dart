/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:map_app_flutter/DemoVersionWarningBanner.dart';
import 'package:map_app_flutter/MapAppDrawer.dart';

class MapAppPageScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showDrawer;

  final Color backgroundColor;

  final List<Widget> actions;

  MapAppPageScaffold(
      {Key key,
      this.child,
      this.title,
      this.showDrawer = true,
      this.backgroundColor,
      this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(title),
          actions: this.actions,
        ),
        drawer: showDrawer ? MapAppDrawer() : null,
        body: Column(
          children: <Widget>[
            DemoVersionWarningBanner(),
            child,
          ],
        ));
  }
}
