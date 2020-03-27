/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S(this.localeName);
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S(localeName);
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  final String localeName;

  String demoVersionBannerText(dynamic deploymentType) {
    return Intl.message(
      'This is a $deploymentType system - not for real data.',
      name: 'demoVersionBannerText',
      desc: '',
      args: [deploymentType],
    );
  }

  String get hello {
    return Intl.message(
      'Hello!',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  String versionString(dynamic version) {
    return Intl.message(
      'Version $version',
      name: 'versionString',
      desc: '',
      args: [version],
    );
  }

  String get developedByCIRG {
    return Intl.message(
      'Developed by the Clinical Informatics Research Group (CIRG) at University of Washington, 2019-2020.',
      name: 'developedByCIRG',
      desc: '',
      args: [],
    );
  }

  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  String get logout {
    return Intl.message(
      'logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  String get login {
    return Intl.message(
      'login / register',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  String get buttonPushText {
    return Intl.message(
      'You have pushed the button this many times:',
      name: 'buttonPushText',
      desc: '',
      args: [],
    );
  }

  String get languageName {
    return Intl.message(
      'English (EN)',
      name: 'languageName',
      desc: '',
      args: [],
    );
  }

  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  String time_left_until_token_expiration(dynamic timeLeftInSeconds) {
    return Intl.message(
      'Time left until token expiration: $timeLeftInSeconds seconds',
      name: 'time_left_until_token_expiration',
      desc: '',
      args: [timeLeftInSeconds],
    );
  }

  String get plan {
    return Intl.message(
      'Calendar',
      name: 'plan',
      desc: '',
      args: [],
    );
  }

  String get progress__insights {
    return Intl.message(
      'Check progress',
      name: 'progress__insights',
      desc: '',
      args: [],
    );
  }

  String get devices {
    return Intl.message(
      'Devices',
      name: 'devices',
      desc: '',
      args: [],
    );
  }

  String get learning_center {
    return Intl.message(
      'Learning center & Help',
      name: 'learning_center',
      desc: '',
      args: [],
    );
  }

  String get contact__community {
    return Intl.message(
      'Contact',
      name: 'contact__community',
      desc: '',
      args: [],
    );
  }

  String get session_expired_please_log_in_again {
    return Intl.message(
      'Session expired, please log in again.',
      name: 'session_expired_please_log_in_again',
      desc: '',
      args: [],
    );
  }

  String get sign_up_or_log_in_to_access_all_functions {
    return Intl.message(
      'Log in to access all functions',
      name: 'sign_up_or_log_in_to_access_all_functions',
      desc: '',
      args: [],
    );
  }

  String get not_now {
    return Intl.message(
      'continue without logging in',
      name: 'not_now',
      desc: '',
      args: [],
    );
  }

  String get vfit_faq {
    return Intl.message(
      'vFit FAQ',
      name: 'vfit_faq',
      desc: '',
      args: [],
    );
  }

  String get womens_health_resources {
    return Intl.message(
      'Women\'s Health Resources',
      name: 'womens_health_resources',
      desc: '',
      args: [],
    );
  }

  String get testimonials {
    return Intl.message(
      'Testimonials',
      name: 'testimonials',
      desc: '',
      args: [],
    );
  }

  String get timeFormat {
    return Intl.message(
      'h:mm:ss aaa',
      name: 'timeFormat',
      desc: '',
      args: [],
    );
  }

  String battery_level(dynamic device) {
    return Intl.message(
      '$device% charged',
      name: 'battery_level',
      desc: '',
      args: [device],
    );
  }

  String last_synced_date(dynamic date, dynamic time) {
    return Intl.message(
      'Last synced: $date at $time',
      name: 'last_synced_date',
      desc: '',
      args: [date, time],
    );
  }

  String get rename {
    return Intl.message(
      'Rename',
      name: 'rename',
      desc: '',
      args: [],
    );
  }

  String get forget {
    return Intl.message(
      'Forget',
      name: 'forget',
      desc: '',
      args: [],
    );
  }

  String get more_info {
    return Intl.message(
      'More info',
      name: 'more_info',
      desc: '',
      args: [],
    );
  }

  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  String get activity {
    return Intl.message(
      'Activity',
      name: 'activity',
      desc: '',
      args: [],
    );
  }

  String get frequency {
    return Intl.message(
      'Frequency:',
      name: 'frequency',
      desc: '',
      args: [],
    );
  }

  String frequency_with_contents(dynamic number, dynamic unit) {
    return Intl.message(
      'Once every $number $unit',
      name: 'frequency_with_contents',
      desc: '',
      args: [number, unit],
    );
  }

  String duration_duration_durationunit(dynamic duration, dynamic durationUnit) {
    return Intl.message(
      '$duration $durationUnit',
      name: 'duration_duration_durationunit',
      desc: '',
      args: [duration, durationUnit],
    );
  }

  String get duration {
    return Intl.message(
      'Duration:',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  String get treatment_calendar {
    return Intl.message(
      'Treatment Calendar',
      name: 'treatment_calendar',
      desc: '',
      args: [],
    );
  }

  String get my_treatment_plan {
    return Intl.message(
      'My Treatment Plan',
      name: 'my_treatment_plan',
      desc: '',
      args: [],
    );
  }

  String get you_have_no_active_pelvic_floor_management_careplan {
    return Intl.message(
      'You have no active care plan.',
      name: 'you_have_no_active_pelvic_floor_management_careplan',
      desc: '',
      args: [],
    );
  }

  String get add_the_default_careplan_for_me {
    return Intl.message(
      'add the default care plan for me',
      name: 'add_the_default_careplan_for_me',
      desc: '',
      args: [],
    );
  }

  String get visit_our_facebook_page {
    return Intl.message(
      'Visit our Facebook Page',
      name: 'visit_our_facebook_page',
      desc: '',
      args: [],
    );
  }

  String get read_our_blog {
    return Intl.message(
      'Read our Blog',
      name: 'read_our_blog',
      desc: '',
      args: [],
    );
  }

  String get patient_resource_id {
    return Intl.message(
      'Patient Resource ID',
      name: 'patient_resource_id',
      desc: '',
      args: [],
    );
  }

  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  String get what_is_your_name {
    return Intl.message(
      'What is your name?',
      name: 'what_is_your_name',
      desc: '',
      args: [],
    );
  }

  String get what_is_your_email_address {
    return Intl.message(
      'What is your email address?',
      name: 'what_is_your_email_address',
      desc: '',
      args: [],
    );
  }

  String get what_is_your_patient_resource_id {
    return Intl.message(
      'What is your Patient Resource ID?',
      name: 'what_is_your_patient_resource_id',
      desc: '',
      args: [],
    );
  }

  String get start_a_session {
    return Intl.message(
      'Start a session',
      name: 'start_a_session',
      desc: '',
      args: [],
    );
  }

  String get profile_introduction_help_text {
    return Intl.message(
      'If you create a profile and add certain types of information, you can see information more relevant to you, and you can convey information to public health that may help your community, or help you personally.\n\nBut remember, everything on this profile is optional. We’re more interested in having you able to use the system than in having you worry about us collecting information, or keeping it safe. That said, each item on this page has a use, and you can always come back and update it later.',
      name: 'profile_introduction_help_text',
      desc: '',
      args: [],
    );
  }

  String get profile_location_help_text {
    return Intl.message(
      'If you give us location information, we may make symptom temperature and COVID-19 testing information available anonymously (no identifying information) to public health agencies responsible for those zip codes. You can provide a real location, even if you register with a fake email address and provide no other information. But that information (level of illness, location) may be useful for public health planning even if you can not be contacted.\n\nIf you enter your location, we can also personalize the information we give you about COVID-19 resources.',
      name: 'profile_location_help_text',
      desc: '',
      args: [],
    );
  }

  String get profile_contact_info_help_text {
    return Intl.message(
      'If you provide your email, phone, or both, then we can make that info available to the public health agency responsible for your area, and we or they can contact you if needed. You will only be contacted if there is a specific reason to do so, one that we or the public health agency(s) believe to be in your best interest.\n\nIf you chose to set up your account with a fake email, you may provide us with a real one here, so we may contact you. But, doing so will not change your username. Likewise, if you used one email as a username when setting up your account, but would prefer a different email as your contact email, you can enter it here, but it will not change your username.',
      name: 'profile_contact_info_help_text',
      desc: '',
      args: [],
    );
  }

  String get profile_identifying_info_help_text {
    return Intl.message(
      'If you **do provide** an email and/or phone number, we\'d like to know who we are speaking with, if we do have a need to contact you. We’d also appreciate it if you\'d include sex and date of birth as those are standard ways of ensuring that the right person\'s medication information gets attached to the correct clinic, testing, or hospital records.\n\nIf you **have not provided** location or contact information, it would still be helpful if you could let us know your sex, the year, and perhaps the month of your birth (you can enter a fake day, or month, if you want). Patterns of illness by age, sex, and location can be critical in helping public health shape an effective response.',
      name: 'profile_identifying_info_help_text',
      desc: '',
      args: [],
    );
  }

  String get loading_error_log_in_again {
    return Intl.message(
      'Loading error. Try logging out and in again.',
      name: 'loading_error_log_in_again',
      desc: '',
      args: [],
    );
  }

  String get my_goals {
    return Intl.message(
      'My goals',
      name: 'my_goals',
      desc: '',
      args: [],
    );
  }

  String get welcome {
    return Intl.message(
      'Thank you and welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale('de', ''), Locale('mn', ''), Locale('en', ''),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}