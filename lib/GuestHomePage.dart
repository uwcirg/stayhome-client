/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';

class GuestHomePage extends StatefulWidget {
  @override
  GuestHomeState createState() => GuestHomeState();
}

class GuestHomeState extends State<GuestHomePage> {
  @override
  void initState() {
    super.initState();
  }  

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    double sideInsets = deviceInfo.size.width > MediaQueryConstants.minDesktopWidth ? Dimensions.extraLargeMargin : Dimensions.fullMargin;
    return MapAppPageScaffold(
      title: S.of(context).welcome,
      child: 
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.fullMargin),
        child:
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.fullMargin, horizontal: sideInsets),
                  child: Text('StayHome includes a resource directory that gives you direct access to trusted information sources to support your need for accurate information about how to maintain physical, financial, and personal wellbeing during the COVID-19 outbreak.'),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.halfMargin, horizontal: sideInsets),
                  child: Text('You can browse these sources or create an account to start tracking your own symptom information, temperature, travel, exposures or risks, and testing.'),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                       Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.largeMargin, horizontal: Dimensions.quarterMargin),
                        child: OutlineButton(
                          child: Text("back"),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/login');
                            }
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.largeMargin, horizontal: Dimensions.quarterMargin),
                        child: OutlineButton(
                          child: Text("access resources"),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/learning_center');
                            }
                        ),
                      ),

                    ]
                )
            ],
        )
      )
    );
  }
}
