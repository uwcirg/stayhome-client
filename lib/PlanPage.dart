/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/QuestionnairePage.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/Exception.dart';
import 'package:map_app_flutter/generated/i18n.dart';
import 'package:map_app_flutter/services/Repository.dart';
import 'package:table_calendar/table_calendar.dart';

import 'fhir/FhirResources.dart';
import 'main.dart';

class PlanPage extends StatefulWidget {
  PlanPage();

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  TreatmentCalendar _treatmentCalendar;
  int _counter = 0;
  CalendarController _calendarController;

  bool _updateState = false;

  Patient _patient;

  CarePlan _carePlan;
  bool _hasNoCarePlan = false;

  List<Procedure> _procedures;

  List<Questionnaire> _questionnaires;

  List<QuestionnaireResponse> _questionnaireResponses;

  _PlanPageState();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    var patientID = MyApp.of(context).auth.userInfo.patientResourceID;
    Repository.getPatient(patientID).then((Patient patient) {
      _patient = patient;
      Repository.getCarePlan(patient).then((CarePlan carePlan) {
        if (carePlan == null) {
          setState(() {
            _hasNoCarePlan = true;
          });
        } else {
          _carePlan = carePlan;
          _loadQuestionnaires();
        }
      });
    });
  }

  void _loadQuestionnaires() {
    Repository.getQuestionnaires(_carePlan).then((var questionnaires) {
      setState(() {
        _questionnaires = questionnaires;
      });
    });
    List<Future> futures = [
      Repository.getProcedures(_carePlan).then((List<Procedure> procedures) {
        _procedures = procedures;
      }),
      Repository.getQuestionnaireResponses(_carePlan)
          .then((List<QuestionnaireResponse> responses) {
        _questionnaireResponses = responses;
      })
    ];

    Future.wait(futures).then((var value) {
      var treatmentCalendar = TreatmentCalendar.make(
          _carePlan, _procedures, _questionnaireResponses);
      setState(() {
        _treatmentCalendar = treatmentCalendar;
      });
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
    return MapAppPageScaffold(title: title, child: buildScreen(context));
  }

  Padding buildScreen(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.caption;
    return Padding(
      padding: const EdgeInsets.all(Dimensions.halfMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildCalendar(textStyle, context),
          _buildQuestionnaireButtonSection(context),
          Padding(
            padding: const EdgeInsets.only(top: Dimensions.largeMargin),
            child: Text("My Treatment Plan",
                style: Theme.of(context).textTheme.title),
          ),
          _buildCareplanInfoSection(context)
        ],
      ),
    );
  }

  Widget _buildCareplanInfoSection(BuildContext context) {
    if (_hasNoCarePlan) {
      return Wrap(
        children: <Widget>[
          Text("You have no active Pelvic Floor Management Careplan."),
          FlatButton(
            child: Text(
              "Add the default CarePlan for me",
            ),
            onPressed: () {
              Repository.loadCarePlan("54").then((CarePlan plan) {
                CarePlan newPlan = CarePlan.fromTemplate(plan, _patient);
                Repository.postCarePlan(newPlan).then((value) {
                  setState(() {
                    _carePlan = CarePlan.fromJson(jsonDecode(value.body));
                    _hasNoCarePlan = false;
                  });
                  _loadQuestionnaires();
                });
              });
            },
          )
        ],
      );
    }
    if (_treatmentCalendar == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _carePlan.activity
              .map((Activity activity) {
                return [
                  Text(
                    activity.detail.description ?? "Activity",
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  Text(
                      "Frequency: ${activity.detail.scheduledTiming.repeat.frequency} time(s) every ${activity.detail.scheduledTiming.repeat.period} ${activity.detail.scheduledTiming.repeat.periodUnit}"),
                  Visibility(
                    visible: activity.detail.scheduledTiming.repeat.duration !=
                            null ||
                        activity.detail.scheduledTiming.repeat.durationUnit !=
                            null,
                    child: Text(
                        "Duration: ${activity.detail.scheduledTiming.repeat.duration} ${activity.detail.scheduledTiming.repeat.durationUnit}"),
                  )
                ];
              })
              .toList()
              .expand((i) => i)
              .toList(),
        ),
        FlatButton(
          child: Text(
            "Change",
          ),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _buildQuestionnaireButtonSection(BuildContext context) {
    if (_hasNoCarePlan) return Container(height: 0,);

    if (_questionnaires == null)
      return Padding(
        child: Center(child: CircularProgressIndicator()),
        padding: MapAppPadding.pageMargins,
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildQuestionnaireButtons(context),
    );
  }

  Widget _buildCalendar(TextStyle textStyle, BuildContext context) {
    if (_hasNoCarePlan)
      return Container(
        height: 0,
      );

    if (_treatmentCalendar == null)
      return Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Treatment Calendar",
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
              weekendStyle: TextStyle(color: Theme.of(context).accentColor)),
          calendarController: _calendarController,
          events: _treatmentCalendar.events,
          builders: CalendarBuilders(markersBuilder: _buildMarkers),
        ),
      ],
    );
  }

  List<Widget> _buildQuestionnaireButtons(BuildContext context) {
    return _questionnaires
        .map((Questionnaire questionnaire) => _buildQuestionnaireButton(
            context, questionnaire.title, questionnaire))
        .toList();
  }

  RaisedButton _buildQuestionnaireButton(
      BuildContext context, String title, Questionnaire questionnaire) {
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
              builder: (context) => QuestionnairePage(questionnaire,
                  Reference(reference: _patient.reference), _carePlan)));
        });
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

class TreatmentCalendar {
  Map<DateTime, List<TreatmentEvent>> events;

  TreatmentCalendar(this.events);

  TreatmentCalendar.make(CarePlan plan, List<Procedure> procedures,
      List<QuestionnaireResponse> questionnaireResponses) {
    events = new Map();

    addScheduledActivities(plan);
    addProcedureInstances(procedures);
    addAssessmentInstances(plan, questionnaireResponses);
  }

  /// If there is a matching scheduled event, update the status; otherwise,
  /// add a new event for this activity instance.
  void addProcedureInstances(List<Procedure> procedures) {
    for (Procedure procedure in procedures) {
      List<TreatmentEvent> eventList =
          events.putIfAbsent(procedure.performedDateTime, () => []);

      // find matching scheduled event
      TreatmentEvent event = eventList.firstWhere(
          (TreatmentEvent e) => e.code == procedure.code,
          orElse: () => null);

      if (event != null) {
        event.updateStatus(procedure.status);
      } else {
        eventList.add(TreatmentEvent.fromProcedure(procedure));
      }
    }
  }

  /// If there is a matching scheduled event, update the status; otherwise,
  /// add a new event for this activity instance.
  void addAssessmentInstances(
      CarePlan plan, List<QuestionnaireResponse> responses) {
    if (responses == null || responses.length == 0) return;
    List<String> applicableQuestionnaires =
        plan.getAllQuestionnaireReferences();

    for (QuestionnaireResponse response in responses) {
      if (!applicableQuestionnaires.contains(response.questionnaireReference)) {
        continue;
      }

      List<TreatmentEvent> eventList =
          events.putIfAbsent(response.authored, () => []);

      // find matching scheduled event
      TreatmentEvent event = eventList.firstWhere(
          (TreatmentEvent e) =>
              e.questionnaireReference == response.questionnaireReference,
          orElse: () {
        return null;
      });

      if (event != null) {
        event.updateStatus(response.status);
      } else {
        eventList.add(TreatmentEvent.fromQuestionnaireResponse(response));
      }
    }
  }

  void addScheduledActivities(CarePlan plan) {
    for (Activity activity in plan.activity) {
      if (activity.detail.scheduledTiming.repeat.periodUnit != "d") {
        throw UnimplementedError("Can only handle periodUnit of 'd' for now.");
      }

      Period scheduledPeriod = getScheduledPeriod(plan, activity);

      if (activity.detail.scheduledTiming.repeat.period == null) {
        throw MalformedFhirResourceException(plan,
            "Resource must have a period length specified in every activity.detail.scheduledTiming");
      }
      int every = activity.detail.scheduledTiming.repeat.period;
      TreatmentEvent event = TreatmentEvent.scheduledEventForActivity(activity);
      addEvents(scheduledPeriod, every, event);
    }
  }

  Period getScheduledPeriod(CarePlan plan, Activity activity) {
    Period scheduledPeriod;
    if (activity.detail.scheduledPeriod != null &&
        activity.detail.scheduledPeriod.start != null &&
        activity.detail.scheduledPeriod.end != null) {
      scheduledPeriod = activity.detail.scheduledPeriod;
    } else if (plan.period != null &&
        plan.period.start != null &&
        plan.period.end != null) {
      scheduledPeriod = plan.period;
    } else {
      throw MalformedFhirResourceException(plan,
          "Either ${plan.reference} or the containing activity with code ${FhirConstants.SNOMED_PELVIC_FLOOR_EXERCISES} must have period start and end");
    }
    return scheduledPeriod;
  }

  void addEvents(Period period, int every, TreatmentEvent event) {
    var date = period.start;
    while (date.isBefore(period.end)) {
      if (date.difference(period.start).inDays % every == 0) {
        List<TreatmentEvent> dateEvents = events.putIfAbsent(date, () => []);
        dateEvents.add(TreatmentEvent.from(event));
      }
      date = date.add(Duration(days: every));
    }
  }
}

class TreatmentEvent {
  final EventType eventType;
  Status status;
  CodeableConcept code;
  String questionnaireReference;

  TreatmentEvent(
      this.eventType, this.status, this.code, this.questionnaireReference);

  factory TreatmentEvent.fromProcedure(Procedure procedure) {
    TreatmentEvent e =
        TreatmentEvent(EventType.Treatment, null, procedure.code, null);
    e.updateStatus(procedure.status);
    return e;
  }

  factory TreatmentEvent.fromQuestionnaireResponse(
      QuestionnaireResponse questionnaireResponse) {
    TreatmentEvent e = TreatmentEvent(
        EventType.Assessment, null, null, questionnaireResponse.reference);
    e.updateStatus(questionnaireResponse.status);
    return e;
  }

  TreatmentEvent.from(TreatmentEvent event)
      : this(event.eventType, event.status, event.code,
            event.questionnaireReference);

  void updateStatus(var status) {
    if (status == null) {
      this.status = Status.Scheduled;
    } else {
      if (status is ProcedureStatus) {
        if (status == ProcedureStatus.completed) {
          this.status = Status.Completed;
        } else if (status == ProcedureStatus.not_done) {
          this.status = Status.Missed;
        } else {
          this.status = Status.Scheduled;
        }
      } else if (status is QuestionnaireResponseStatus) {
        if (status == QuestionnaireResponseStatus.completed) {
          this.status = Status.Completed;
        } else if (status == QuestionnaireResponseStatus.stopped) {
          this.status = Status.Missed;
        } else {
          this.status = Status.Scheduled;
        }
      } else {
        throw ArgumentError(
            "Status class has to be either ProcedureStatus or QuestionnaireResponseStatus");
      }
    }
  }

  static TreatmentEvent scheduledEventForActivity(Activity activity) {
    if (activity.detail.code != null) {
      // if there is a code, assume it's a treatment
      return TreatmentEvent(
          EventType.Treatment, Status.Scheduled, activity.detail.code, null);
    } else {
      // assume a questionnaire
      if (activity.detail.instantiatesCanonical == null ||
          activity.detail.instantiatesCanonical.length > 1 ||
          !activity.detail.instantiatesCanonical[0]
              .startsWith(Questionnaire.resourceTypeName)) {
        throw MalformedFhirResourceException(
            activity,
            "Activity should have exactly one "
            "Questionnaire listed in its Detail's instantiatesCanonical list "
            "if it refers to a questionnaire.");
      }
      return TreatmentEvent(EventType.Assessment, Status.Scheduled, null,
          activity.detail.instantiatesCanonical[0]);
    }
  }
}

enum EventType { Assessment, Treatment }
enum Status { Scheduled, Completed, Missed }
