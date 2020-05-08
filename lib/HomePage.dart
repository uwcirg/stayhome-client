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
import 'package:map_app_flutter/platform_stub.dart';
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
    var scrollableItems = [
      _exposureAndTravelTile(context),
      _covidTestingTile(context),
      _pregnancyAndRisksTile(context)
    ];

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.halfMargin),
        child: IntrinsicHeight(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [_symptomsAndTempTile(context),
                _cdcSymptomCheckerTile(context)]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.halfMargin),
        child: IntrinsicHeight(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch, children: [_resourcesTile(context)]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.halfMargin),
        child: IntrinsicHeight(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [_historyAndTrendsTile(context)]),
        ),
      ),
      Container(
        height: 155,
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.halfMargin),
            itemCount: scrollableItems.length,
            itemBuilder: (BuildContext context, int index) {
              return scrollableItems[index];
            },
            scrollDirection: Axis.horizontal),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.halfMargin),
        child: IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _contactTile(context),
            _aboutTile(context),
            _profileTile(context),
            _logoutTile(context)
          ]),
        ),
      )
    ]);
  }

  SpringboardTile _logoutTile(BuildContext context) {
    return SpringboardTile(
      style: SpringboardTileStyle.Empty,
      text: S.of(context).logout_small,
      icon: Icon(Icons.exit_to_app),
      onPressed: () => MyApp.of(context).logout(context: context),
    );
  }

  SpringboardTile _aboutTile(context) {
    return SpringboardTile(
      style: SpringboardTileStyle.Empty,
      assetPath: 'assets/stayhome/Trend.png',
      text: S.of(context).about_small,
      icon: Icon(Icons.help),
      onPressed: () => MapAppDrawer.navigate(context, "/about"),
    );
  }

  SpringboardTile _contactTile(context) {
    return SpringboardTile(
      style: SpringboardTileStyle.Empty,
      text: S.of(context).contact_small,
      icon: Icon(Icons.feedback),
      onPressed: () => PlatformDefs().launchUrl(WhatInfo.contactLink, newTab: true),
    );
  }

  SpringboardTile _historyAndTrendsTile(context) {
    return SpringboardTile(
      style: SpringboardTileStyle.EmptyWithChevron,
      assetPath: 'assets/stayhome/Trend.png',
      text: S.of(context).springboard_review_calendar_history_text,
      onPressed: () => MapAppDrawer.navigate(context, "/progress_insights"),
    );
  }

  SpringboardTile _profileTile(context) {
    return SpringboardTile(
      assetPath: 'assets/stayhome/profile_icon.png',
      icon: Icon(Icons.account_circle),
      text: S.of(context).profile_small,
      onPressed: () => MapAppDrawer.navigate(context, "/profile"),
    );
  }

  SpringboardTile _pregnancyAndRisksTile(context) {
    return SpringboardTile(
      square: true,
      style: SpringboardTileStyle.Opaque,
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
    );
  }

  SpringboardTile _resourcesTile(context) {
    return SpringboardTile(
      style: SpringboardTileStyle.EmptyWithChevron,
      assetPath: 'assets/stayhome/Resource.png',
      text: S.of(context).springboard_COVID19_resources_text,
      onPressed: () => launchResourceUrl(model),
    );
  }

  SpringboardTile _covidTestingTile(context) {
    return SpringboardTile(
      square: true,
      style: SpringboardTileStyle.Opaque,
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
    );
  }

  SpringboardTile _exposureAndTravelTile(context) {
    return SpringboardTile(
      square: true,
      style: SpringboardTileStyle.Opaque,
      assetPath: 'assets/stayhome/Risk.transparent.png',
      text: S.of(context).springboard_enter_travel_exposure_text,
      onPressed: model.questionnaires.length > 1
          ? () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QuestionnairePage(model.questionnaires[1], model)));
            }
          : null,
    );
  }

  SpringboardTile _cdcSymptomCheckerTile(context) {
    return SpringboardTile(
      square: true,
      style: SpringboardTileStyle.Empty,
      assetPath: 'assets/stayhome/cdc.png',
      text: S.of(context).cdc_symptom_checker,
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CDCSymptomCheckerInfoPage()));
      },
    );
  }

  SpringboardTile _symptomsAndTempTile(context) {
    return SpringboardTile(
      flex:2,
      style: SpringboardTileStyle.Opaque,
      assetPath: 'assets/stayhome/Track.png',
      text: S.of(context).springboard_record_symptom_text,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QuestionnairePage(model.questionnaires[0], model)));
      },
    );
  }
}

enum SpringboardTileStyle { Opaque, EmptyWithChevron, Empty }

class SpringboardTile extends StatelessWidget {
  final Function onPressed;

  final String assetPath;
  final bool square;
  final String text;
  final bool enabled;
  final SpringboardTileStyle style;
  final Icon icon;
  final int flex;

  const SpringboardTile(
      {this.flex=1, this.square = false, this.icon, this.onPressed, this.assetPath, this.text, this.style})
      : enabled = onPressed != null;

  @override
  Widget build(BuildContext context) {
    if (this.style == SpringboardTileStyle.Opaque) {
      return _opaqueTile(context);
    } else if (this.style == SpringboardTileStyle.EmptyWithChevron) {
      return _emptyTileWithLeftIconAndChevron(context);
    }
    return _littleEmptyTile(context);
  }

  Widget _opaqueTile(BuildContext context) {
    var card = Card(
        color: _cardColor(context),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              _image(context) ?? Container(),
              Flexible(
                child: Center(
                  child: Text(
                    this.text,
                    textAlign: TextAlign.center,
                    style: _textStyle(context),
                  ),
                ),
              ),
            ],
          ),
        ));
    var child = this.square ? AspectRatio(aspectRatio: 1, child: card) : card;

    if (this.square) {
      return InkWell(child: child, onTap:this.onPressed);
    } else {
      return Expanded(
        child: InkWell(
          child: child,
          onTap: this.onPressed,
        ),
      );
    }
  }

  Expanded _emptyTileWithLeftIconAndChevron(BuildContext context) {
    return _emptyTile(
        context,
        Row(
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
        ));
  }

  Widget _littleEmptyTile(BuildContext context) {
    return _emptyTile(
        context,
        Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(4), child: this.icon ?? _image(context)),
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
        ));
  }

  Widget _emptyTile(BuildContext context, Widget child) {
    return Expanded(
      flex: this.flex,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SecondaryButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          padding: EdgeInsets.all(5),
          child: child,
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
