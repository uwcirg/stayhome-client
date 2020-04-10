/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/QuestionnairePage.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/map_app_widgets.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'fhir/FhirResources.dart';
import 'main.dart';

abstract class PlanPage extends StatefulWidget {
  PlanPage();

  static _PlanPageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_PlanPageState>());
}

abstract class _PlanPageState extends State<PlanPage> {
  _PlanPageState();

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        title: S.of(context).calendar,
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
              _buildCalendarPage(textStyle, context, model),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCalendarPage(TextStyle textStyle, BuildContext context, CarePlanModel model) {
    Widget errorWidget = MapAppErrorMessage.fromModel(model, context);
    if (errorWidget != null) return errorWidget;

    if (model.treatmentCalendar == null) {
      print("Treatment calendar is null.");
      return MapAppErrorMessage.loadingErrorWithLogoutButton(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: _buildCalendarPageChildren(context, model),
    );
  }

  List<Widget> _buildCalendarPageChildren(BuildContext context, CarePlanModel model);


  Widget _buildQuestionnaireButtonSection(BuildContext context, CarePlanModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.fullMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildQuestionnaireButtons(context, model),
      ),
    );
  }

  List<Widget> _buildQuestionnaireButtons(BuildContext context, CarePlanModel model) {
    if (model.questionnaires == null) return [];
    return model.questionnaires.map((Questionnaire questionnaire) {
      String title =
          questionnaire.title != null ? questionnaire.title.toLowerCase() : "questionnaire";
      return _buildQuestionnaireButton(context, title, questionnaire, model);
    }).toList();
  }

  RaisedButton _buildQuestionnaireButton(
      BuildContext context, String title, Questionnaire questionnaire, CarePlanModel model) {
    return RaisedButton(
        padding: MapAppPadding.largeButtonPadding,
        child: Row(
          children: [
            Padding(
              padding: MapAppPadding.buttonIconEdgeInsets,
              child: Icon(
                Icons.add,
                size: IconSize.small,
                color: Theme.of(context).textTheme.button.color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.button,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => QuestionnairePage(questionnaire, model)));
        });
  }

  Future<String> _showChangeDialogForActivity(
      BuildContext context, CarePlanModel model, int activityIndex);

  TreatmentCalendarWidget _buildTreatmentCalendarWidget(CarePlanModel model);
}

class TreatmentCalendarWidget extends StatefulWidget {
  final CarePlanModel _model;
  final _scheduledEventColor = Colors.grey[500];

  TreatmentCalendarWidget(this._model);

  @override
  State<StatefulWidget> createState() => TreatmentCalendarWidgetState();
}
class TreatmentCalendarWidgetState extends State<TreatmentCalendarWidget> {
  CalendarController _calendarController;

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
      events: widget._model.treatmentCalendar.events,
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
          color = MyApp.of(context).appAssets.completedCalendarItemColor;
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

  Widget _buildSingleMarker(BuildContext context, DateTime date, event) {
    event = event as TreatmentEvent;
    var color;
    if (event.status == Status.Completed) {
      color = MyApp.of(context).appAssets.completedCalendarItemColor;
    } else if (event.status == Status.Scheduled) {
      color = widget._scheduledEventColor;
    } else {
      color = Theme.of(context).accentColor;
    }
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class StayHomeTreatmentCalendarWidget extends TreatmentCalendarWidget {
  StayHomeTreatmentCalendarWidget(CarePlanModel model)
      : super(model);
  @override
  State<StatefulWidget> createState() => StayHomeTreatmentCalendarWidgetState();
}

class StayHomeTreatmentCalendarWidgetState extends TreatmentCalendarWidgetState {
  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.caption;
    var noInsets = const EdgeInsets.all(0);
    return TableCalendar(
      locale: Localizations.localeOf(context).languageCode,
      availableCalendarFormats: {CalendarFormat.month: ""},
      initialSelectedDay: null,
      headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          titleTextStyle: Theme.of(context).textTheme.subtitle.apply(fontWeightDelta: 2),
          titleTextBuilder: (DateTime date, dynamic locale) =>
              DateFormat.yMMMM(locale).format(_calendarController.focusedDay).toLowerCase(),
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
        selectedColor: Theme.of(context).highlightColor,
        renderSelectedFirst: false,
        todayColor: Theme.of(context).accentColor,
        outsideDaysVisible: false,
        markersMaxAmount: 20,
        markersPositionBottom: null,
        markersAlignment: Alignment.center,
//          markersAlignment: Alignment.center,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
          dowTextBuilder: (DateTime date, dynamic locale) =>
              DateFormat.E(locale).format(date).toString().toLowerCase(),
          weekdayStyle: Theme.of(context).textTheme.caption.apply(fontWeightDelta: 2),
          weekendStyle: Theme.of(context).textTheme.caption.apply(fontWeightDelta: 2)),
      calendarController: _calendarController,
      events: widget._model.treatmentCalendar.events,
      builders: CalendarBuilders(
//        singleMarkerBuilder: _buildSingleMarker,
        markersBuilder: _buildMarkers,
        dayBuilder: _buildDay,
      ),
    );
  }

  @override
  Widget _buildDay(BuildContext context, DateTime date, List events) {
    return Container(
        decoration: BoxDecoration(
          color: _calendarController.isToday(date) ? Theme.of(context).accentColor : null,
          border: Border.all(color: Theme.of(context).accentColor, width: 0.5),
        ),
        alignment: AlignmentDirectional.topCenter,
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          "${date.day}",
          style: Theme.of(context).textTheme.caption,
        ));
  }

  @override
  List<Widget> _buildMarkers(BuildContext context, DateTime date, List events, List holidays) {
    Widget child;
    if (events.length > 4) {
      int numCompleted =
          events.where((e) => (e as TreatmentEvent).status == Status.Completed).length;
      int numIncomplete =
          events.where((e) => (e as TreatmentEvent).status != Status.Completed).length;

      Widget completedBubble = _buildNumberBubble('$numCompleted', Theme.of(context).primaryColor,
          Theme.of(context).primaryTextTheme.caption);
      Widget incompleteBubble = _buildNumberBubble('$numIncomplete',
          widget._scheduledEventColor, Theme.of(context).primaryTextTheme.caption);
      if (numIncomplete == 0) {
        child = completedBubble;
      } else if (numCompleted == 0) {
        child = incompleteBubble;
      } else {
        child = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [completedBubble, incompleteBubble],
        );
      }
      return [Padding(padding: EdgeInsets.only(top: 10), child: child)];
    } else {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: events.map((event) => _buildSingleMarker(context, date, event)).toList(),
      );
      return [Padding(padding: EdgeInsets.only(top: 10), child: child)];
    }
  }

  Container _buildNumberBubble(String label, Color bubbleColor, TextStyle textStyle) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: ShapeDecoration(color: bubbleColor, shape: CircleBorder()),
      child: Text(label, style: textStyle),
    );
  }
}

class StayHomePlanPage extends PlanPage {
  @override
  _PlanPageState createState() {
    return _StayHomePlanPageState();
  }
}

class _StayHomePlanPageState extends _PlanPageState {
  @override
  List<Widget> _buildCalendarPageChildren(BuildContext context, CarePlanModel model) {
    return <Widget>[
      _buildQuestionnaireButtonSection(context, model),
      _buildTreatmentCalendarWidget(model),
//      Padding(
//        padding: const EdgeInsets.only(top: 8.0),
//        child: OutlineButton(
//          child: Text("change schedule"),
//          onPressed: () => _showChangeDialogForActivity(context, model, 0),
//        ),
//      )
    ];
  }

  @override
  TreatmentCalendarWidget _buildTreatmentCalendarWidget(CarePlanModel model) {
    return StayHomeTreatmentCalendarWidget(model);
  }
  
  Future<String> _showChangeDialogForActivity(
      BuildContext context, CarePlanModel model, int activityIndex) async {
    Activity activity = model.carePlan.activity[activityIndex];

    double period2 = activity.detail.scheduledTiming.repeat.period;
    String every = "";
    if (period2 != null) every = '${(1 / period2).round()}';

    var duration2 = activity.detail.scheduledTiming.repeat.duration;
    String duration = duration2 != null ? '$duration2' : null;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change care plan activity schedule'),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: new TextEditingController(text: every),
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Number per day', hintText: 'e.g. 2 for 2 questionnaires per day'),
                onChanged: (value) {
                  every = value;
                },
              ),
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
                int everyInt = int.parse(every);
                double newFrequency =
                    1.0 / everyInt; //e.g. if user wants 2 per day, 0.5days is new freq
                if (valid) {
                  if (every != null) model.updateActivityFrequency(activityIndex, newFrequency);
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
