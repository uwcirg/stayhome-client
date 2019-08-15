/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/generated/i18n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:table_calendar/table_calendar.dart';

class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  int _counter = 0;
  CalendarController _calendarController;

  bool _updateState = false;

  _PlanPageState();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = S.of(context).plan;
    var textStyle = Theme.of(context).textTheme.caption;
    return MapAppPageScaffold(
        title: title,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              availableCalendarFormats: {CalendarFormat.month: ""},
              calendarStyle: CalendarStyle(
                  weekendStyle: textStyle,
                  weekdayStyle: textStyle,
                  todayStyle: TextStyle(color: Colors.black),
                  selectedColor: Theme.of(context).accentColor,
                  todayColor: Theme.of(context).primaryColor,
                  outsideDaysVisible: false,
                  markersColor: Colors.red.shade900),
              calendarController: _calendarController,
              events: {
                DateTime(2019, 8, 9): ['Event A']
              },
            ),
            RaisedButton(
              onPressed: () {
                if (MyApp.of(context).auth.isLoggedIn) {
                  MyApp.of(context).auth.mapAppLogout().then((value) {
                    setState(() {
                      _updateState = !_updateState;
                    });
                    Navigator.of(context).pushNamed("/login");
                  });
                } else {
                  MyApp.of(context)
                      .auth
                      .mapAppLogin()
                      .then((value) => setState(() {
                            _updateState = !_updateState;
                          }));
                }
              },
              child: MyApp.of(context).auth.isLoggedIn
                  ? Text(S.of(context).logout)
                  : Text(S.of(context).login),
            )
          ],
        ));
  }
}
