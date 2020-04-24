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
              padding: const EdgeInsets.symmetric(vertical: Dimensions.halfMargin),
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

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.halfMargin),
        child: IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [tiles[0]]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.halfMargin),
        child: IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [tiles[4]]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.halfMargin),
        child: IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [tiles[7]]),
        ),
      ),
      Container(
        height: 140,
        child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: Dimensions.halfMargin),
            itemCount: 4,
            itemBuilder: (BuildContext ctxt, int index) {
              return [tiles[2], tiles[3], tiles[5], tiles[1]]
                  .map((Widget w) => AspectRatio(
                        aspectRatio: 1,
                        child: w,
                      ))
                  .toList()[index];
            },
            scrollDirection: Axis.horizontal),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.halfMargin),
        child: IntrinsicHeight(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [tiles[8], tiles[9], tiles[6], SpringboardTile(
                style: 2,
                text: "logout",
                icon: Icon(Icons.exit_to_app),
                onPressed: () => MapAppDrawer.navigate(context, "/about"),
              )]),
        ),
      )
    ]);
  }

  List<SpringboardTile> _springboardTiles(context) {
    return [
      SpringboardTile(
        style: 0,
        assetPath: 'assets/stayhome/Track.png',
        text: S.of(context).springboard_record_symptom_text,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuestionnairePage(model.questionnaires[0], model)));
        },
      ),
      SpringboardTile(
        style: 0,
        assetPath: 'assets/stayhome/cdc.png',
        text: S.of(context).cdc_symptom_checker,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CDCSymptomCheckerInfoPage()));
        },
      ),
      SpringboardTile(
        style: 0,
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
        style: 0,
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
        style: 1,
        assetPath: 'assets/stayhome/Resource.png',
        text: S.of(context).springboard_COVID19_resources_text,
        onPressed: () => launchResourceUrl(model),
      ),
      SpringboardTile(
        style: 0,
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
        icon: Icon(Icons.account_circle),
        text: "profile",
        onPressed: () => MapAppDrawer.navigate(context, "/profile"),
      ),
      SpringboardTile(
        style: 1,
        assetPath: 'assets/stayhome/Trend.png',
        text: S.of(context).springboard_review_calendar_history_text,
        onPressed: () => MapAppDrawer.navigate(context, "/progress_insights"),
      ),
      SpringboardTile(
        style: 2,
        assetPath: 'assets/stayhome/Trend.png',
        text: "contact",
        icon: Icon(Icons.feedback),
        onPressed: () => MapAppDrawer.navigate(context, "/progress_insights"),
      ),
      SpringboardTile(
        style: 2,
        assetPath: 'assets/stayhome/Trend.png',
        text: "about",
        icon: Icon(Icons.help),
        onPressed: () => MapAppDrawer.navigate(context, "/about"),
      )
    ];
  }
}

class SpringboardTile extends StatelessWidget {
  final Function onPressed;

  final String assetPath;

  final String text;
  final bool enabled;
  final int style;
  final Icon icon;

  const SpringboardTile({this.icon, this.onPressed, this.assetPath, this.text, this.style})
      : enabled = onPressed != null;

  @override
  Widget build(BuildContext context) {
    if (this.style == 0) {
      return style1Tile(context);
    } else if (this.style == 1) {
      return style2Tile(context);
    }
    return style3Tile(context);
  }

  Expanded style1Tile(BuildContext context) {
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

  Expanded style2Tile(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: OutlineButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
          padding: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              _image(context) ?? Container(),
              Expanded(
                child: Text(
                  this.text,
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  style: _textStyle(context),
                ),
              ),
              Icon(Icons.chevron_right)
            ],
          ),
          onPressed: this.onPressed,
        ),
      ),
    );
  }

  Widget style3Tile(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: OutlineButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(4), child: this.icon),
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
          onPressed: this.onPressed,
        ),
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
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    if (enabled) return textStyle.apply(color: Theme.of(context).primaryColor);
    return textStyle.apply(color: Theme.of(context).disabledColor);
  }

  _cardColor(BuildContext context) {
    if (enabled) return Theme.of(context).accentColor;
    return Colors.grey[300];
  }
}
