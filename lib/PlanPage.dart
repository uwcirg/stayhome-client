/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/QuestionnairePage.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
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
  String _selectedChip;

  _PlanPageState();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        child: Expanded(
            child: ListView.builder(
      itemBuilder: (context, i) {
        return _buildScreen(context);
      },
      itemCount: 1,
      shrinkWrap: true,
    )));
  }

  Widget _buildScreen(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.caption;
    return Padding(
      padding: const EdgeInsets.all(Dimensions.halfMargin),
      child: SafeArea(
        child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildCalendar(textStyle, context, model),
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
          Text(S.of(context).you_have_no_active_pelvic_floor_management_careplan),
          FlatButton(
            child: Text(
              S.of(context).add_the_default_careplan_for_me,
            ),
            onPressed: () => model.addDefaultCareplan(),
          )
        ],
      );
    }
    if (model.error != null) {
      return Wrap(
        children: <Widget>[
          Text(model.error),
        ],
      );
    }
    if (model.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.fullMargin),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _choiceChip("Introduction"),
              _choiceChip("Wellness"),
              _choiceChip("Maintenance")
            ],
          ),
          Visibility(
            visible: _selectedChip != null,
            child: Container(
                margin: EdgeInsets.only(top: 35),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: Dimensions.borderWidth),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(0), bottom: Radius.circular(5)),
                  color: Theme.of(context).accentColor,
                ),
                child: _infoContentForSelectedChip(context, model)),
          )
        ],
      ),
    );
  }

  Widget _choiceChip(String chipLabel) {
    bool isSelected = chipLabel == _selectedChip;
    return Flexible(
      child: ChoiceChip(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        shape: RoundedRectangleBorder(
            borderRadius: _selectedChip == null
                ? BorderRadius.circular(5)
                : BorderRadius.vertical(top: Radius.circular(5), bottom: Radius.circular(0))),
        label: Row(
          children: <Widget>[
            Flexible(
              child: Text(
                chipLabel,
                style: Theme.of(context)
                    .accentTextTheme
                    .caption
                    .apply(color: Theme.of(context).accentTextTheme.body1.color),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              isSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Theme.of(context).accentTextTheme.body1.color,
              size: IconSize.small,
            )
          ],
        ),
        selected: isSelected,
        onSelected: (bool) => setState(() {
          if (isSelected) {
            _selectedChip = null;
          } else {
            _selectedChip = chipLabel;
          }
        }),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _infoContentForSelectedChip(BuildContext context, CarePlanModel model) {
    List<Widget> children = [];
    children.addAll(model.carePlan.activity.map((Activity activity) {
      var durationUnit = activity.detail.scheduledTiming.repeat.durationUnit;
      var duration = activity.detail.scheduledTiming.repeat.duration;
      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            child: Column(
              children: [
                Text(
                  activity.detail.description ?? S.of(context).activity,
                  style: Theme.of(context).accentTextTheme.subtitle,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                Text(
                  S.of(context).frequency,
                  style: Theme.of(context).accentTextTheme.body1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    S.of(context).frequency_with_contents(
                        '${activity.detail.scheduledTiming.repeat.period}',
                        activity.detail.scheduledTiming.repeat.periodUnit),
                    style: Theme.of(context).accentTextTheme.body1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
                Visibility(
                  visible: duration != null || durationUnit != null,
                  child: Column(
                    children: <Widget>[
                      Text(
                        S.of(context).duration,
                        style: Theme.of(context).accentTextTheme.body1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          S.of(context).duration_duration_durationunit('$duration', durationUnit),
                          style: Theme.of(context).accentTextTheme.body1,
                        ),
                      ),
                    ],
                  ),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          RaisedButton(
            elevation: 0,
            child: Text(
              S.of(context).change,
            ),
            onPressed: () => _showChangeDialogForActivity(
                context, model, model.carePlan.activity.indexOf(activity)),
          )
        ]),
      );
    }));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildQuestionnaireButtonSection(BuildContext context, CarePlanModel model) {
    if (model.hasNoCarePlan || model.error != null)
      return Container(
        height: 0,
      );

    if (model.isLoading)
      return Padding(
        child: Center(child: CircularProgressIndicator()),
        padding: MapAppPadding.pageMargins,
      );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.fullMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildQuestionnaireButtons(context, model),
      ),
    );
  }

  Widget _buildCalendar(TextStyle textStyle, BuildContext context, CarePlanModel model) {
    if (model.hasNoCarePlan || model.error != null)
      return Container(
        height: 0,
      );

    if (model.isLoading) return Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              S.of(context).treatment_calendar,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "Lorem ipsum dolor sit amet, eu sit explicari expetendis, nullam putent ceteros an pri. Quaeque insolens cu ius, eu nulla delicatissimi has."),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(S.of(context).my_treatment_plan, style: Theme.of(context).textTheme.title),
          ),
        ),
        _buildCareplanInfoSection(context, model),
        _buildQuestionnaireButtonSection(context, model),
        TreatmentCalendarWidget(_calendarController, model),
      ],
    );
  }

  List<Widget> _buildQuestionnaireButtons(BuildContext context, CarePlanModel model) {
    return model.questionnaires
        .map((Questionnaire questionnaire) =>
            _buildQuestionnaireButton(context, "Complete Questionnaire", questionnaire, model))
        .toList();
  }

  RaisedButton _buildQuestionnaireButton(
      BuildContext context, String title, Questionnaire questionnaire, CarePlanModel model) {
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
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => QuestionnairePage(questionnaire, model)));
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
                decoration:
                    new InputDecoration(labelText: 'Every', hintText: 'e.g. 2 for every 2 days'),
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
                        labelText: 'Duration', hintText: 'e.g. 12 for 12 minutes per session'),
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
                  if (every != null) model.updateActivityFrequency(activityIndex, int.parse(every));
                  if (duration != null)
                    model.updateActivityDuration(activityIndex, double.parse(duration));
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
    var noInsets = const EdgeInsets.all(0);
    return TableCalendar(
      locale: Localizations.localeOf(context).languageCode,
      availableCalendarFormats: {CalendarFormat.month: ""},
      headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          titleTextStyle: Theme.of(context).textTheme.subtitle.apply(fontWeightDelta: 2),
          leftChevronPadding: noInsets,
          rightChevronPadding: noInsets,
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).textTheme.subtitle.color,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Theme.of(context).textTheme.subtitle.color,
          )),
      calendarStyle: CalendarStyle(
          weekendStyle: textStyle,
          weekdayStyle: textStyle,
          todayStyle: TextStyle(color: Colors.black),
          selectedColor: Theme.of(context).accentColor,
          todayColor: Theme.of(context).primaryColor,
          outsideDaysVisible: true,
          markersColor: Colors.red.shade900,
          markersMaxAmount: 100,
          markersAlignment: Alignment.center),
      daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: Theme.of(context).textTheme.caption.apply(fontWeightDelta: 2),
          weekendStyle: Theme.of(context).textTheme.caption.apply(fontWeightDelta: 2)),
      calendarController: _calendarController,
      events: _model.treatmentCalendar.events,
      builders: CalendarBuilders(
          markersBuilder: _buildMarkers,
          dayBuilder: _buildDay,
          outsideDayBuilder: _buildOutsideDay,
          outsideWeekendDayBuilder: _buildOutsideDay),
    );
  }

  List<Widget> _buildMarkers(BuildContext context, DateTime date, List events, List holidays) {
    List<Widget> eventWidgets = [];
    double offset = 6;
    var eventTypes = {};
    events.forEach((var e) {
      if (eventTypes.containsKey(e.eventType)) {
        eventTypes[e.eventType]['count'] = eventTypes[e.eventType]['count'] + 1;
        eventTypes[e.eventType]['status'] =
            eventTypes[e.eventType]['status'] == Status.Completed || e.status == Status.Completed
                ? Status.Completed
                : e.status;
      } else {
        eventTypes[e.eventType] = {};
        eventTypes[e.eventType]['count'] = 1;
        eventTypes[e.eventType]['status'] = e.status;
      }
    });

    for (EventType type in eventTypes.keys) {
      var color;
      switch (eventTypes[type]['status']) {
        case Status.Completed:
          color = Theme.of(context).accentColor;
          break;
        case Status.Scheduled:
          color = Colors.grey[600];
          break;
        case Status.Missed:
          color = Colors.grey[600];
          break;
      }

      Widget icon;
      if (type == EventType.Treatment) {
        icon = ImageIcon(
          AssetImage('assets/logos/v-logo-smaller.png'),
          color: color,
          size: IconSize.small,
        );
      } else {
        icon = Icon(Icons.help, color: color, size: IconSize.small);
        offset += IconSize.small;
      }

      var number;
      if (eventTypes[type]['count'] > 9) {
        number = "..";
      } else if (eventTypes[type]['count'] > 1) {
        number = eventTypes[type]['count'];
      }

      eventWidgets.add(Positioned(
        child: Stack(children: [
          icon,
          Visibility(
            //count badge
            visible: number != null,
            child: Positioned(
                right: 0,
                bottom: -5,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: ShapeDecoration(color: Colors.white, shape: CircleBorder()),
                  child: Text('$number', style: Theme.of(context).textTheme.caption),
                )),
          )
        ]),
        right: offset,
      ));
    }
    return eventWidgets;
  }

  Widget _buildDay(BuildContext context, DateTime date, List events) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.2),
          color: Theme.of(context).highlightColor,
        ),
        alignment: AlignmentDirectional.topCenter,
        child: Text(
          "${date.day}",
          style: Theme.of(context).textTheme.caption,
        ));
  }

  Widget _buildOutsideDay(BuildContext context, DateTime date, List events) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.2),
          color: Theme.of(context).highlightColor,
        ),
        alignment: AlignmentDirectional.topCenter,
        child: Text(
          "",
          style: Theme.of(context).textTheme.caption,
        ));
  }
}
