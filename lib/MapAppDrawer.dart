/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';
import 'package:map_app_flutter/main.dart';

class MapAppDrawer extends Drawer {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: const EdgeInsets.all(0.0), children: [
      DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      color: Theme.of(context).primaryIconTheme.color,
                      size: Dimensions.profileImageSize,
                    ),
                    onPressed: () => profileOrLogin(context)),
                Text(
                  MyApp.of(context).title,
                  style: Theme.of(context).primaryTextTheme.title,
                )
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                        child: Text(
                      MyApp.of(context).auth.isLoggedIn
                          ? MyApp.of(context).auth.userInfo.givenName
                          : S
                              .of(context)
                              .sign_up_or_log_in_to_access_all_functions,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                    IconButton(
                        icon: Icon(Icons.settings,
                            color: Theme.of(context).primaryIconTheme.color),
                        onPressed: () => profileOrLogin(context))
                  ])
            ],
          ),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor)),
      ListTile(
        enabled: MyApp.of(context).auth.isLoggedIn,
        title: Text(S.of(context).plan),
        leading: Icon(Icons.calendar_today),
        onTap: () => navigate(context, '/home'),
      ),
      ListTile(
        enabled: MyApp.of(context).auth.isLoggedIn,
        title: Text(S.of(context).progress__insights),
        leading: Icon(Icons.healing),
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
      Divider(),
      ListTile(
        title: Text(S.of(context).about),
        onTap: () => navigate(context, '/about'),
        trailing: Icon(Icons.info),
      ),
      ListTile(
        title: DropdownButton(
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
          hint: Text(S.of(context).languageName,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.subtitle.fontSize,
                  color: Theme.of(context).textTheme.subtitle.color)),
        ),
        trailing: Icon(Icons.language),
      )
    ]));
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
