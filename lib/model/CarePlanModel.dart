/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/fhir/Exception.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/services/Repository.dart';
import 'package:scoped_model/scoped_model.dart';

import '../const.dart';

class CarePlanModel extends Model {
  List<Questionnaire> questionnaires;
  List<Procedure> procedures;
  List<QuestionnaireResponse> questionnaireResponses;
  CarePlan carePlan;
  var error;
  bool isLoading = false;
  Patient patient;
  TreatmentCalendar treatmentCalendar;
  Goals goals;

  String _authToken;
  String _keycloakUserId;
  String _keycloakSystem;
  String _careplanTemplateRef;
  Map<String, QuestionnaireItem> _questionsByLinkId = new Map();

  List<DocumentReference> infoLinks;

  bool get hasNoPatient => patient == null;

  bool get hasNoCarePlan => carePlan == null;

  CarePlanModel(this._careplanTemplateRef, this._keycloakSystem) {
    goals = new Goals();
  }

  void setUserAndAuthToken(String keycloakUserId, String authToken) {
    this._keycloakUserId = keycloakUserId;
    this._authToken = authToken;
    load();
  }

  void setGuestUser() {
    isLoading = true;
    error = null;
    notifyListeners();

    loadResourceLinks();
  }

  static CarePlanModel of(BuildContext context) => ScopedModel.of<CarePlanModel>(context);

  void load() {
    isLoading = true;
    error = null;
    notifyListeners();

    notifyOrError(_doLoad());
  }

  void notifyOrError(Future f) {
    f.then((value) {
      this.error = null;
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      print(error);
      this.error = error;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _doLoad() async {
    this.patient = await Repository.getPatient(_keycloakSystem, _keycloakUserId, _authToken);
    if (patient != null) {
      return _loadCarePlan();
    }
  }

  Future<void> _loadCarePlan() async {
    this.carePlan = await Repository.getCarePlan(patient, _careplanTemplateRef, _authToken);
    if (carePlan != null) {
      return _loadQuestionnaires();
    }
  }

  Future<void> _loadQuestionnaires() async {
    List<Future> futures = [
      Repository.getQuestionnaires(this.carePlan, _authToken).then((var questionnaires) {
        this.questionnaires = questionnaires;
        _createQuestionMap();
      }),
      Repository.getProcedures(this.carePlan, _authToken).then((List<Procedure> procedures) {
        this.procedures = procedures;
      }),
      Repository.getQuestionnaireResponses(this.carePlan, _authToken)
          .then((List<QuestionnaireResponse> responses) {
        this.questionnaireResponses = responses;
      }),
      Repository.getResourceLinks(_careplanTemplateRef, _authToken).then((List<DocumentReference> responses) {
        this.infoLinks = responses;
      })
    ];
    return Future.wait(futures).then((value) => rebuildTreatmentPlan());
  }

  void loadResourceLinks() async {
    notifyOrError(
        Repository.getResourceLinks(_careplanTemplateRef, _authToken).then((List<DocumentReference> responses) {
      this.infoLinks = responses;
    }));
  }

  void rebuildTreatmentPlan() {
    treatmentCalendar = TreatmentCalendar.make(carePlan, procedures, questionnaireResponses);
  }

  Future updatePatientResource(Patient patient) async {
    this.patient = patient;
    this.patient.setKeycloakId(_keycloakSystem, _keycloakUserId);
    return Repository.postPatient(this.patient, _authToken).then((value) => load());
  }

  Future addDefaultCareplan() async {
    notifyOrError(Repository.loadCarePlan(_careplanTemplateRef, _authToken).then((CarePlan plan) {
      CarePlan newPlan = CarePlan.fromTemplate(plan, patient);
      return Repository.postCarePlan(newPlan, _authToken).then((value) => load());
    }));
  }

  Future addCompletedSession(int minutes) async {
    Procedure treatmentSession = Procedure.treatmentSession(minutes, carePlan);
    return Repository.postCompletedSession(treatmentSession, _authToken).then((value) => load());
  }

  Future postQuestionnaireResponse(QuestionnaireResponse response) async {
    return Repository.postQuestionnaireResponse(response, _authToken).then((value) => load());
  }

  void updateActivityFrequency(int activityIndex, double newFrequency) {
    carePlan.activity[activityIndex].detail.scheduledTiming.repeat.period = newFrequency;
    Repository.updateCarePlan(carePlan, _authToken).then((value) => load());
  }

  void updateActivityDuration(int activityIndex, double newDuration) {
    carePlan.activity[activityIndex].detail.scheduledTiming.repeat.duration = newDuration;
    Repository.updateCarePlan(carePlan, _authToken).then((value) => load());
  }

  QuestionnaireItem questionForLinkId(String linkId) {
    return _questionsByLinkId[linkId];
  }

  void _createQuestionMap() {
    _questionsByLinkId = new Map();
    for (Questionnaire questionnaire in this.questionnaires) {
      if (questionnaire.item != null) {
        for (QuestionnaireItem question in questionnaire.item) {
          _addQuestionnaireItemAndItsChildren(question);
        }
      }
    }
  }

  void _addQuestionnaireItemAndItsChildren(QuestionnaireItem question) {
    _questionsByLinkId[question.linkId] = question;
    if (question.item != null) {
      for (QuestionnaireItem nestedQuestion in question.item) {
        _addQuestionnaireItemAndItsChildren(nestedQuestion);
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
      DateTime procedureDate = procedure.performedDateTime;
      if (procedureDate == null && procedure.performedPeriod != null) {
        procedureDate = procedure.performedPeriod.end;
      }
      if (procedureDate == null) {
        print("No date for procedure ${procedure.reference}! Skipping.");
        continue;
      }
      // Use round days for calendar purposes so all events for one day fall into one datetime key
      procedureDate = new DateTime(procedureDate.year, procedureDate.month, procedureDate.day);

      // get the list of events at this date. If the date doesn't exist, create a new list for the date and return it.
      List<TreatmentEvent> eventList = events.putIfAbsent(procedureDate, () => []);

      // find matching scheduled event
      TreatmentEvent event =
          eventList.firstWhere((TreatmentEvent e) => e.code == procedure.code, orElse: () => null);

      if (event != null) {
        event.updateStatus(procedure.status);
      } else {
        eventList.add(TreatmentEvent.fromProcedure(procedure));
      }
    }
  }

  /// If there is a matching scheduled event, update the status; otherwise,
  /// add a new event for this activity instance.
  void addAssessmentInstances(CarePlan plan, List<QuestionnaireResponse> responses) {
    if (responses == null || responses.length == 0) return;
    List<String> applicableQuestionnaires = plan.getAllQuestionnaireReferences();

    for (QuestionnaireResponse response in responses) {
      if (!applicableQuestionnaires.contains(response.questionnaireReference)) {
        continue;
      }

      DateTime day =
          DateTime(response.authored.year, response.authored.month, response.authored.day);
      List<TreatmentEvent> eventList = events.putIfAbsent(day, () => []);

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
      double every = activity.detail.scheduledTiming.repeat.period;
      TreatmentEvent event = TreatmentEvent.scheduledEventForActivity(activity);
      addScheduledTreatmentEvents(scheduledPeriod, every, event);
    }
  }

  Period getScheduledPeriod(CarePlan plan, Activity activity) {
    Period scheduledPeriod;
    if (activity.detail.scheduledPeriod != null &&
        activity.detail.scheduledPeriod.start != null &&
        activity.detail.scheduledPeriod.end != null) {
      scheduledPeriod = activity.detail.scheduledPeriod;
    } else if (plan.period != null && plan.period.start != null && plan.period.end != null) {
      scheduledPeriod = plan.period;
    } else {
      throw MalformedFhirResourceException(plan,
          "Either ${plan.reference} or the containing activity with code ${FhirConstants.SNOMED_PELVIC_FLOOR_EXERCISES} must have period start and end");
    }
    return scheduledPeriod;
  }

  void addScheduledTreatmentEvents(Period period, double everyNumberOfDays, TreatmentEvent event) {
    Duration interval;
    if (everyNumberOfDays % 1 != 0) {
      interval = Duration(hours: (everyNumberOfDays * 24).round());
    } else {
      interval = Duration(hours: everyNumberOfDays.round() * 24);
    }
    var date = period.start;
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    while (date.isBefore(period.end)) {
      // add it to the same day on the calendar as all other events for that day
      DateTime dayOfDate = DateTime(date.year, date.month, date.day);
      // don't add scheduled events before today
      if (!dayOfDate.isBefore(today)) {
        List<TreatmentEvent> dateEvents = events.putIfAbsent(dayOfDate, () => []);
        var treatmentEvent = TreatmentEvent.from(event);
        dateEvents.add(treatmentEvent);
      }
      date = date.add(interval);
    }
  }
}

class TreatmentEvent {
  final EventType eventType;
  Status status;
  CodeableConcept code;
  String questionnaireReference;

  TreatmentEvent(this.eventType, this.status, this.code, this.questionnaireReference);

  factory TreatmentEvent.fromProcedure(Procedure procedure) {
    TreatmentEvent e = TreatmentEvent(EventType.Treatment, null, procedure.code, null);
    e.updateStatus(procedure.status);
    return e;
  }

  factory TreatmentEvent.fromQuestionnaireResponse(QuestionnaireResponse questionnaireResponse) {
    TreatmentEvent e =
        TreatmentEvent(EventType.Assessment, null, null, questionnaireResponse.reference);
    e.updateStatus(questionnaireResponse.status);
    return e;
  }

  TreatmentEvent.from(TreatmentEvent event)
      : this(event.eventType, event.status, event.code, event.questionnaireReference);

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
      return TreatmentEvent(EventType.Treatment, Status.Scheduled, activity.detail.code, null);
    } else {
      // assume a questionnaire
      if (activity.detail.instantiatesCanonical == null ||
          activity.detail.instantiatesCanonical.length > 1 ||
          !activity.detail.instantiatesCanonical[0].startsWith(Questionnaire.resourceTypeName)) {
        throw MalformedFhirResourceException(
            activity,
            "Activity should have exactly one "
            "Questionnaire listed in its Detail's instantiatesCanonical list "
            "if it refers to a questionnaire.");
      }
      return TreatmentEvent(
          EventType.Assessment, Status.Scheduled, null, activity.detail.instantiatesCanonical[0]);
    }
  }
}

class Goals {
  Map<HealthIssue, int> concerns;
  Map<HealthIssue, SessionGoal> goals;

  Goals() {
    concerns = new Map();
    concerns.putIfAbsent(HealthIssue.Bladder, () => -1);
    concerns.putIfAbsent(HealthIssue.Dryness, () => -1);
    concerns.putIfAbsent(HealthIssue.Sexual, () => -1);
    goals = new Map();
    goals.putIfAbsent(HealthIssue.Bladder, () => null);
    goals.putIfAbsent(HealthIssue.Dryness, () => null);
    goals.putIfAbsent(HealthIssue.Sexual, () => null);
  }
}

class SessionGoal {
  final String _name;

  const SessionGoal(this._name);

  static const SessionGoal Wellness = SessionGoal("Wellness");
  static const SessionGoal Maintenance = SessionGoal("Maintenance");

  @override
  String toString() {
    return _name;
  }
}

class HealthIssue {
  final String name;
  final String image;

  const HealthIssue(this.name, this.image);

  static const HealthIssue Bladder = const HealthIssue("Bladder", "assets/icons/bladder.png");
  static const HealthIssue Dryness = const HealthIssue("Dryness", "assets/icons/uterus.png");
  static const HealthIssue Sexual = const HealthIssue("Sexual", "assets/icons/heart.png");
}

enum EventType { Assessment, Treatment }
enum Status { Scheduled, Completed, Missed }
