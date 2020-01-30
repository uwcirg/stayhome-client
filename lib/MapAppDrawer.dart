/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MapAppDrawer extends Drawer {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Drawer(
          child: ListView(padding: const EdgeInsets.all(0.0), children: [
        Container(
          child: DrawerHeader(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/logos/Joylux_wdmk_blk_rgb.png',
                    height: 20,
                  ),
                  Stack(alignment: AlignmentDirectional.bottomCenter, children: <Widget>[
                    Column(
                      children: <Widget>[
                        IconButton(
                            iconSize: Dimensions.profileImageSize,
                            icon: Icon(
                              Icons.account_circle,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () => profileOrLogin(context)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: IconSize.large),
                          child: Text(
                            MyApp.of(context).auth.isLoggedIn
                                ? MyApp.of(context).auth.userInfo.givenName
                                : S.of(context).sign_up_or_log_in_to_access_all_functions,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .apply(color: Theme.of(context).iconTheme.color),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
                          onPressed: () => profileOrLogin(context),
                        ),
                      ],
                    )
                  ])
                ],
              ),
              decoration: BoxDecoration(color: Theme.of(context).highlightColor)),
        ),
        ListTile(
          enabled: MyApp.of(context).auth.isLoggedIn,
          title: Text(S.of(context).my_goals),
          leading: Icon(MdiIcons.bullseyeArrow),
          onTap: () => navigate(context, '/goals'),
        ),
        ListTile(
          enabled: MyApp.of(context).auth.isLoggedIn,
          title: Text(S.of(context).start_a_session),
          leading: ImageIcon(AssetImage('assets/logos/v-logo-smaller.png')),
          onTap: () => navigate(context, '/start_session'),
        ),
        ListTile(
          enabled: MyApp.of(context).auth.isLoggedIn,
          title: Text(S.of(context).plan),
          leading: Icon(Icons.calendar_today),
          onTap: () => navigate(context, '/home'),
        ),
        ListTile(
          enabled: MyApp.of(context).auth.isLoggedIn,
          title: Text(S.of(context).progress__insights),
          leading: Icon(MdiIcons.bullseyeArrow),
          onTap: () => navigate(context, '/progress_insights'),
        ),
        ListTile(
          enabled: MyApp.of(context).auth.isLoggedIn,
          title: Text(S.of(context).devices),
          leading: Icon(Icons.bluetooth),
          onTap: () => navigate(context, '/devices'),
        ),
        ListTile(
          title: Text(S.of(context).learning_center),
          leading: Icon(Icons.lightbulb_outline),
          onTap: () => navigate(context, '/learning_center'),
        ),
        ListTile(
          title: Text(S.of(context).contact__community),
          leading: Icon(Icons.chat),
          onTap: () => navigate(context, '/contact_community'),
        ),
        ListTile(
          title: Text(S.of(context).about),
          onTap: () => navigate(context, '/about'),
          leading: Icon(Icons.people),
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.language),
          title: DropdownButton(
            isExpanded: true,
            hint: Text(
              S.of(context).languageName,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.subtitle.fontSize,
                  color: Theme.of(context).textTheme.subtitle.color),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            underline: Container(
              height: 0,
            ),
            items: S.delegate.supportedLocales.map((locale) {
              return new DropdownMenuItem<String>(
                child: Text(locale.languageCode),
                value: locale.languageCode,
              );
            }).toList(),
            onChanged: (item) {
              MyApp.of(context).onChangeLanguage(item);
            },
          ),
        ),
      ])),
    );
  }

  void profileOrLogin(BuildContext context) {
    if (MyApp.of(context).auth.isLoggedIn) {
      navigate(context, "/profile");
    } else {
      Navigator.of(context).pushNamed("/login");
    }
  }

  void navigate(BuildContext context, String activity) {
    Navigator.pop(context);
    Navigator.pushNamed(context, activity);
  }
}