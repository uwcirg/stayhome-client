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
  final Widget appBarBottom;

  // tabbed
  final int length;
  final List<Tab> tabs;
  final List<Widget> tabViews;
  final List<String> tabPageTitles;

  final Color backgroundColor;

  final List<Widget> actions;

  MapAppPageScaffold._(
      {Key key,
      this.child,
      this.title,
      this.showDrawer = true,
      this.backgroundColor,
      this.actions,
      this.showStandardAppBarActions = true,
      this.appBarBottom,
      this.length,
      this.tabs,
      this.tabViews,
      this.tabPageTitles})
      : super(key: key);

  MapAppPageScaffold(
      {Key key,
      child,
      title,
      showDrawer = true,
      backgroundColor,
      actions,
      showStandardAppBarActions = true})
      : this._(
            key: key,
            child: child,
            title: title,
            showDrawer: showDrawer,
            backgroundColor: backgroundColor,
            actions: actions,
            showStandardAppBarActions: showStandardAppBarActions);

  @override
  Widget build(BuildContext context) {
    var actions = getActions(context);

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: MyApp.of(context).appAssets.appBarTitle(),
          actions: actions,
          bottom: appBarBottom,
        ),
        drawer: showDrawer ? MapAppDrawer() : null,
        body: tabViews == null ? _body(context) : _tabbedBody(context));
  }

  Widget _body(BuildContext context) {
    return _withDemoVersionBannerAndPageTitle(child, this.title, context);
  }

  Widget _tabbedBody(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < tabViews.length; i++) {
      children.add(_withDemoVersionBannerAndPageTitle(tabViews[i], tabPageTitles[i], context));
    }
    return TabBarView(
      children: children,
    );
  }

  MapAppPageScaffold.tabbed(
      {showDrawer = true,
      backgroundColor,
      actions,
      showStandardAppBarActions = true,
      @required List<Tab> tabs,
      @required List<Widget> tabViews,
      List<String> tabPageTitles})
      : this._(
            showDrawer: showDrawer,
            backgroundColor: backgroundColor,
            actions: actions,
            showStandardAppBarActions: showStandardAppBarActions,
            appBarBottom: TabBar(tabs: tabs),
            tabViews: tabViews,
            tabPageTitles: tabPageTitles);

  /// wrap the given widget with demo version banner on top
  Widget _withDemoVersionBannerAndPageTitle(Widget w, String title, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DemoVersionWarningBanner(),
        pageTitle(title, context),
        w,
      ],
    );
  }

  Widget pageTitle(String title, BuildContext context) {
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
            title,
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
        MyApp.of(context).auth.isLoggedIn && ModalRoute.of(context).settings.name != '/home'
            ? IconButton(
                icon: Icon(MdiIcons.home),
                onPressed: () {
                  MapAppDrawer.navigate(context, '/home');
                },
              )
            : Container(),
        ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
          return IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              model.load();
            },
          );
        }),
        // IconButton(
        //   icon: Icon(MdiIcons.logout),
        //   onPressed: () {
        //     MyApp.of(context).logout(context:context);
        //   },
        // )
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
