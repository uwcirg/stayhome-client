/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppDrawer.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';

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
          title: Image.asset(
            'assets/logos/Joylux_wdmk_rev_rgb.png',
            height: 25,
          ),
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
      child: Text(
        title,
        style: Theme.of(context).textTheme.title.apply(fontWeightDelta: 1),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class DemoVersionWarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: !Foundation.kReleaseMode,
        child: Container(
            padding: const EdgeInsets.all(Dimensions.quarterMargin),
            color: Colors.amber.shade100,
            child: Row(
              mainAxisAlignment: Theme.of(context).platform == TargetPlatform.iOS
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    child: Text(
                  S.of(context).demoVersionBannerText,
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
