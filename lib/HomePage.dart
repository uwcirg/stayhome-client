/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:map_app_flutter/CDCSymptomCheckerInfoPage.dart';
import 'package:map_app_flutter/CommunicationsPage.dart';
import 'package:map_app_flutter/MapAppDrawer.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/ProfilePage.dart';
import 'package:map_app_flutter/QuestionnairePage.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/map_app_widgets.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        title: null,
        child: Expanded(
            child: ListView.builder(
          itemBuilder: (context, i) {
            return new Padding(
              padding: MapAppPadding.pageMargins,
              child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
                Widget errorWidget = MapAppErrorMessage.fromModel(model, context);
                if (errorWidget != null) return errorWidget;

                if (model.isFirstTimeUser) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => CreateProfilePage()));
                  });
                }

                return _buildPage(context, model);
              }),
            );
          },
          itemCount: 1,
          shrinkWrap: true,
        )));
  }

  Widget _buildPage(BuildContext context, CarePlanModel model) {
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
        SpringBoardWidget(model),
      ],
    );
  }
}

class SpringBoardWidget extends StatelessWidget {
  final CarePlanModel model;

  const SpringBoardWidget(this.model);

  @override
  Widget build(BuildContext context) {
    List<SpringboardTile> tiles = _springboardTiles(context);
    List<List<SpringboardTile>> tilesByRow = [];
    for (int i = 0; i < tiles.length; i += 2) {
      tilesByRow.add(tiles.sublist(i, min(i + 2, tiles.length)));
    }
    List<Widget> rows = tilesByRow.map((List<SpringboardTile> e) {
      return IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: e),
      );
    }).toList();

    return Column(children: rows);
  }

  List<SpringboardTile> _springboardTiles(context) {
    return [
      SpringboardTile(
        assetPath: 'assets/stayhome/Track.png',
        text: S.of(context).springboard_record_symptom_text,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuestionnairePage(model.questionnaires[0], model)));
        },
      ),
      SpringboardTile(
        assetPath: 'assets/stayhome/cdc.png',
        text: S.of(context).cdc_symptom_checker,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CDCSymptomCheckerInfoPage()));
        },
      ),
      SpringboardTile(
        assetPath: 'assets/stayhome/Risk.transparent.png',
        text: S.of(context).springboard_enter_travel_exposure_text,
        onPressed: model.questionnaires.length > 1
            ? () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QuestionnairePage(model.questionnaires[1], model)));
              }
            : null,
      ),
      SpringboardTile(
        assetPath: model.questionnaires.length > 2
            ? 'assets/stayhome/Testing.transparent.png'
            : 'assets/stayhome/Testing.gray.png',
        text: S.of(context).springboard_record_COVID19_text,
        onPressed: model.questionnaires.length > 2
            ? () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QuestionnairePage(model.questionnaires[2], model)));
              }
            : null,
      ),
      SpringboardTile(
        assetPath: 'assets/stayhome/Resource.png',
        text: S.of(context).springboard_COVID19_resources_text,
        onPressed: () => launchResourceUrl(model),
      ),
      SpringboardTile(
        assetPath: model.questionnaires.length > 3
        ? 'assets/stayhome/Pregnant.png'
        : 'assets/stayhome/Pregnant.gray.png',
        text: S.of(context).springboard_enter_pregnancy_text,
        onPressed: model.questionnaires.length > 3
            ? () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuestionnairePage(model.questionnaires[3], model)));
        }
            : null,
      ),
      SpringboardTile(
        assetPath: 'assets/stayhome/profile_icon.png',
        text: S.of(context).springboard_update_profile_text,
        onPressed: () => MapAppDrawer.navigate(context, "/profile"),
      ),
      SpringboardTile(
        assetPath: 'assets/stayhome/Trend.png',
        text: S.of(context).springboard_review_calendar_history_text,
        onPressed: () => MapAppDrawer.navigate(context, "/progress_insights"),
      ),
    ];
  }
}

class SpringboardTile extends StatelessWidget {
  final Function onPressed;

  final String assetPath;

  final String text;
  final bool enabled;

  const SpringboardTile({this.onPressed, this.assetPath, this.text}) : enabled = onPressed != null;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Card(
            color: _cardColor(context),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: Dimensions.quarterMargin,
                  bottom: Dimensions.halfMargin,
                  right: Dimensions.halfMargin,
                  left: Dimensions.halfMargin),
              child: Column(
                children: <Widget>[
                  _image(context) ?? Container(),
                  Expanded(
                    child: Center(
                      child: Text(
                        this.text,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: _textStyle(context),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        onTap: this.onPressed,
      ),
    );
  }

  Widget _image(BuildContext context) {
    if (this.assetPath != null) {
      return Image.asset(this.assetPath,
          height: 80, color: enabled ? null : Theme.of(context).disabledColor);
    }
    return null;
  }

  TextStyle _textStyle(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    if (enabled) return textStyle.apply(color: Theme.of(context).primaryColor);
    return textStyle.apply(color: Theme.of(context).disabledColor);
  }

  _cardColor(BuildContext context) {
    if (enabled) return Theme.of(context).accentColor;
    return Colors.grey[300];
  }
}
