/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';

class SessionPage extends StatefulWidget {
  @override
  State createState() {
    return new _SessionPageState();
  }
}

class _SessionPageState extends State<SessionPage> {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(child: _buildPageContent(context));
  }

  Widget _buildPageContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.largeMargin),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                ),
                elevation: 0,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Start a session",
                      textAlign: TextAlign.center,
                    )),
                onPressed: () {},
              ),
            ),
//            Image(
//              image: AssetImage("assets/photos/device-diagram.jpg"),
//              fit: BoxFit.contain,
//            )
            FittedBox(
                fit: BoxFit.contain,
                child:
//            Image.asset("assets/photos/Joylux-team.jpg"))

                    Image.asset(
                  'assets/photos/device-diagram.jpg',
                  height: 570, //TODO figure out how to set the size to fit
                )),
          ]),
    );
  }
}
