/*
 * Copyright (c) 2020 CIRG. All rights reserved. 
 */
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/map_app_widgets.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:map_app_flutter/platform_stub.dart';
import 'package:scoped_model/scoped_model.dart';

class CDCSymptomCheckerInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      child: _buildScreen(context),
      showDrawer: false,
      showStandardAppBarActions: false,
      title: S.of(context).cdc_symptom_checker_title_text,
    );
  }

  Widget _buildScreen(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, i) {
        return _buildPageContent(context);
      },
      itemCount: 1,
      shrinkWrap: true,
    ));
  }

  Widget _buildPageContent(BuildContext context) {
    return Padding(
        padding: MapAppPadding.pageMargins,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MarkdownBody(data: S.of(context).cdc_symptom_checker_info_text),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: Dimensions.fullMargin),
                child: Wrap(alignment: WrapAlignment.center, children: <Widget>[
                  _button(context,
                      primary: false, title: S.of(context).back, onPressed: () => Navigator.of(context).pop()),
                  ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
                    return _button(context,
                        title: S.of(context).cdc_symptom_checker_continue_text,
                        onPressed: () => PlatformDefs()
                            .launchUrl(WhatInfo.cdcSymptomSelfCheckerLink, newTab: true));
                  }),
                ]),
              ),
            )
          ],
        ));
  }

  Padding _button(BuildContext context, {String title, Function onPressed, bool primary = true}) {
    const edgeInsets = MapAppPadding.largeButtonPadding;
    var text = Text(title, style: Theme.of(context).textTheme.button);

    Widget button;
    if (primary) {
      button = RaisedButton(padding: edgeInsets, child: text, onPressed: onPressed);
    } else {
      button = SecondaryButton(padding: edgeInsets, child: text, onPressed: onPressed);
    }

    return Padding(
      padding: EdgeInsets.all(Dimensions.halfMargin),
      child: button,
    );
  }
}
