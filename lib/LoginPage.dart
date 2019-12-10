/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/photos/woman-login.jpg'),
                    fit: BoxFit.fitHeight,
                    alignment: FractionalOffset(0.8, 0))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(
                  "assets/logos/Joylux_wdmk_color_rgb.png",
                  height: 40,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(height: 400,), //TODO: don't hardcode this
                    Visibility(
                      visible: MyApp.of(context).auth.refreshTokenExpired,
                      child:
                          Text(S.of(context).session_expired_please_log_in_again),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RaisedButton(
                          color: Color.fromRGBO(255, 255, 255, 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                          ),
                          elevation: 0,
                          onPressed: () => MyApp.of(context)
                              .auth
                              .mapAppLogin()
                              .then((value) => dismissLoginScreen(context))
                              .catchError((error) => snack("$error", context)),
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 100),
                              child: Text(
                                S.of(context).login,
                                style: Theme.of(context).primaryTextTheme.subhead,
                                textAlign: TextAlign.center,
                              ))),
                    ),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(Dimensions.fullMargin),
                            child: Image.asset(
                                'assets/logos/Vfit_logo_icon_circle_color_rgb_bg.png',
                                height: 48)),
                        Padding(
                            padding: EdgeInsets.all(Dimensions.fullMargin),
                            child: Image.asset(
                                'assets/logos/VSculpt_logo_circle_icon_color_rgb_bg.png',
                                height: 48))
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    FlatButton(
                        onPressed: () => dismissLoginScreen(context),
                        child: Padding(
                            padding: EdgeInsets.all(Dimensions.fullMargin),
                            child: Text(S.of(context).not_now,
                                style:
                                    Theme.of(context).primaryTextTheme.subtitle))),
                  ],
                ),
              ],
            )));
  }

  void dismissLoginScreen(BuildContext context) {
    if (MyApp.of(context).auth.isLoggedIn) {
      MyApp.of(context).auth.getUserInfo().then((value) {
        var keycloakUserId = MyApp.of(context).auth.userInfo.keycloakUserId;
        ScopedModel.of<CarePlanModel>(context).setUser(keycloakUserId);
        Navigator.of(context).pushReplacementNamed('/home');
      }).catchError((error) {
        Navigator.of(context).pushReplacementNamed('/guestHome');
      });
    } else {
      Navigator.of(context).pushReplacementNamed('/guestHome');
    }
  }
}
