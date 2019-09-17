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
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => dismissLoginScreen(context)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
            color: Colors.white,
            alignment: FractionalOffset.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Visibility(
                  visible: MyApp.of(context).auth.refreshTokenExpired,
                  child:
                      Text(S.of(context).session_expired_please_log_in_again),
                ),
                Image.asset(
                  'assets/vfit.png',
                  height: 200,
                ),
                OutlineButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0)),
                    onPressed: () => MyApp.of(context)
                        .auth
                        .mapAppLogin()
                        .then((value) => dismissLoginScreen(context))
                        .catchError((error) => snack("$error", context)),
                    child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          S.of(context).login,
                          style: Theme.of(context).primaryTextTheme.title,
                          textAlign: TextAlign.center,
                        ))),
                FlatButton(
                    onPressed: () => dismissLoginScreen(context),
                    child: Padding(
                        padding: EdgeInsets.all(Dimensions.fullMargin),
                        child: Text(S.of(context).not_now,
                            style:
                                Theme.of(context).primaryTextTheme.subtitle))),
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(Dimensions.fullMargin),
                        child:
                            Image.asset('assets/JOYLUX-Black.jpg', height: 48))
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                )
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
