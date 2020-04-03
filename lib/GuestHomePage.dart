/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

class GuestHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      child: _buildScreen(context),
      title: S.of(context).welcome,
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
            MarkdownBody(data: S.of(context).guest_home_text),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: Dimensions.fullMargin),
                child: Wrap(children: <Widget>[
                  _button(context,
                      title: "back to login/register",
                      onPressed: () => MyApp.of(context).logout(context: context)),
                  ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
                    return _button(context,
                        title: "continue to resources", onPressed: () => launchResourceUrl(model));
                  }),
                ]),
              ),
            )
          ],
        ));
  }

  Padding _button(BuildContext context, {String title, Function onPressed}) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.halfMargin),
      child: RaisedButton(
          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
          child: Text(title, style: Theme.of(context).textTheme.button),
          onPressed: onPressed),
    );
  }
}
