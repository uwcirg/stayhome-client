/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppDrawer.dart';
import 'package:map_app_flutter/config/AppConfig.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';

class MapAppPageScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showDrawer;

  final Color backgroundColor;

  final List<Widget> actions;

  MapAppPageScaffold(
      {Key key, this.child, this.title, this.showDrawer = true, this.backgroundColor, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: MyApp.of(context).appAssets.appBarTitle(),
          actions: this.actions,
        ),
        drawer: showDrawer ? MapAppDrawer() : null,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DemoVersionWarningBanner(),
            _pageTitle(context),
            child,
          ],
        ));
  }

  Widget _pageTitle(BuildContext context) {
    if (title == null) {
      return Container(
        height: 0,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(
          top: Dimensions.largeMargin, left: Dimensions.largeMargin, right: Dimensions.largeMargin),
      child: Column(
        children: <Widget>[
          Text(
            title.toLowerCase(),
            style: Theme.of(context).textTheme.title.apply(fontWeightDelta: 1),
            textAlign: TextAlign.center,
          ),
          Divider(indent: 80, endIndent: 80,)
        ],
      ),
    );
  }
}

class DemoVersionWarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: !AppConfig.isProd,
        child: Container(
            padding: const EdgeInsets.all(Dimensions.quarterMargin),
            color: Colors.amber.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    child: Text(
                  S.of(context).demoVersionBannerText(AppConfig.deploymentType),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: Theme.of(context).platform == TargetPlatform.iOS
                      ? TextAlign.center
                      : TextAlign.start,
                )),
              ],
            )));
  }
}
