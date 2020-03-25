/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:map_app_flutter/MapAppDrawer.dart';
import 'package:map_app_flutter/config/AppConfig.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class MapAppPageScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showDrawer;
  final bool showStandardAppBarActions;

  final Color backgroundColor;

  final List<Widget> actions;

  MapAppPageScaffold(
      {Key key,
      this.child,
      this.title,
      this.showDrawer = true,
      this.backgroundColor,
      this.actions,
      this.showStandardAppBarActions = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var actions = getActions(context);

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: MyApp.of(context).appAssets.appBarTitle(),
          actions: actions,
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
          Divider(
            indent: 80,
            endIndent: 80,
          )
        ],
      ),
    );
  }

  List<Widget> getActions(BuildContext context) {
    List<Widget> actions = this.actions;
    if (showStandardAppBarActions) {
      actions = <Widget>[
        MyApp.of(context).auth.isLoggedIn && ModalRoute.of(context).settings.name != '/home' ?
          IconButton(
            icon: Icon(MdiIcons.home),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ) : Container(),
        ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
          return IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              model.load();
            },
          );
        }),
        IconButton(
          icon: Icon(MdiIcons.logout),
          onPressed: () {
            MyApp.of(context).logout(context:context);
          },
        )
      ];
    }
    return actions;
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
