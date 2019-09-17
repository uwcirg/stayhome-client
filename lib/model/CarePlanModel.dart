/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:map_app_flutter/fhir/Exception.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/services/Repository.dart';
import 'package:scoped_model/scoped_model.dart';

import '../const.dart';

class CarePlanModel extends Model {
  bool hasNoCarePlan = false;
  List<Questionnaire> questionnaires;
  List<Procedure> procedures;
  List<QuestionnaireResponse> questionnaireResponses;
  CarePlan carePlan;
  var error;
  bool isLoading = false;
  Patient patient;
  TreatmentCalendar treatmentCalendar;
  
  String _keycloakUserId;
  Map<String, QuestionnaireItem> _questionsByLinkId = new Map();

  CarePlanModel();

  void setUser(String keycloakUserId) {
    this._keycloakUserId = keycloakUserId;
    load();
  }

  static CarePlanModel of(BuildContext context) =>
      ScopedModel.of<CarePlanModel>(context);

  void load() {
    isLoading = true;
    notifyListeners();

    notifyOrError(_doLoad());
  }

  void notifyOrError(Future f) {
    f.then((value) {
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      this.error = error;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _doLoad() async {
    // don't need to reload patient if we already have it
    if (patient == null) {
      patient = await Repository.getPatient(_keycloakUserId);
    }
    return _loadCarePlan();
  }

  Future<void> _loadCarePlan() async {
    CarePlan carePlan = await Repository.getCarePlan(patient);
    if (carePlan == null) {
      hasNoCarePlan = true;
    } else {
      hasNoCarePlan = false;
      this.carePlan = carePlan;
      return _loadQuestionnaires();
    }
  }

  Future<void> _loadQuestionnaires() async {
    List<Future> futures = [
      Repository.getQuestionnaires(this.carePlan).then((var questionnaires) {
        this.questionnaires = questionnaires;
        _createQuestionMap();
      }),
      Repository.getProcedures(this.carePlan)
          .then((List<Procedure> procedures) {
        this.procedures = procedures;
      }),
      Repository.getQuestionnaireResponses(this.carePlan)
          .then((List<QuestionnaireResponse> responses) {
        this.questionnaireResponses = responses;
      })
    ];
    await Future.wait(futures);
    rebuildTreatmentPlan();
  }

  void rebuildTreatmentPlan() {
    treatmentCalendar =
        TreatmentCalendar.make(carePlan, procedures, questionnaireResponses);
  }

  void addDefaultCareplan() {
    notifyOrError(Repository.loadCarePlan("54").then((CarePlan plan) {
      CarePlan newPlan = CarePlan.fromTemplate(plan, patient);
      Repository.postCarePlan(newPlan).then((value) {
        carePlan = CarePlan.fromJson(jsonDecode(value.body));
        hasNoCarePlan = false;

        _loadQuestionnaires();
      });
    }));
  }

  Future postQuestionnaireResponse(QuestionnaireResponse response) async {
    Repository.postQuestionnaireResponse(response).then((value) => load());
  }

  void updateActivityFrequency(int activityIndex, int newFrequency) {
    carePlan.activity[activityIndex].detail.scheduledTiming.repeat.period =
        newFrequency;
    Repository.updateCarePlan(carePlan).then((value) => load());
  }

  void updateActivityDuration(int activityIndex, double newDuration) {
    carePlan.activity[activityIndex].detail.scheduledTiming.repeat.duration =
        newDuration;
    Repository.updateCarePlan(carePlan).then((value) => load());
  }

  QuestionnaireItem questionForLinkId(String linkId) {
    return _questionsByLinkId[linkId];
  }
  
  void _createQuestionMap() {
    _questionsByLinkId = new Map();
    for (Questionnaire questionnaire in this.questionnaires) {
      if (questionnaire.item != null) {
        for (QuestionnaireItem question in questionnaire.item) {
          addSelfAndChildren(question);
        }
      }
    }
  }
  
  addSelfAndChildren(QuestionnaireItem question) {
    _questionsByLinkId[question.linkId] = question;
    if (question.item != null) {
      for (QuestionnaireItem nestedQuestion in question.item) {
        addSelfAndChildren(nestedQuestion);
      }
    }
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
              e.questionnaireReference == response.questionnaireReference &&
              e.status == Status.Scheduled, orElse: () {
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
