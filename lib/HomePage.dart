/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/CommunicationsPage.dart';
import 'package:map_app_flutter/MapAppDrawer.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/QuestionnairePage.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/map_app_widgets.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      title: "home",
      child: new Padding(
        padding: MapAppPadding.pageMargins,
        child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
//          Widget errorWidget = MapAppErrorMessage.fromModel(model, context);
//          if (errorWidget != null) return errorWidget;
          return _buildPage(context, model);
        }),
      ),
    );
//        Wrap(children: [
//          InkWell(child: Card(child: Text("First"))),
//          InkWell(child: Card(child: Text("Second"))),
//          InkWell(child: Card(child: Text("Third")))
//        ])
//        Expanded(
//            child: ListView.builder(
//              itemBuilder: (context, i) {
//                return _buildScreen(context);
//              },
//              itemCount: 1,
//              shrinkWrap: true,
//            ))
//        );
  }

  Column _buildPage(BuildContext context, CarePlanModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: model.activeCommunications.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.halfMargin),
            child: ActiveNotificationsWidget(model),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SpringboardTile(
                assetPath: 'assets/stayhome/Track.png',
                text: "record symptoms & temp",
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuestionnairePage(model.questionnaires[0], model)));
                },
              ),
              SpringboardTile(
                assetPath: 'assets/stayhome/profile_icon.png',
                text: "update profile or sharing",
                onPressed: () => MapAppDrawer.navigate(context, "/profile"),
              ),
            ],
          ),
        ),
//            Row(
//              children: <Widget>[
//                SpringboardTile(
//                  assetPath: 'assets/stayhome/Testing.png',
//                  text: "record COVID-19 testing",
//                ),
//                SpringboardTile(
//                  assetPath: 'assets/stayhome/Risk.png',
//                  text: "note possible exposure",
//                ),
//              ],
//            ),
        Row(
          children: <Widget>[
            SpringboardTile(
              assetPath: 'assets/stayhome/Trend.png',
              text: "review calendar & history",
              onPressed: () => MapAppDrawer.navigate(context, "/calendar_history"),
            ),
          ],
        ),
      ],
    );
  }
}

class SpringboardTile extends StatelessWidget {
  final Function onPressed;

  final String assetPath;

  final String text;

  const SpringboardTile({this.onPressed, this.assetPath, this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Card(
            color: Theme.of(context).accentColor,
            child: Padding(
              padding: MapAppPadding.pageMargins,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    this.assetPath,
                    height: 80,
                  ),
                  Text(
                    this.text,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .apply(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            )),
        onTap: this.onPressed,
      ),
    );
  }
}
