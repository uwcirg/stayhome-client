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
import 'package:map_app_flutter/platform_stub.dart';

abstract class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      child: _buildScreen(context),
      title: "About",
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
            SectionTitle("About StayHome"),
            Text(
                "The COVID-19 pandemic is straining existing public health processes and workflows. Many community members may be concerned about developing COVD-19. To meet this need we have developed StayHome, an app to help people who are staying home to minimize any risk they might present to others do things like track their symptoms and temperature, connect with relevant information and resources, and maintain a diary of people with whom they have had contact. We hope the app might also help people and public health connect more easily, when needed, in a situation where public health resources may be stretched thin."),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
              child: OutlineButton(
                  onPressed: () => PlatformDefs().launchUrl(WhatInfo.link, newTab: true),
                  child: Text("Read More")),
            ),
            SectionTitle("About CIRG"),
            Text(S.of(context).developedByCIRG),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
              child: OutlineButton(
                  onPressed: () => PlatformDefs().launchUrl(WhatInfo.cirgLink, newTab: true),
                  child: Text("Read More")),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.fullMargin),
              child: OutlineButton(
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
                            new OutlineButton(
                              //TODO: This crashes (?) on iOS
                              onPressed: () => Clipboard.setData(new ClipboardData(text: terms))
                                  .then((value) => snack("Copied!", context))
                                  .catchError((error) => snack("Copying failed: $e", context)),
                              child: Text('copy to clipboard'),
                            ),
                            new OutlineButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: new Text('done'),
                            ),
                          ],
                        );
                      }),
                  child: Text("Review ${S.of(context).terms_of_use_title}")),
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
