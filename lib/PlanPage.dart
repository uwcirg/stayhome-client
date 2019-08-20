/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/QuestionnairePage.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/Questionnaire.dart';
import 'package:map_app_flutter/generated/i18n.dart';
import 'package:map_app_flutter/services/Repository.dart';
import 'package:table_calendar/table_calendar.dart';

class PlanPage extends StatefulWidget {
  final TreatmentSchedule _schedule;
  final TreatmentPlan _plan;

  PlanPage(this._schedule, this._plan);

  @override
  _PlanPageState createState() => _PlanPageState(_schedule, _plan);
}

class _PlanPageState extends State<PlanPage> {
  final TreatmentSchedule _schedule;
  final TreatmentPlan _plan;
  int _counter = 0;
  CalendarController _calendarController;

  bool _updateState = false;

  Questionnaire _questionnaire;

  _PlanPageState(this._schedule, this._plan);

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    Repository.getQuestionnaire().then((Questionnaire value) {
      _questionnaire = value;
    }).catchError((error) {
      throw error;
    });
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
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.halfMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Treatment Schedule",
                style: Theme.of(context).textTheme.title,
              ),
              TableCalendar(
                availableCalendarFormats: {CalendarFormat.month: ""},
                calendarStyle: CalendarStyle(
                  weekendStyle: textStyle,
                  weekdayStyle: textStyle,
                  todayStyle: TextStyle(color: Colors.black),
                  selectedColor: Theme.of(context).accentColor,
                  todayColor: Theme.of(context).primaryColor,
                  outsideDaysVisible: false,
                  markersColor: Colors.red.shade900,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle:
                        TextStyle(color: Theme.of(context).accentColor)),
                calendarController: _calendarController,
                events: _schedule.events,
                builders: CalendarBuilders(markersBuilder: _buildMarkers),
              ),
              RaisedButton(
                child: Row(
                  children: [
                    Padding(
                      padding: MapAppPadding.buttonIconEdgeInsets,
                      child: Icon(Icons.add),
                    ),
                    Text("New Assessment"),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuestionnairePage(_questionnaire)));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: Dimensions.largeMargin),
                child: Text("My Treatment Plan",
                    style: Theme.of(context).textTheme.title),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Frequency: ${_plan.frequency}"),
                      Text("Duration: ${_plan.duration}"),
                    ],
                  ),
                  FlatButton(
                    child: Text(
                      "Change",
                    ),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ));
  }

  List<Widget> _buildMarkers(
      BuildContext context, DateTime date, List events, List holidays) {
    List<Widget> eventWidgets = [];
    double offset = 6;
    for (TreatmentEvent e in events) {
      IconData icon;
      if (e.eventType == EventType.Treatment) {
        icon = Icons.healing;
      } else {
        icon = Icons.check_circle;
        offset += IconSize.small;
      }
      var color;
      switch (e.status) {
        case Status.Completed:
          color = Theme.of(context).accentColor;
          break;
        case Status.Scheduled:
          color = Colors.grey;
          break;
        case Status.Missed:
          color = Colors.grey;
          break;
      }
      eventWidgets.add(Positioned(
        child: Icon(
          icon,
          color: color,
          size: IconSize.small,
        ),
        right: offset,
      ));
    }
    return eventWidgets;
  }
}

class TreatmentPlan {
  final String frequency;
  final String duration;

  TreatmentPlan(this.frequency, this.duration);

  static TreatmentPlan treatmentPlan() {
    return TreatmentPlan("Every other day", "12 min");
  }
}

class TreatmentSchedule {
  final Map<DateTime, List<TreatmentEvent>> events;

  TreatmentSchedule(this.events);

  static TreatmentSchedule treatmentSchedule() {
    var schedule = TreatmentSchedule({
      DateTime(2019, 8, 10): [
        TreatmentEvent(EventType.Treatment, Status.Completed),
        TreatmentEvent(EventType.Assessment, Status.Completed)
      ],
      DateTime(2019, 8, 11): [
        TreatmentEvent(EventType.Assessment, Status.Missed)
      ],
      DateTime(2019, 8, 12): [
        TreatmentEvent(EventType.Treatment, Status.Completed),
        TreatmentEvent(EventType.Assessment, Status.Completed)
      ],
      DateTime(2019, 8, 13): [
        TreatmentEvent(EventType.Assessment, Status.Completed)
      ],
      DateTime(2019, 8, 14): [
        TreatmentEvent(EventType.Treatment, Status.Missed),
        TreatmentEvent(EventType.Assessment, Status.Completed)
      ],
      DateTime(2019, 8, 25): [
        TreatmentEvent(EventType.Treatment, Status.Scheduled),
        TreatmentEvent(EventType.Assessment, Status.Scheduled)
      ],
    });

    for (int i = 1; i <= 31; i += 2) {
      schedule.events.putIfAbsent(DateTime(2019, 8, i),
          () => [TreatmentEvent(EventType.Treatment, Status.Scheduled)]);
    }
    return schedule;
  }
}

class TreatmentEvent {
  final EventType eventType;
  final Status status;

  TreatmentEvent(this.eventType, this.status);
}

enum EventType { Assessment, Treatment }
enum Status { Scheduled, Completed, Missed }
