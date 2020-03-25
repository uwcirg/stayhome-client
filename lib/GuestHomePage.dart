/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';

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
    double sideInsets = deviceInfo.size.width > MediaQueryConstants.minTabletWidth ? Dimensions.extraLargeMargin : Dimensions.fullMargin;
    double titleInsets =  deviceInfo.size.width > MediaQueryConstants.minTabletWidth ? Dimensions.extraLargeMargin * 2.75 : Dimensions.fullMargin;
    var childWidgets = <Widget>[
                       Padding(
                        padding: EdgeInsets.only(top: Dimensions.fullMargin, bottom: Dimensions.quarterMargin, left: Dimensions.quarterMargin, right: Dimensions.fullMargin),
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
                          child: Text(
                            "back to login/register",
                            style: TextStyle(color: Theme.of(context).primaryColor)),
                            onPressed: () {
                              MyApp.of(context).logout(context: context);
                            }
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.fullMargin, bottom: Dimensions.quarterMargin, left: Dimensions.quarterMargin, right: Dimensions.quarterMargin),
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
                          child: Text(
                            "continue to resources",
                            style: TextStyle(color: Theme.of(context).primaryColor)
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/learning_center');
                            }
                        ),
                      ),

                    ];
    return MapAppPageScaffold(
      title: S.of(context).welcome,
      child: 
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.fullMargin, horizontal: Dimensions.fullMargin),
        child:
        Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.fullMargin, horizontal: titleInsets),
                      child: Text('StayHome includes a resource directory that gives you direct access to trusted information sources to support your need for accurate information about how to maintain physical, financial, and personal wellbeing during the COVID-19 outbreak.'),
                  )
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.halfMargin, left: sideInsets, right: sideInsets, bottom: Dimensions.fullMargin),
                        child: Text('You can browse these sources or create an account to:')
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.halfMargin, left: sideInsets, right: sideInsets, bottom: Dimensions.fullMargin),
                        child: Text('-  track your own symptoms')
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.halfMargin, left: sideInsets, right: sideInsets, bottom: Dimensions.fullMargin),
                        child: Text('-  track your travel and exposure risks'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.halfMargin, left: sideInsets, right: sideInsets, bottom: Dimensions.fullMargin),
                        child: Text('-  record COVID-19 testing results'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.halfMargin, left: sideInsets, right: sideInsets, bottom: Dimensions.largeMargin),
                        child: Text('Without an account, you will not be able to access these tools'),
                      ),
                    ]
                  ),
                ),
                Center(
                  child:  
                    deviceInfo.size.width > MediaQueryConstants.minTabletWidth ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: childWidgets
                    ) :
                    Column (
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: childWidgets
                    )
                )       
            ],
        )
      )
    );
  }
}
