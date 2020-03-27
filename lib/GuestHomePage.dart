/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppDrawer.dart';
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
                              MapAppDrawer.navigate(context, '/learning_center');
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
                      child: Text('StayHome includes a list of resources that gives you direct access to information sources that we believe to be accurate. We hope these sources will help you maintain your health, safety, and wellbeing during the COVID-19 outbreak.'),
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
                        child: Text('Without an account, you can “continue” below to browse these sources, and follow the links they contain.')
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.halfMargin, left: sideInsets, right: sideInsets, bottom: Dimensions.fullMargin),
                        child: Text('If you do decide to create an account, now or later, you can:')
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.halfMargin, left: sideInsets, right: sideInsets, bottom: Dimensions.fullMargin),
                        child: Text('-  track your own symptoms and temperature')
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.halfMargin, left: sideInsets, right: sideInsets, bottom: Dimensions.fullMargin),
                        child: Text('-  track travel and/or times you may have been exposed'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.halfMargin, left: sideInsets, right: sideInsets, bottom: Dimensions.fullMargin),
                        child: Text('-  record COVID-19 testing, which can help public health match your results with a way to contact you'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.halfMargin, left: sideInsets, right: sideInsets, bottom: Dimensions.fullMargin),
                        child: Text('-  record other information such as pregnancy and occupation that may help public health identify specific programs or protections for you.'),
                      )
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
