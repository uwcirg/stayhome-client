/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCommunityPage extends StatelessWidget {
  final ContactPageContents _contactPageContents;

  ContactCommunityPage(this._contactPageContents);

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      title: S.of(context).contact__community,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.fullMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildButtons(context),
            ),
            Padding(
              padding: const EdgeInsets.only(top:Dimensions.largeMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildLinks(),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLinks() {
    return _contactPageContents.links
        .map((ContactPageItem item) => FlatButton(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.halfMargin),
                  child: Icon(item.iconData),
                ),
                Text(item.text),
              ]),
              onPressed: () => _launchURL(item.url),
            ))
        .toList();
  }

  List<Widget> _buildButtons(BuildContext context) {
    return _contactPageContents.buttons
        .map((ContactPageItem item) => RaisedButton(
              color: Theme.of(context).accentColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: Dimensions.halfMargin),
                    child: Icon(item.iconData,
                        color: Theme.of(context).accentIconTheme.color),
                  ),
                  Text(
                    item.text,
                    style: Theme.of(context).accentTextTheme.body1,
                  ),
                ],
              ),
              onPressed: () => _launchURL(item.url),
            ))
        .toList();
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ContactPageContents {
  final List<ContactPageItem> buttons;
  final List<ContactPageItem> links;

  ContactPageContents(this.buttons, this.links);

  static ContactPageContents contents() {
    return ContactPageContents([
      ContactPageItem(MdiIcons.facebook, "Visit our Facebook Page",
          url: "https://www.facebook.com/getvfit"),
      ContactPageItem(MdiIcons.web, "Read our Blog",
          url: "https://www.getvfit.com/blogs/news"),
    ], [
      ContactPageItem(MdiIcons.phone, "+1 844-872-8578",
          url: "tel:+1 844-872-8578"),
      ContactPageItem(MdiIcons.email, "customercare@getvfit.com",
          url: "mailto:customercare@getvfit.com"),
    ]);
  }
}

class ContactPageItem {
  final IconData iconData;
  final String text;
  final String url;

  ContactPageItem(this.iconData, this.text, {this.url});
}
