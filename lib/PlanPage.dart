/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/QuestionnairePage.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'fhir/FhirResources.dart';
import 'main.dart';

class PlanPage extends StatefulWidget {
  PlanPage();

  static _PlanPageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_PlanPageState>());

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  CalendarController _calendarController;

  CarePlanModel _carePlanModel;

  _PlanPageState();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    var patientID = MyApp.of(context).auth.userInfo.patientResourceID;
    _carePlanModel = CarePlanModel(patientID);
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = S.of(context).plan;
    return ScopedModel(
        model: _carePlanModel,
        child: MapAppPageScaffold(title: title, child: buildScreen(context)));
  }

  Padding buildScreen(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.caption;
    return Padding(
      padding: const EdgeInsets.all(Dimensions.halfMargin),
      child: SafeArea(
        child: ScopedModelDescendant<CarePlanModel>(
            builder: (context, child, model) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildCalendar(textStyle, context, model),
              _buildQuestionnaireButtonSection(context, model),
              Padding(
                padding: const EdgeInsets.only(top: Dimensions.largeMargin),
                child: Text(S.of(context).my_treatment_plan,
                    style: Theme.of(context).textTheme.title),
              ),
              _buildCareplanInfoSection(context, model)
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCareplanInfoSection(BuildContext context, CarePlanModel model) {
    if (model.hasNoCarePlan) {
      return Wrap(
        children: <Widget>[
          Text(S
              .of(context)
              .you_have_no_active_pelvic_floor_management_careplan),
          FlatButton(
            child: Text(
              S.of(context).add_the_default_careplan_for_me,
            ),
            onPressed: () => _carePlanModel.addDefaultCareplan(),
          )
        ],
      );
    }
    if (model.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: model.carePlan.activity.map((Activity activity) {
        var durationUnit = activity.detail.scheduledTiming.repeat.durationUnit;
        var duration = activity.detail.scheduledTiming.repeat.duration;
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    activity.detail.description ?? S.of(context).activity,
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  Text(S.of(context).frequency_with_contents(
                      '${activity.detail.scheduledTiming.repeat.period}',
                      activity.detail.scheduledTiming.repeat.periodUnit)),
                  Visibility(
                    visible: duration != null || durationUnit != null,
                    child: Text(S.of(context).duration_duration_durationunit(
                        '$duration', durationUnit)),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              FlatButton(
                child: Text(
                  S.of(context).change,
                ),
                onPressed: () => _showChangeDialogForActivity(
                    context, model, model.carePlan.activity.indexOf(activity)),
              )
            ]);
      }).toList(),
    );
  }

  Widget _buildQuestionnaireButtonSection(
      BuildContext context, CarePlanModel model) {
    if (model.hasNoCarePlan)
      return Container(
        height: 0,
      );

    if (model.isLoading)
      return Padding(
        child: Center(child: CircularProgressIndicator()),
        padding: MapAppPadding.pageMargins,
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildQuestionnaireButtons(context, model),
    );
  }

  Widget _buildCalendar(
      TextStyle textStyle, BuildContext context, CarePlanModel model) {
    if (model.hasNoCarePlan)
      return Container(
        height: 0,
      );

    if (model.isLoading) return Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          S.of(context).treatment_calendar,
          style: Theme.of(context).textTheme.title,
        ),
        TreatmentCalendarWidget(_calendarController, model),
      ],
    );
  }

  List<Widget> _buildQuestionnaireButtons(
      BuildContext context, CarePlanModel model) {
    return model.questionnaires
        .map((Questionnaire questionnaire) => _buildQuestionnaireButton(
            context, questionnaire.title, questionnaire, model))
        .toList();
  }

  RaisedButton _buildQuestionnaireButton(BuildContext context, String title,
      Questionnaire questionnaire, CarePlanModel model) {
    return RaisedButton(
        child: Row(
          children: [
            Padding(
              padding: MapAppPadding.buttonIconEdgeInsets,
              child: Icon(Icons.add),
            ),
            Text(title),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuestionnairePage(questionnaire, model)));
        });
  }

  Future<String> _showChangeDialogForActivity(
      BuildContext context, CarePlanModel model, int activityIndex) async {
    Activity activity = model.carePlan.activity[activityIndex];
    var period2 = activity.detail.scheduledTiming.repeat.period;
    String every = period2 != null ? '$period2' : null;

    var duration2 = activity.detail.scheduledTiming.repeat.duration;
    String duration = duration2 != null ? '$duration2' : null;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Treatment Plan Activity'),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: new TextEditingController(text: every),
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Every', hintText: 'e.g. 2 for every 2 days'),
                onChanged: (value) {
                  every = value;
                },
              ),
              Visibility(
                  visible: duration != null && duration.trim().length > 0,
                  child: TextField(
                    controller: new TextEditingController(text: duration),
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Duration',
                        hintText: 'e.g. 12 for 12 minutes per session'),
                    onChanged: (value) {
                      duration = value;
                    },
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                bool valid = true;
                if (every != null && int.tryParse(every) == null) {
                  snack("Not a valid frequency", context);
                  valid = false;
                }
                if (duration != null && double.tryParse(duration) == null) {
                  snack("Not a valid duration", context);
                  valid = false;
                }
                if (valid) {
                  if (every != null)
                    model.updateActivityFrequency(
                        activityIndex, int.parse(every));
                  if (duration != null)
                    model.updateActivityDuration(
                        activityIndex, double.parse(duration));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class TreatmentCalendarWidget extends StatelessWidget {
  final CalendarController _calendarController;
  final CarePlanModel _model;

  TreatmentCalendarWidget(this._calendarController, this._model);

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.caption;

    return TableCalendar(
      availableCalendarFormats: {CalendarFormat.month: ""},
      calendarStyle: CalendarStyle(
          weekendStyle: textStyle,
          weekdayStyle: textStyle,
          todayStyle: TextStyle(color: Colors.black),
          selectedColor: Theme.of(context).accentColor,
          todayColor: Theme.of(context).primaryColor,
          outsideDaysVisible: false,
          markersColor: Colors.red.shade900,
          markersMaxAmount: 100),
      daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Theme.of(context).accentColor)),
      calendarController: _calendarController,
      events: _model.treatmentCalendar.events,
      builders: CalendarBuilders(markersBuilder: _buildMarkers),
    );
  }

  List<Widget> _buildMarkers(
      BuildContext context, DateTime date, List events, List holidays) {
    List<Widget> eventWidgets = [];
    double offset = 6;
    var eventTypes = {};
    events.forEach((var e) {
      if (eventTypes.containsKey(e.eventType)) {
        eventTypes[e.eventType]['count'] = eventTypes[e.eventType]['count'] + 1;
        eventTypes[e.eventType]['status'] =
            eventTypes[e.eventType]['status'] == Status.Completed ||
                    e.status == Status.Completed
                ? Status.Completed
                : e.status;
      } else {
        eventTypes[e.eventType] = {};
        eventTypes[e.eventType]['count'] = 1;
        eventTypes[e.eventType]['status'] = e.status;
      }
    });

    for (EventType type in eventTypes.keys) {
      IconData icon;
      if (type == EventType.Treatment) {
        icon = Icons.healing;
      } else {
        icon = Icons.check_circle;
        offset += IconSize.small;
      }
      var color;
      switch (eventTypes[type]['status']) {
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
      var number;
      if (eventTypes[type]['count'] > 9) {
        number = "..";
      } else if (eventTypes[type]['count'] > 1) {
        number = eventTypes[type]['count'];
      }
      eventWidgets.add(Positioned(
        child: Stack(children: [
          Icon(
            icon,
            color: color,
            size: IconSize.small_medium,
          ),
          Visibility(
            visible: number != null,
            child: Positioned(
                right: 0,
                bottom: -5,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: ShapeDecoration(
                      color: Colors.white, shape: CircleBorder()),
                  child: Text('$number',
                      style: Theme.of(context).textTheme.caption),
                )),
          )
        ]),
        right: offset,
      ));
    }
    return eventWidgets;
  }
}
