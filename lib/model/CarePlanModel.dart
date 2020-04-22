/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:map_app_flutter/KeycloakAuth.dart';
import 'package:map_app_flutter/config/AppConfig.dart';
import 'package:map_app_flutter/fhir/Exception.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/map_app_code_system.dart';
import 'package:map_app_flutter/services/Repository.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simple_auth/simple_auth.dart';

class CarePlanModel extends Model {
  List<Questionnaire> questionnaires;
  List<Procedure> procedures;
  List<QuestionnaireResponse> questionnaireResponses;
  CarePlan carePlan;
  var error;
  bool isLoading = false;
  Patient patient;
  TreatmentCalendar treatmentCalendar;
  DataSharingConsents consents;

  KeycloakAuth _auth;

  bool isFirstTimeUser;

  OAuthApi get _api => _auth?.api;
  String _keycloakUserId;
  String _keycloakSystem;
  String _careplanTemplateRef;
  Map<String, QuestionnaireItem> _questionsByLinkId = new Map();

  List<DocumentReference> infoLinks;

  List<Communication> communications;

  List<Communication> get activeCommunications => communications != null
      ? communications
          .where((Communication c) => c.status == CommunicationStatus.in_progress)
          .toList()
      : [];

  List<Communication> get nonActiveCommunications => communications != null
      ? communications
          .where((Communication c) => c.status != CommunicationStatus.in_progress)
          .toList()
      : [];

  bool get hasNoPatient => patient == null;

  bool get hasNoCarePlan => carePlan == null;

  bool get hasNoUser => _keycloakUserId == null;

  CarePlanModel(this._careplanTemplateRef, this._keycloakSystem) {
    // default auth object - should be replaced with user action login/guest user
    this._auth = KeycloakAuth(AppConfig.issuerUrl, AppConfig.clientSecret, AppConfig.clientId);
  }

  void setUserAndAuthToken(String keycloakUserId, KeycloakAuth auth) {
    this._keycloakUserId = keycloakUserId;
    this._auth = auth;
    load();
  }

  void setGuestUser(KeycloakAuth auth) {
    this._auth = auth;
    loadResourceLinks();
  }

  static CarePlanModel of(BuildContext context) {
    return ScopedModel.of<CarePlanModel>(context);
  }

  /// This method is asynchronouos and is thus reserved for the UI to call.
  void load() {
    loadThenNotifyOrError(_doLoad());
  }

  /// This should be called when the view should be rebuilt first to show the loading screen, then
  /// upon completion, with the error message or data view.
  void loadThenNotifyOrError(Future f) {
    isLoading = true;
    error = null;
    notifyListeners();

    f.then((value) {
      this.error = null;
      isLoading = false;
      notifyListeners();
    }).catchError((error, stacktrace) {
      if (error is Response) {
        print('${error.body}');
      } else {
        print('$error');
      }
      if (stacktrace != null) {
        print(stacktrace);
      }
      this.error = error;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _doLoad() async {
    if (hasNoUser) {
      // (re)load resource links even if there is no user
      loadResourceLinks();
      return Future.error("No user information. Please log in again.");
    }
    print("CarePlanModel - Auth site: ${_auth.site }");

    this.patient = await Repository.getPatient(_keycloakSystem, _keycloakUserId, _api);
    if (patient != null) {
      isFirstTimeUser = false;
      return _loadCarePlan();
    } else {
      // this means there is no matching patient in the database! create one.
      try {
        this.patient = await _addBlankPatient();
      } catch (e) {
        return Future.error("Failed to create patient record.");
      }
      if (patient != null) {
        print("Successfully created ${patient.reference}");
        isFirstTimeUser = true;
        if (_auth.site != null) {
          await _addConsentForSite(_auth.site);
        }
        return _loadCarePlan();
      } else {
        return Future.error("Returned patient was null");
      }
    }
  }

  Future<Consent> _addConsentForSite(String site) {
    Reference org = OrganizationReference.fromSiteString(site);
    if (org != null) {
      Consent c = Consent.from(patient, org, ConsentContentClass.all, ProvisionType.permit);
      print("Creating a consent object indicating permission for site: $site");
      return Repository.postConsent(c, _api);
    } else {
      return Future.value(null);
    }
  }

  Future<Patient> _addBlankPatient() async {
    if (hasNoUser) return Future.error("No user");
    Patient patient = Patient();
    patient.setKeycloakId(_keycloakSystem, _keycloakUserId);
    print("Creating a new patient.");
    return Repository.postPatient(patient, _api);
  }

  Future<void> _loadCarePlan() async {
    this.carePlan = await Repository.getCarePlan(patient, _careplanTemplateRef, _api);
    if (carePlan != null) {
      print("Found careplan: ${carePlan.reference}");
      await _loadCommunications();
      return _loadQuestionnaires();
    } else {
      print("no careplan");
      // this means there is no matching careplan in the database! create one.
      try {
        this.carePlan = await _addDefaultCarePlan();
      } catch (e) {
        var error;
        if (e is Response) {
          error = e.body;
        } else {
          error = e;
        }
        return Future.error("Failed to create careplan record: $error}");
      }

      if (carePlan != null) {
        print("Successfully created ${carePlan.reference}");
        // create the welcome message for new users as well.
        await _createNewUserMessage();
        return _loadQuestionnaires();
      } else {
        return Future.error("Returned careplan was null");
      }
    }
  }

  Future<void> _createNewUserMessage() async {
    Communication newUserMessage;
    try {
      newUserMessage = await _addNewUserWelcomeMessage();
    } catch (e) {
      return Future.error("Failed to create new user welcome message: $e");
    }
    if (newUserMessage != null) {
      print("Successfully created ${newUserMessage.reference}");
      this.communications = [newUserMessage];
    } else {
      return Future.error("Returned communication was null");
    }
  }

  Future<void> _loadCommunications() async {
    List<Communication> responses = await Repository.getCommunications(patient, _api);
    if (responses != null) {
      this.communications = responses;
      print("Loaded ${this.communications.length} communications");
    } else {
      return Future.error("Communications could not be loaded.");
    }
  }

  Future<void> _loadConsents() {
    return Repository.getConsents(patient, _api).then((List<Consent> responses) {
      this.consents = DataSharingConsents.from(responses);
    });
  }

  Future<void> _loadQuestionnaires() async {
    List<Future> futures = [
      Repository.getQuestionnaires(this.carePlan, _api).then((var questionnaires) {
        this.questionnaires = questionnaires;
        _createQuestionMap();
      }),
      Repository.getProcedures(this.carePlan, _api).then((List<Procedure> procedures) {
        this.procedures = procedures;
      }),
      Repository.getQuestionnaireResponses(this.carePlan, _api)
          .then((List<QuestionnaireResponse> responses) {
        this.questionnaireResponses = responses;
      }),
      Repository.getResourceLinks(_careplanTemplateRef, _api)
          .then((List<DocumentReference> responses) {
        this.infoLinks = responses;
      }),
      _loadConsents()
    ];
    return Future.wait(futures).then((value) => rebuildTreatmentPlan());
  }

  void loadResourceLinks() async {
    loadThenNotifyOrError(Repository.getResourceLinks(_careplanTemplateRef, _api)
        .then((List<DocumentReference> responses) {
      this.infoLinks = responses;
    }));
  }

  void rebuildTreatmentPlan() {
    treatmentCalendar = TreatmentCalendar.make(carePlan, procedures, questionnaireResponses);
  }

  Future<void> updatePatientResource(Patient patient) async {
    if (hasNoUser) return Future.error("No user");
    patient.setKeycloakId(_keycloakSystem, _keycloakUserId);
    patient = await Repository.postPatient(patient, _api);
    if (patient != null) {
      this.patient = patient;
    } else {
      return Future.error("Failed to post patient updates");
    }
  }

  void addDefaultCarePlan() {
    _addDefaultCarePlan().then((value) => load());
  }

  Future<CarePlan> _addDefaultCarePlan() async {
    if (hasNoUser) return Future.error("No user");
    if (hasNoPatient) return Future.error("No patient");

    print("Creating a new care plan. Loading template careplan $_careplanTemplateRef.");
    CarePlan carePlanTemplate;
    try {
      carePlanTemplate = await Repository.loadCarePlan(_careplanTemplateRef, _api);
      print("Loaded careplan ${carePlanTemplate.reference}.");
    } catch (e) {
      return Future.error("Could not load template care plan.");
    }

    CarePlan newPlan = CarePlan.fromTemplate(carePlanTemplate, patient);
    return await Repository.postCarePlan(newPlan, _api);
  }

  Future<Communication> _addNewUserWelcomeMessage() async {
    if (hasNoUser) return Future.error("No user");
    if (hasNoPatient) return Future.error("No patient");

    String templateId = AppConfig.newUserWelcomeMessageTemplateId;
    print("Creating the new user communication. Loading template Communication/$templateId.");
    Communication commTemplate;
    try {
      commTemplate = await Repository.loadCommunication(templateId, _api);
    } catch (e) {
      return Future.error("Could not load template communication.");
    }
    print("Loaded communication ${commTemplate.reference}");
    Communication newComm = Communication.fromTemplate(commTemplate, patient);
    return Repository.postCommunication(newComm, _api);
  }

  Future addCompletedSession(int minutes) async {
    Procedure treatmentSession = Procedure.treatmentSession(minutes, carePlan);
    return Repository.postCompletedSession(treatmentSession, _api).then((value) => load());
  }

  Future postQuestionnaireResponse(QuestionnaireResponse response) async {
    return Repository.postQuestionnaireResponse(response, _api).then((value) => load());
  }

  Future updateCommunication(Communication communication) async {
    return Repository.updateCommunication(communication, _api).then((value) => load());
  }

  void updateActivityFrequency(int activityIndex, double newFrequency) {
    carePlan.activity[activityIndex].detail.scheduledTiming.repeat.period = newFrequency;
    Repository.updateResource(carePlan, _api).then((value) => load());
  }

  void updateActivityDuration(int activityIndex, double newDuration) {
    carePlan.activity[activityIndex].detail.scheduledTiming.repeat.duration = newDuration;
    Repository.updateResource(carePlan, _api).then((value) => load());
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

  Questionnaire questionnaireForResponse(QuestionnaireResponse response) {
    return questionnaires?.firstWhere(
        (element) => element.id == response.questionnaire.split("/")[1],
        orElse: () => null);
  }

  Future<void> updateConsents() async {
    List<Consent> newConsents = consents.generateNewConsents(patient);

    return Future.wait(newConsents.map((Consent c) => Repository.postConsent(c, _api)).toList())
        .then((value) => _loadConsents());
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
      if (!applicableQuestionnaires.contains(response.questionnaire)) {
        continue;
      }

      DateTime day =
          DateTime(response.authored.year, response.authored.month, response.authored.day);
      List<TreatmentEvent> eventList = events.putIfAbsent(day, () => []);

      // find matching scheduled event
      TreatmentEvent event = eventList.firstWhere(
          (TreatmentEvent e) =>
              e.questionnaireReference == response.questionnaire &&
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
      if (activity.detail.scheduledTiming != null) {
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
      throw MalformedFhirResourceException(
          plan, "${plan.reference} must have period start and end");
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
          !activity.detail.instantiatesCanonical[0].startsWith(Questionnaire().resourceType)) {
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

enum EventType { Assessment, Treatment }
enum Status { Scheduled, Completed, Missed }

class ConsentGroup with MapMixin<Coding, ProvisionType> {
  Map<Coding, ProvisionType> _consents = Map();

  bool get shareSymptoms =>
      _consents[ConsentContentClass.symptomsTestingConditions] == ProvisionType.permit;

  set shareSymptoms(bool permit) => _consents[ConsentContentClass.symptomsTestingConditions] =
      permit ? ProvisionType.permit : ProvisionType.deny;

  bool get shareLocation => _consents[ConsentContentClass.location] == ProvisionType.permit;

  set shareLocation(bool permit) =>
      _consents[ConsentContentClass.location] = permit ? ProvisionType.permit : ProvisionType.deny;

  bool get shareContactInfo =>
      _consents[ConsentContentClass.contactInformation] == ProvisionType.permit;

  set shareContactInfo(bool permit) => _consents[ConsentContentClass.contactInformation] =
      permit ? ProvisionType.permit : ProvisionType.deny;

  bool get shareAll => _consents[ConsentContentClass.all] == ProvisionType.permit;

  set shareAll(bool permit) =>
      _consents[ConsentContentClass.all] = permit ? ProvisionType.permit : ProvisionType.deny;

  @override
  ProvisionType operator [](Object key) => _consents[key];

  @override
  void operator []=(Coding key, ProvisionType value) => _consents[key] = value;

  @override
  void clear() => _consents.clear();

  @override
  Iterable<Coding> get keys => _consents.keys;

  @override
  ProvisionType remove(Object key) => _consents.remove(key);
}

class DataSharingConsents with MapMixin<Reference, ConsentGroup> {
  List<Consent> _originalConsents = [];
  Map<Reference, ConsentGroup> _consents = Map();

  DataSharingConsents();

  void reset() {
    _initFrom(_originalConsents);
  }

  void _initFrom(List<Consent> consents) {
    _consents = Map();
    _originalConsents = consents.map((e) => e.toJson()).map((e) => Consent.fromJson(e)).toList();
    if (consents == null) return;
    consents.sort((Consent a, Consent b) {
      return a.provision.period.start.compareTo(b.provision.period.start);
    });
    consents.forEach((Consent consent) {
      Map contentCategories =
          _consents.putIfAbsent(consent.organization.first, () => ConsentGroup());
      Coding contentClass = consent.provision.provisionClass.first;
      contentCategories.putIfAbsent(contentClass, () => consent.provision.type);
    });
  }

  DataSharingConsents.from(List<Consent> consents) {
    _initFrom(consents);
  }

  List<Consent> generateNewConsents(Patient patient) {
    List<Consent> newConsents = [];
    _consents.forEach((Reference org, Map<Coding, ProvisionType> orgConsents) {
      orgConsents.forEach((Coding contentClass, ProvisionType type) {
        ProvisionType existingProvisionType = _originalConsents
            .firstWhere((Consent consent) {
              return consent.organization.contains(org) &&
                  consent.provision.provisionClass.contains(contentClass);
            }, orElse: () => null)
            ?.provision
            ?.type;
        if (existingProvisionType == null || existingProvisionType != type) {
          newConsents.add(Consent.from(patient, org, contentClass, type));
        }
      });
    });
    return newConsents;
  }

  @override
  ConsentGroup operator [](Object key) => _consents[key];

  @override
  void operator []=(Reference key, ConsentGroup value) => _consents[key] = value;

  @override
  void clear() => _consents.clear();

  @override
  Iterable<Reference> get keys => _consents.keys;

  @override
  ConsentGroup remove(Object key) => _consents.remove(key);
}
