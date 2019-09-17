/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';
import 'package:map_app_flutter/main.dart';
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
              padding: const EdgeInsets.only(top: Dimensions.largeMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildLinks(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLinks(BuildContext context) {
    return _contactPageContents.links.map((ContactPageItem item) {
      return FlatButton(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: MapAppPadding.buttonIconEdgeInsets,
            child: Icon(item.iconData),
          ),
          Text(item.text),
        ]),
        onPressed: () => _launchURL(item.url, context),
      );
    }).toList();
  }

  List<Widget> _buildButtons(BuildContext context) {
    return _contactPageContents.buttons
        .map((ContactPageItem item) => RaisedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: MapAppPadding.buttonIconEdgeInsets,
                    child: Icon(item.iconData),
                  ),
                  Text(item.text),
                ],
              ),
              onPressed: () => _launchURL(item.url, context),
            ))
        .toList();
  }

  _launchURL(url, context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      snack(
          'Could not launch $url: Make sure you have an app to handle this kind of link.',
          context);
    }
  }
}

class ContactPageContents {
  final List<ContactPageItem> buttons;
  final List<ContactPageItem> links;

  ContactPageContents(this.buttons, this.links);

  static ContactPageContents contents(BuildContext context) {
    return ContactPageContents([
      ContactPageItem(MdiIcons.facebook, S.of(context).visit_our_facebook_page,
          url: "https://www.facebook.com/getvfit"),
      ContactPageItem(MdiIcons.web, S.of(context).read_our_blog,
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
