/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app_flutter/app_assets.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

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
                  MyApp.of(context).appAssets.drawerBanner(context),
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
                          child: ScopedModelDescendant<CarePlanModel>(
                              builder: (context, child, model) {
                            return Text(
                              nameDisplay(model, context),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .apply(color: Theme.of(context).iconTheme.color),
                              textAlign: TextAlign.center,
                            );
                          }),
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
        ...MyApp.of(context)
            .appAssets
            .navItems(context)
            .map((MenuItem item) => constructDrawerMenuItem(context, item)),
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
      _navigateFromDrawer(context, "/profile");
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  static void _navigateFromDrawer(BuildContext context, String activity) {
    navigate(context, activity, fromDrawer: true);
  }

  static void navigate(BuildContext context, String activity, {bool fromDrawer = false}) {
    if (fromDrawer) Navigator.pop(context); // close the drawer
    Navigator.pushNamed(context, activity);
  }

  ListTile constructDrawerMenuItem(BuildContext context, MenuItem item) {
    String title = item.title;
    if (!MyApp.of(context).auth.isLoggedIn && item.loggedOutTitle != null)
      title = item.loggedOutTitle;
    return ListTile(
        enabled: item.requiresLogin ? MyApp.of(context).auth.isLoggedIn : true,
        title: Text(title),
        leading: item.icon,
        onTap: () => {
              if (item.exitApp)
                {MyApp.of(context).logout(context: context)}
              else if (item.route != null)
                {_navigateFromDrawer(context, item.route)}
            });
  }

  String nameDisplay(CarePlanModel model, BuildContext context) {
    if (!MyApp.of(context).auth.isLoggedIn) {
      return S.of(context).sign_up_or_log_in_to_access_all_functions;
    }
    String nameDisplay = model?.patient?.fullNameDisplay;
    if (nameDisplay != null && nameDisplay.isNotEmpty) {
      return nameDisplay;
    }
    return S.of(context).name_not_entered;
  }
}
