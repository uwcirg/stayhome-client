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

  String get demoVersionBannerText {
    return Intl.message(
      'Demo version - not for clinical use.',
      name: 'demoVersionBannerText',
      desc: '',
      args: [],
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
      'Developed by the Clinical Informatics Research Group (CIRG) at University of Washington, 2019.',
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
      'login',
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
      'Sign up or Log in to access all functions',
      name: 'sign_up_or_log_in_to_access_all_functions',
      desc: '',
      args: [],
    );
  }

  String get not_now {
    return Intl.message(
      'guest user',
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
      'Add the default care plan for me',
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

  String get my_goals {
    return Intl.message(
      'My goals',
      name: 'my_goals',
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