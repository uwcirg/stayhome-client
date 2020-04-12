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

  String get about_stayhome {
    return Intl.message(
      'About StayHome',
      name: 'about_stayhome',
      desc: '',
      args: [],
    );
  }

  String get about_stayhome_info_text {
    return Intl.message(
      'The COVID-19 pandemic is straining existing public health processes and workflows. Many community members may be concerned about developing COVD-19. To meet this need we have developed StayHome, an app to help people who are staying home to minimize any risk they might present to others do things like track their symptoms and temperature, connect with relevant information and resources, and maintain a diary of people with whom they have had contact. We hope the app might also help people and public health connect more easily, when needed, in a situation where public health resources may be stretched thin.',
      name: 'about_stayhome_info_text',
      desc: '',
      args: [],
    );
  }

  String get read_more {
    return Intl.message(
      'Read More',
      name: 'read_more',
      desc: '',
      args: [],
    );
  }

  String get about_CIRG {
    return Intl.message(
      'About CIRG',
      name: 'about_CIRG',
      desc: '',
      args: [],
    );
  }

  String get support_COVID19 {
    return Intl.message(
      'Support during COVID-19',
      name: 'support_COVID19',
      desc: '',
      args: [],
    );
  }

  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  String get calender_history {
    return Intl.message(
      'Calendar & History',
      name: 'calender_history',
      desc: '',
      args: [],
    );
  }

  String get info_resource {
    return Intl.message(
      'Information & Resources',
      name: 'info_resource',
      desc: '',
      args: [],
    );
  }

  String get copied {
    return Intl.message(
      'Copied',
      name: 'copied',
      desc: '',
      args: [],
    );
  }

  String get copy_to_clipboard {
    return Intl.message(
      'Copy to clipboard',
      name: 'copy_to_clipboard',
      desc: '',
      args: [],
    );
  }

  String get done {
    return Intl.message(
      'done',
      name: 'done',
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

  String get firstname {
    return Intl.message(
      'First name',
      name: 'firstname',
      desc: '',
      args: [],
    );
  }

  String get lastname {
    return Intl.message(
      'Last name',
      name: 'lastname',
      desc: '',
      args: [],
    );
  }

  String get birthdate_hint_text {
    return Intl.message(
      'Enter date of birth (m/d/y)',
      name: 'birthdate_hint_text',
      desc: '',
      args: [],
    );
  }

  String get birthdate {
    return Intl.message(
      'Date of birth',
      name: 'birthdate',
      desc: '',
      args: [],
    );
  }

  String get clear_birthdate_text {
    return Intl.message(
      'Clear date of birth',
      name: 'clear_birthdate_text',
      desc: '',
      args: [],
    );
  }

  String get gender {
    return Intl.message(
      'Sex',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  String get decline_to_state {
    return Intl.message(
      'decline to state',
      name: 'decline_to_state',
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

  String get save {
    return Intl.message(
      'save',
      name: 'save',
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

  String get back_to_login_register {
    return Intl.message(
      'Back to login/register',
      name: 'back_to_login_register',
      desc: '',
      args: [],
    );
  }

  String get back_to_login {
    return Intl.message(
      'Back to login',
      name: 'back_to_login',
      desc: '',
      args: [],
    );
  }

  String get attempt_login_text {
    return Intl.message(
      'Attempt to log in...',
      name: 'attempt_login_text',
      desc: '',
      args: [],
    );
  }

  String get contact_us {
    return Intl.message(
      'Contact us/submit feedback',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  String get back {
    return Intl.message(
      'back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  String get no_FHIR_patient_record_text {
    return Intl.message(
      'You do not have a patient record in the FHIR database.',
      name: 'no_FHIR_patient_record_text',
      desc: '',
      args: [],
    );
  }

  String get no_data_to_show_text {
    return Intl.message(
      'No data to show yet. Start tracking and your data will show here.',
      name: 'no_data_to_show_text',
      desc: '',
      args: [],
    );
  }

  String get create_one {
    return Intl.message(
      'create one',
      name: 'create_one',
      desc: '',
      args: [],
    );
  }

  String get no_active_careplan_text {
    return Intl.message(
      'You have no active care plan.',
      name: 'no_active_careplan_text',
      desc: '',
      args: [],
    );
  }

  String get continue_to_resources {
    return Intl.message(
      'continue to resources',
      name: 'continue_to_resources',
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

  String get no_data {
    return Intl.message(
      'No data',
      name: 'no_data',
      desc: '',
      args: [],
    );
  }

  String get no_date {
    return Intl.message(
      'No date',
      name: 'no_date',
      desc: '',
      args: [],
    );
  }

  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  String get and {
    return Intl.message(
      'and',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  String get nothing_here {
    return Intl.message(
      'Nothing here',
      name: 'nothing_here',
      desc: '',
      args: [],
    );
  }

  String get no_content {
    return Intl.message(
      '<no content>',
      name: 'no_content',
      desc: '',
      args: [],
    );
  }

  String get dismiss {
    return Intl.message(
      'Dismiss',
      name: 'dismiss',
      desc: '',
      args: [],
    );
  }

  String get discard {
    return Intl.message(
      'discard',
      name: 'discard',
      desc: '',
      args: [],
    );
  }

  String get value_not_saved_text {
    return Intl.message(
      'This value will not be saved.',
      name: 'value_not_saved_text',
      desc: '',
      args: [],
    );
  }

  String get un_saved_alert_text {
    return Intl.message(
      'You have unsaved responses',
      name: 'un_saved_alert_text',
      desc: '',
      args: [],
    );
  }

  String get record_symptoms_and_temp {
    return Intl.message(
      'record symptoms & temp',
      name: 'record_symptoms_and_temp',
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

  String get communications {
    return Intl.message(
      'Communications',
      name: 'communications',
      desc: '',
      args: [],
    );
  }

  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  String get my_trends {
    return Intl.message(
      'My Trends',
      name: 'my_trends',
      desc: '',
      args: [],
    );
  }

  String get select_trend_text {
    return Intl.message(
      'Select a question to see trends',
      name: 'select_trend_text',
      desc: '',
      args: [],
    );
  }

  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  String get more_charts_text {
    return Intl.message(
      'There are more charts which aren\'t shown.',
      name: 'more_charts_text',
      desc: '',
      args: [],
    );
  }

  String get what_do_you_want_to_do {
    return Intl.message(
      'What do you want to do?',
      name: 'what_do_you_want_to_do',
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

  String get profile_email_validation_error_text {
    return Intl.message(
      'Leave blank or enter a valid email address',
      name: 'profile_email_validation_error_text',
      desc: '',
      args: [],
    );
  }

  String get profile_phone_hint_text {
    return Intl.message(
      'What is your phone number?',
      name: 'profile_phone_hint_text',
      desc: '',
      args: [],
    );
  }

  String get profile_phone_label_text {
    return Intl.message(
      'Cell/mobile Phone',
      name: 'profile_phone_label_text',
      desc: '',
      args: [],
    );
  }

  String get profile_phone_validation_error_text {
    return Intl.message(
      'Leave blank or enter a valid phone number',
      name: 'profile_phone_validation_error_text',
      desc: '',
      args: [],
    );
  }

  String get profile_create_text {
    return Intl.message(
      'Create profile',
      name: 'profile_create_text',
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
      'If you give us location information, we may make symptom, temperature and COVID-19 testing information available anonymously (no identifying information) to public health agencies responsible for those zip codes. You can provide a real location, even if you register with a fake email address and provide no other information. But that information (level of illness, location) may be useful for public health planning even if you can not be contacted.\n\nIf you enter your location, we can also personalize the information we give you about COVID-19 resources.',
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

  String get profile_location_title_text {
    return Intl.message(
      'Location',
      name: 'profile_location_title_text',
      desc: '',
      args: [],
    );
  }

  String get profile_info_prompt_text {
    return Intl.message(
      'Click to learn how Location information is used',
      name: 'profile_info_prompt_text',
      desc: '',
      args: [],
    );
  }

  String get profile_zipcode_hint_text {
    return Intl.message(
      'Where you spend most of your time',
      name: 'profile_zipcode_hint_text',
      desc: '',
      args: [],
    );
  }

  String get profile_home_zipcode_label_text {
    return Intl.message(
      'Home zip code',
      name: 'profile_home_zipcode_label_text',
      desc: '',
      args: [],
    );
  }

  String get profile_secondary_zipcode_hint_text {
    return Intl.message(
      'If you spend a lot of time in a different location (work, school, family, etc.)',
      name: 'profile_secondary_zipcode_hint_text',
      desc: '',
      args: [],
    );
  }

  String get profile_secondary_zipcode_label_text {
    return Intl.message(
      'Second zip code',
      name: 'profile_secondary_zipcode_label_text',
      desc: '',
      args: [],
    );
  }

  String get profile_zipcode_validation_error_text {
    return Intl.message(
      'Leave blank or enter a valid zip code',
      name: 'profile_zipcode_validation_error_text',
      desc: '',
      args: [],
    );
  }

  String get profile_contact_title_text {
    return Intl.message(
      'Contact Information',
      name: 'profile_contact_title_text',
      desc: '',
      args: [],
    );
  }

  String get profile_contact_info_prompt_text {
    return Intl.message(
      'Click to learn how Contact Information is used',
      name: 'profile_contact_info_prompt_text',
      desc: '',
      args: [],
    );
  }

  String get profile_preferred_contact_text {
    return Intl.message(
      'Preferred contact method',
      name: 'profile_preferred_contact_text',
      desc: '',
      args: [],
    );
  }

  String get profile_preferred_contact_voicecall_text {
    return Intl.message(
      'voice call',
      name: 'profile_preferred_contact_voicecall_text',
      desc: '',
      args: [],
    );
  }

  String get profile_preferred_contact_sms_text {
    return Intl.message(
      'text',
      name: 'profile_preferred_contact_sms_text',
      desc: '',
      args: [],
    );
  }

  String get profile_about_you_title_text {
    return Intl.message(
      'About You',
      name: 'profile_about_you_title_text',
      desc: '',
      args: [],
    );
  }

  String get profile_about_your_info_prompt_text {
    return Intl.message(
      'Click to learn how About You information is used',
      name: 'profile_about_your_info_prompt_text',
      desc: '',
      args: [],
    );
  }

  String get profile_updated_text {
    return Intl.message(
      'Profile updates saved',
      name: 'profile_updated_text',
      desc: '',
      args: [],
    );
  }

  String get profile_save_error_text {
    return Intl.message(
      'Error saving profile updates',
      name: 'profile_save_error_text',
      desc: '',
      args: [],
    );
  }

  String get profile_form_error_text {
    return Intl.message(
      'There has been an error while saving profile updates. Please try again.',
      name: 'profile_form_error_text',
      desc: '',
      args: [],
    );
  }

  String get springboard_record_symptom_text {
    return Intl.message(
      'record symptoms & temp',
      name: 'springboard_record_symptom_text',
      desc: '',
      args: [],
    );
  }

  String get springboard_cdc_symptom_checker_text {
    return Intl.message(
      'CDC symptom self-checker',
      name: 'springboard_cdc_symptom_checker_text',
      desc: '',
      args: [],
    );
  }

  String get springboard_enter_travel_exposure_text {
    return Intl.message(
      'enter exposure or travel',
      name: 'springboard_enter_travel_exposure_text',
      desc: '',
      args: [],
    );
  }

  String get springboard_record_COVID19_text {
    return Intl.message(
      'record COVID-19 testing',
      name: 'springboard_record_COVID19_text',
      desc: '',
      args: [],
    );
  }

  String get springboard_COVID19_resources_text {
    return Intl.message(
      'COVID-19 information & resources',
      name: 'springboard_COVID19_resources_text',
      desc: '',
      args: [],
    );
  }

  String get springboard_enter_pregnancy_text {
    return Intl.message(
      'identify at-risk conditions',
      name: 'springboard_enter_pregnancy_text',
      desc: '',
      args: [],
    );
  }

  String get springboard_update_profile_text {
    return Intl.message(
      'update profile & permissions',
      name: 'springboard_update_profile_text',
      desc: '',
      args: [],
    );
  }

  String get springboard_review_calendar_history_text {
    return Intl.message(
      'review calendar & history',
      name: 'springboard_review_calendar_history_text',
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

  String get form_error_text {
    return Intl.message(
      'Form has errors. Please scroll up and fix your entries.',
      name: 'form_error_text',
      desc: '',
      args: [],
    );
  }

  String get enter_temperature_text {
    return Intl.message(
      'Enter body temperature, in either °F or °C',
      name: 'enter_temperature_text',
      desc: '',
      args: [],
    );
  }

  String temperatureErrorMessage(dynamic minF, dynamic maxF, dynamic minC, dynamic maxC) {
    return Intl.message(
      'Enter a value between $minF and $maxF (°F) or $minC and $maxC (°C). This value will not be saved.',
      name: 'temperatureErrorMessage',
      desc: '',
      args: [minF, maxF, minC, maxC],
    );
  }

  String get decimal_validation_text {
    return Intl.message(
      'Please enter a valid decimal',
      name: 'decimal_validation_text',
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

  String get guest_home_text {
    return Intl.message(
      'StayHome includes a list of resources that gives you direct access to information sources that we believe to be accurate. We hope these sources will help you maintain your health, safety, and well-being during the COVID-19 outbreak.\n\nWithout an account, you can “continue” below to browse these sources, and follow the links they contain.\n\nIf you do decide to create an account, now or later, you can:\n\n- track your own symptoms and temperature\n- track travel and/or times you may have been exposed\n- record COVID-19 testing, which can help public health match your results with a way to contact you\n- record other information such as pregnancy and occupation that may help public health identify specific programs or protections for you.',
      name: 'guest_home_text',
      desc: '',
      args: [],
    );
  }

  String get review_terms_of_use_title {
    return Intl.message(
      'Review Terms of Use',
      name: 'review_terms_of_use_title',
      desc: '',
      args: [],
    );
  }

  String get terms_of_use_title {
    return Intl.message(
      'Terms of Use',
      name: 'terms_of_use_title',
      desc: '',
      args: [],
    );
  }

  String get terms_of_use {
    return Intl.message(
      'This app was built by the Clinical Informatics Research Group (CIRG), at the University of Washington, in order to benefit people, like you, who may be concerned about infection with Coronavirus (COVID-19). Or, who simply want to know how best to "stay home". Faculty, students, and staff at CIRG are doing this work to help people in our university, local, regional, state, national, and global communities.\n\nThe University of Washington (UW) is not responsible or liable for the accuracy or security of the information in the app. The UW did not develop the system, does not operate it, and has not endorsed it.\n\nThe privacy of your information is important to us. We do our best to keep our clinical information systems private and secure, but we are offering this application without any assurance or warranty.\n\nWe do not track GPS location information from your phone. We do not link your IP address to your information. We do use standard web analytic software (Matomo) to understand user patterns and will look at access logs if we suspect an attempt to compromise the security of our systems.\n\nYou can use this app without entering any personal information by skipping the prompts that ask for it. The system will be less able to personalize to your needs, but that\'s OK with us. We want you to use this app however you feel most comfortable doing so.\n\nThe Resources section of the app is available to anyone. You are welcome to use that feature without creating an account or logging in.\n\nIf you choose to create an account you will need to give us an email address, but you are welcome to use a fake email address. If your email is fake, you will not be able to recover your password, but everything else in the app will work the same. You can update your email address later, but you can\'t change your username.\n\nPlease look carefully at the Profile page. We explain on that page the uses of your personal information, such as an email address, a cell phone number, a zip code/postal code, etc. We ask that you either use accurate information in the profile, so we can personalize the app for you, or that you leave these fields blank.',
      name: 'terms_of_use',
      desc: '',
      args: [],
    );
  }

  String get name_not_entered {
    return Intl.message(
      '(name not entered)',
      name: 'name_not_entered',
      desc: '',
      args: [],
    );
  }

  String get cdc_symptom_checker {
    return Intl.message(
      'CDC symptom self-checker',
      name: 'cdc_symptom_checker',
      desc: '',
      args: [],
    );
  }

  String get cdc_symptom_checker_title_text {
    return Intl.message(
      'CDC Symptom Self-Checker',
      name: 'cdc_symptom_checker_title_text',
      desc: '',
      args: [],
    );
  }

  String get cdc_symptom_checker_continue_text {
    return Intl.message(
      'continue to CDC.gov',
      name: 'cdc_symptom_checker_continue_text',
      desc: '',
      args: [],
    );
  }

  String get cdc_symptom_checker_info_text {
    return Intl.message(
      'The CDC\'s Self-Checker is an interactive tool to help you make decisions and seek appropriate medical care for COVID-19.\n\nCurrently you need to enter your symptoms again when using Self-Checker, but a future version of StayHome will be able to send Self-Checker the symptoms you’ve already recorded (with your permission).',
      name: 'cdc_symptom_checker_info_text',
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