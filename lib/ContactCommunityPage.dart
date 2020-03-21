/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
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
              children: _buildWeblinks(context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildContactItems(context),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContactItems(BuildContext context) {
    return _contactPageButtons(context,_contactPageContents.links, Theme.of(context).primaryColor);
  }

  List<Widget> _buildWeblinks(BuildContext context) {
    return _contactPageButtons(context,_contactPageContents.buttons, Theme.of(context).accentColor);
  }

  List<Widget> _contactPageButtons(BuildContext context, List<ContactPageItem> items, Color buttonColor) {
    return items.map((ContactPageItem item) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: MapAppPadding.largeButtonPadding,
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Padding(
                padding: MapAppPadding.buttonIconEdgeInsets,
                child: Icon(item.iconData, size: IconSize.large),
              ),
              Flexible(child: Text(item.text, style: Theme.of(context).accentTextTheme.title)),
            ]),
          ),
          onPressed: () => _launchURL(item.url, context),
          color: buttonColor,
        ),
      );
    }).toList();
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
      ContactPageItem(MdiIcons.facebookBox, S.of(context).visit_our_facebook_page,
          url: "https://www.facebook.com/getvfit"),
      ContactPageItem(MdiIcons.bookOpenVariant, S.of(context).read_our_blog,
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
