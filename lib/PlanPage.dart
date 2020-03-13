/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/ProfilePage.dart';
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
        title: "Calendar",
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
    if (model == null)
      return _buildErrorMessage("Loading error. Please log in again. (model null)",
          buttonLabel: "logout", onPressed: () => MyApp.of(context).logout(context: context));

    if (model.error != null) {
      return _buildErrorMessage('${model.error}');
    }

    if (model.isLoading) return Center(child: CircularProgressIndicator());

    if (model.hasNoPatient) return _buildCreateMyProfileButton(context, model);

    if (model.hasNoCarePlan) return _buildAddDefaultCareplanSection(context, model);

    if (model.treatmentCalendar == null) {
      return _buildErrorMessage(
          "Loading error. Treatment Calendar is null. Try logging out and in again.",
          buttonLabel: "logout",
          onPressed: () => MyApp.of(context).logout(context: context));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: _buildCalendarPageChildren(context, model),
    );
  }

  List<Widget> _buildCalendarPageChildren(BuildContext context, CarePlanModel model) {
    return <Widget>[
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
      !model.hasNoCarePlan
          ? _buildTreatmentCalendarWidget(_calendarController, model)
          : Container(
              height: 0,
            ),
    ];
  }

  Widget _buildCareplanInfoSection(BuildContext context, CarePlanModel model) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.fullMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildQuestionnaireButtons(context, model),
      ),
    );
  }

  Widget _buildAddDefaultCareplanSection(BuildContext context, CarePlanModel model) {
    return _buildErrorMessage(
      S.of(context).you_have_no_active_pelvic_floor_management_careplan,
      buttonLabel: S.of(context).add_the_default_careplan_for_me,
      onPressed: () => model.addDefaultCareplan(),
    );
  }

  Widget _buildCreateMyProfileButton(BuildContext context, CarePlanModel model) {
    return _buildErrorMessage(
      "You do not have a patient record in the FHIR database.",
      buttonLabel: "create one",
      onPressed: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateProfilePage())),
    );
  }

  Widget _buildErrorMessage(String message, {String buttonLabel, Function onPressed}) {
    List<Widget> children = [
      Center(child: Text(message, textAlign: TextAlign.center)),
    ];
    if (buttonLabel != null) {
      children.add(RaisedButton(child: Text(buttonLabel), onPressed: onPressed));
    }
    return Column(children: children);
  }

  List<Widget> _buildQuestionnaireButtons(BuildContext context, CarePlanModel model) {
    if (model.questionnaires == null) return [];
    return model.questionnaires
        .map((Questionnaire questionnaire) =>
            _buildQuestionnaireButton(context, "complete questionnaire", questionnaire, model))
        .toList();
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
                if (every != null && double.tryParse(every) == null) {
                  snack("Not a valid frequency", context);
                  valid = false;
                }
                if (duration != null && double.tryParse(duration) == null) {
                  snack("Not a valid duration", context);
                  valid = false;
                }
                if (valid) {
                  if (every != null)
                    model.updateActivityFrequency(activityIndex, double.parse(every));
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

  _buildTreatmentCalendarWidget(CalendarController calendarController, CarePlanModel model) {
    return TreatmentCalendarWidget(_calendarController, model);
  }
}

class TreatmentCalendarWidget extends StatelessWidget {
  final CalendarController _calendarController;
  final CarePlanModel _model;
  static final _scheduledEventColor = Colors.grey[500];

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
          color = MyApp.of(context).themeAssets.completedCalendarItemColor;
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
      color = MyApp.of(context).themeAssets.completedCalendarItemColor;
    } else if (event.status == Status.Scheduled) {
      color = _scheduledEventColor;
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
  StayHomeTreatmentCalendarWidget(CalendarController calendarController, CarePlanModel model)
      : super(calendarController, model);

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
      events: _model.treatmentCalendar.events,
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
          TreatmentCalendarWidget._scheduledEventColor, Theme.of(context).primaryTextTheme.caption);
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
      _buildTreatmentCalendarWidget(_calendarController, model),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: OutlineButton(
          child: Text("change schedule"),
          onPressed: () => _showChangeDialogForActivity(context, model, 0),
        ),
      )
    ];
  }

  @override
  _buildTreatmentCalendarWidget(CalendarController calendarController, CarePlanModel model) {
    return StayHomeTreatmentCalendarWidget(_calendarController, model);
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
