/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/config/AppConfig.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/map_app_widgets.dart';
import 'package:map_app_flutter/platform_stub.dart';

abstract class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      child: _buildScreen(context),
      title: S.of(context).about,
    );
  }

  Widget _buildScreen(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, i) {
        return _buildAboutPageContent(context);
      },
      itemCount: 1,
      shrinkWrap: true,
    ));
  }

  Widget _buildAboutPageContent(BuildContext context);
}

class StayHomeHelpPage extends HelpPage {
  @override
  Widget _buildAboutPageContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.fullMargin),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SectionTitle(S.of(context).about_stayhome),
            Text(S.of(context).about_stayhome_info_text),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
              child: SecondaryButton(
                  onPressed: () => PlatformDefs().launchUrl(WhatInfo.link, newTab: true),
                  child: Text(S.of(context).read_more)),
            ),
            SectionTitle(S.of(context).about_CIRG),
            Text(S.of(context).developedByCIRG),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
              child: SecondaryButton(
                  onPressed: () => PlatformDefs().launchUrl(WhatInfo.cirgLink, newTab: true),
                  child: Text(S.of(context).read_more)),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
              child: SecondaryButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        var terms = S.of(context).terms_of_use;
                        return new AlertDialog(
                          title: new Text(S.of(context).terms_of_use_title),
                          content: SingleChildScrollView(child: Text(terms)),
                          actionsPadding: EdgeInsets.only(
                              right: Dimensions.halfMargin,
                              bottom: Dimensions.halfMargin,
                              left: Dimensions.halfMargin),
                          actions: <Widget>[
                            new SecondaryButton(
                              //TODO: This crashes (?) on iOS
                              onPressed: () => Clipboard.setData(new ClipboardData(text: terms))
                                  .then((value) => snack(S.of(context).copied, context))
                                  .catchError((error) => snack("Copying failed: $e", context)),
                              child: Text(S.of(context).copy_to_clipboard),
                            ),
                            new SecondaryButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: new Text(S.of(context).done),
                            ),
                          ],
                        );
                      }),
                  child: Text("${S.of(context).review_terms_of_use_title}")),
            ),
            Text(S.of(context).versionString(AppConfig.version)),
          ]),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    var sectionTitleStyle = Theme.of(context).textTheme.title;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.fullMargin, top: Dimensions.largeMargin),
      child: Text(
        text,
        style: sectionTitleStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
