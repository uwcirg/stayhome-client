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
      child: Expanded(
          child: ListView.builder(
            itemBuilder: (context, i) {
              return new Padding(
                padding: MapAppPadding.pageMargins,
                child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
                  Widget errorWidget = MapAppErrorMessage.fromModel(model, context);
                  if (errorWidget != null) return errorWidget;
                  return _buildPage(context, model);
                }),
              );
            },
            itemCount: 1,
            shrinkWrap: true,
          ))
    );
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
        // TODO: Dynamically add a tile for each questionnaire in the questionnaire list.
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
                assetPath: 'assets/stayhome/Risk.transparent.png',
                text: "enter exposure or travel",
                onPressed: model.questionnaires.length > 1
                    ? () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                QuestionnairePage(model.questionnaires[1], model)));
                      }
                    : null,
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              SpringboardTile(
                assetPath: 'assets/stayhome/Testing.transparent.png',
                text: "record COVID-19 testing",
                onPressed: model.questionnaires.length > 2
                    ? () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          QuestionnairePage(model.questionnaires[2], model)));
                }
                    : null,
              ),
              SpringboardTile(
                assetPath: 'assets/stayhome/profile_icon.png',
                text: "update profile or sharing",
                onPressed: () => MapAppDrawer.navigate(context, "/profile"),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            SpringboardTile(
              assetPath: 'assets/stayhome/Trend.png',
              text: "review calendar & history",
              onPressed: () => MapAppDrawer.navigate(context, "/progress_insights"),
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
    bool enabled = onPressed != null;
    var cardColor = enabled ? Theme.of(context).accentColor : Colors.grey[300];
    var textStyle = Theme.of(context).textTheme.title;
    if (enabled) {
      textStyle = textStyle.apply(color: Theme.of(context).primaryColor);
    } else {
      textStyle = textStyle.apply(color: Theme.of(context).disabledColor);
    }
    return Expanded(
      child: InkWell(
        child: Card(
            color: cardColor,
            child: Padding(
              padding: MapAppPadding.pageMargins,
              child: Column(
                children: <Widget>[
                  Image.asset(this.assetPath,
                      height: 80, color: enabled ? null : Theme.of(context).disabledColor),
                  Text(
                    this.text,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: textStyle,
                  ),
                ],
              ),
            )),
        onTap: this.onPressed,
      ),
    );
  }
}
