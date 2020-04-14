// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(deploymentType) => "This is a ${deploymentType} system - not for real data.";

  static m1(duration, durationUnit) => "${duration} ${durationUnit}";

  static m2(number, unit) => "Once every ${number} ${unit}";

  static m4(text) => "System Announcement ${text}";

  static m5(minF, maxF, minC, maxC) => "Enter a value between ${minF} and ${maxF} (°F) or ${minC} and ${maxC} (°C). This value will not be saved.";

  static m3(version) => "Version ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("About"),
    "about_CIRG" : MessageLookupByLibrary.simpleMessage("About CIRG"),
    "about_stayhome" : MessageLookupByLibrary.simpleMessage("About StayHome"),
    "about_stayhome_info_text" : MessageLookupByLibrary.simpleMessage("The COVID-19 pandemic is straining existing public health processes and workflows. Many community members may be concerned about developing COVID-19. To meet this need we have developed StayHome, an app to help people who are staying home to minimize any risk they might present to others do things like track their symptoms and temperature, connect with relevant information and resources, and maintain a diary of people with whom they have had contact. We hope the app might also help people and public health connect more easily, when needed, in a situation where public health resources may be stretched thin."),
    "active" : MessageLookupByLibrary.simpleMessage("Active"),
    "add_the_default_careplan_for_me" : MessageLookupByLibrary.simpleMessage("add the default care plan for me"),
    "and" : MessageLookupByLibrary.simpleMessage("and"),
    "attempt_login_text" : MessageLookupByLibrary.simpleMessage("Attempt to log in..."),
    "back" : MessageLookupByLibrary.simpleMessage("back"),
    "back_to_login" : MessageLookupByLibrary.simpleMessage("Back to login"),
    "back_to_login_register" : MessageLookupByLibrary.simpleMessage("Back to login/register"),
    "birthdate" : MessageLookupByLibrary.simpleMessage("Date of birth"),
    "birthdate_hint_text" : MessageLookupByLibrary.simpleMessage("Enter date of birth (m/d/y)"),
    "calendar" : MessageLookupByLibrary.simpleMessage("Calendar"),
    "calender_history" : MessageLookupByLibrary.simpleMessage("Calendar & History"),
    "cancel" : MessageLookupByLibrary.simpleMessage("cancel"),
    "cdc_symptom_checker" : MessageLookupByLibrary.simpleMessage("CDC symptom self-checker"),
    "cdc_symptom_checker_continue_text" : MessageLookupByLibrary.simpleMessage("continue to CDC.gov"),
    "cdc_symptom_checker_info_text" : MessageLookupByLibrary.simpleMessage("The CDC\'s Self-Checker is an interactive tool to help you make decisions and seek appropriate medical care for COVID-19.\n\nCurrently you need to enter your symptoms again when using Self-Checker, but a future version of StayHome will be able to send Self-Checker the symptoms you’ve already recorded (with your permission)."),
    "cdc_symptom_checker_title_text" : MessageLookupByLibrary.simpleMessage("CDC Symptom Self-Checker"),
    "clear_birthdate_text" : MessageLookupByLibrary.simpleMessage("Clear date of birth"),
    "communications" : MessageLookupByLibrary.simpleMessage("Communications"),
    "completed" : MessageLookupByLibrary.simpleMessage("Completed"),
    "contact_us" : MessageLookupByLibrary.simpleMessage("Contact us/submit feedback"),
    "continue_to_resources" : MessageLookupByLibrary.simpleMessage("continue to resources"),
    "copied" : MessageLookupByLibrary.simpleMessage("Copied"),
    "copy_to_clipboard" : MessageLookupByLibrary.simpleMessage("Copy to clipboard"),
    "create_one" : MessageLookupByLibrary.simpleMessage("create one"),
    "decimal_validation_text" : MessageLookupByLibrary.simpleMessage("Please enter a valid decimal"),
    "decline_to_state" : MessageLookupByLibrary.simpleMessage("decline to state"),
    "demoVersionBannerText" : m0,
    "developedByCIRG" : MessageLookupByLibrary.simpleMessage("Developed by the Clinical Informatics Research Group (CIRG) at University of Washington, 2019-2020."),
    "discard" : MessageLookupByLibrary.simpleMessage("discard"),
    "dismiss" : MessageLookupByLibrary.simpleMessage("Dismiss"),
    "done" : MessageLookupByLibrary.simpleMessage("done"),
    "duration" : MessageLookupByLibrary.simpleMessage("Duration:"),
    "duration_duration_durationunit" : m1,
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "enter_temperature_text" : MessageLookupByLibrary.simpleMessage("Enter body temperature, in either °F or °C"),
    "firstname" : MessageLookupByLibrary.simpleMessage("First name"),
    "form_error_text" : MessageLookupByLibrary.simpleMessage("Form has errors. Please scroll up and fix your entries."),
    "frequency" : MessageLookupByLibrary.simpleMessage("Frequency:"),
    "frequency_with_contents" : m2,
    "gender" : MessageLookupByLibrary.simpleMessage("Sex"),
    "guest_home_text" : MessageLookupByLibrary.simpleMessage("StayHome includes a list of resources that gives you direct access to information sources that we believe to be accurate. We hope these sources will help you maintain your health, safety, and well-being during the COVID-19 outbreak.\n\nWithout an account, you can “continue” below to browse these sources, and follow the links they contain.\n\nIf you do decide to create an account, now or later, you can:\n\n- track your own symptoms and temperature\n- track travel and/or times you may have been exposed\n- record COVID-19 testing, which can help public health match your results with a way to contact you\n- record other information such as pregnancy and occupation that may help public health identify specific programs or protections for you."),
    "history" : MessageLookupByLibrary.simpleMessage("History"),
    "home" : MessageLookupByLibrary.simpleMessage("Home"),
    "info_resource" : MessageLookupByLibrary.simpleMessage("Information & Resources"),
    "languageName" : MessageLookupByLibrary.simpleMessage("English (EN)"),
    "lastname" : MessageLookupByLibrary.simpleMessage("Last name"),
    "loading_error_log_in_again" : MessageLookupByLibrary.simpleMessage("Loading error. Try logging out and in again."),
    "login" : MessageLookupByLibrary.simpleMessage("login / register"),
    "logout" : MessageLookupByLibrary.simpleMessage("Logout"),
    "more_charts_text" : MessageLookupByLibrary.simpleMessage("There are more charts which aren\'t shown."),
    "my_trends" : MessageLookupByLibrary.simpleMessage("My Trends"),
    "name_not_entered" : MessageLookupByLibrary.simpleMessage("(name not entered)"),
    "no_FHIR_patient_record_text" : MessageLookupByLibrary.simpleMessage("You do not have a patient record in the FHIR database."),
    "no_active_careplan_text" : MessageLookupByLibrary.simpleMessage("You have no active care plan."),
    "no_content" : MessageLookupByLibrary.simpleMessage("<no content>"),
    "no_data" : MessageLookupByLibrary.simpleMessage("No data"),
    "no_data_to_show_text" : MessageLookupByLibrary.simpleMessage("No data to show yet. Start tracking and your data will show here."),
    "no_date" : MessageLookupByLibrary.simpleMessage("No date"),
    "not_now" : MessageLookupByLibrary.simpleMessage("continue without logging in"),
    "nothing_here" : MessageLookupByLibrary.simpleMessage("Nothing here"),
    "or" : MessageLookupByLibrary.simpleMessage("or"),
    "profile" : MessageLookupByLibrary.simpleMessage("Profile"),
    "profile_about_you_title_text" : MessageLookupByLibrary.simpleMessage("About You"),
    "profile_about_your_info_prompt_text" : MessageLookupByLibrary.simpleMessage("Click to learn how About You information is used"),
    "profile_contact_info_help_text" : MessageLookupByLibrary.simpleMessage("If you provide your email, phone, or both, then we can make that info available to the public health agency responsible for your area, and we or they can contact you if needed. You will only be contacted if there is a specific reason to do so, one that we or the public health agency(s) believe to be in your best interest.\n\nIf you chose to set up your account with a fake email, you may provide us with a real one here, so we may contact you. But, doing so will not change your username. Likewise, if you used one email as a username when setting up your account, but would prefer a different email as your contact email, you can enter it here, but it will not change your username."),
    "profile_contact_info_prompt_text" : MessageLookupByLibrary.simpleMessage("Click to learn how Contact Information is used"),
    "profile_contact_title_text" : MessageLookupByLibrary.simpleMessage("Contact Information"),
    "profile_create_text" : MessageLookupByLibrary.simpleMessage("Create profile"),
    "profile_email_validation_error_text" : MessageLookupByLibrary.simpleMessage("Leave blank or enter a valid email address"),
    "profile_form_error_text" : MessageLookupByLibrary.simpleMessage("There has been an error while saving profile updates. Please try again."),
    "profile_home_zipcode_label_text" : MessageLookupByLibrary.simpleMessage("Home zip code"),
    "profile_identifying_info_help_text" : MessageLookupByLibrary.simpleMessage("If you **do provide** an email and/or phone number, we\'d like to know who we are speaking with, if we do have a need to contact you. We’d also appreciate it if you\'d include sex and date of birth as those are standard ways of ensuring that the right person\'s medication information gets attached to the correct clinic, testing, or hospital records.\n\nIf you **have not provided** location or contact information, it would still be helpful if you could let us know your sex, the year, and perhaps the month of your birth (you can enter a fake day, or month, if you want). Patterns of illness by age, sex, and location can be critical in helping public health shape an effective response."),
    "profile_info_prompt_text" : MessageLookupByLibrary.simpleMessage("Click to learn how Location information is used"),
    "profile_introduction_help_text" : MessageLookupByLibrary.simpleMessage("If you create a profile and add certain types of information, you can see information more relevant to you, and you can convey information to public health that may help your community, or help you personally.\n\nBut remember, everything on this profile is optional. We’re more interested in having you able to use the system than in having you worry about us collecting information, or keeping it safe. That said, each item on this page has a use, and you can always come back and update it later."),
    "profile_location_help_text" : MessageLookupByLibrary.simpleMessage("If you give us location information, we may make symptom, temperature and COVID-19 testing information available anonymously (no identifying information) to public health agencies responsible for those zip codes. You can provide a real location, even if you register with a fake email address and provide no other information. But that information (level of illness, location) may be useful for public health planning even if you can not be contacted.\n\nIf you enter your location, we can also personalize the information we give you about COVID-19 resources."),
    "profile_location_title_text" : MessageLookupByLibrary.simpleMessage("Location"),
    "profile_phone_hint_text" : MessageLookupByLibrary.simpleMessage("What is your phone number?"),
    "profile_phone_label_text" : MessageLookupByLibrary.simpleMessage("Cell/mobile Phone"),
    "profile_phone_validation_error_text" : MessageLookupByLibrary.simpleMessage("Leave blank or enter a valid phone number"),
    "profile_preferred_contact_sms_text" : MessageLookupByLibrary.simpleMessage("text"),
    "profile_preferred_contact_text" : MessageLookupByLibrary.simpleMessage("Preferred contact method"),
    "profile_preferred_contact_voicecall_text" : MessageLookupByLibrary.simpleMessage("voice call"),
    "profile_save_error_text" : MessageLookupByLibrary.simpleMessage("Error saving profile updates"),
    "profile_secondary_zipcode_hint_text" : MessageLookupByLibrary.simpleMessage("If you spend a lot of time in a different location (work, school, family, etc.)"),
    "profile_secondary_zipcode_label_text" : MessageLookupByLibrary.simpleMessage("Second zip code"),
    "profile_updated_text" : MessageLookupByLibrary.simpleMessage("Profile updates saved"),
    "profile_zipcode_hint_text" : MessageLookupByLibrary.simpleMessage("Where you spend most of your time"),
    "profile_zipcode_validation_error_text" : MessageLookupByLibrary.simpleMessage("Leave blank or enter a valid zip code"),
    "read_more" : MessageLookupByLibrary.simpleMessage("Read More"),
    "record_symptoms_and_temp" : MessageLookupByLibrary.simpleMessage("record symptoms & temp"),
    "review_terms_of_use_title" : MessageLookupByLibrary.simpleMessage("Review Terms of Use"),
    "save" : MessageLookupByLibrary.simpleMessage("save"),
    "select" : MessageLookupByLibrary.simpleMessage("Select"),
    "select_trend_text" : MessageLookupByLibrary.simpleMessage("Select a question to see trends"),
    "session_expired_please_log_in_again" : MessageLookupByLibrary.simpleMessage("Session expired, please log in again."),
    "sign_up_or_log_in_to_access_all_functions" : MessageLookupByLibrary.simpleMessage("Log in to access all functions"),
    "springboard_COVID19_resources_text" : MessageLookupByLibrary.simpleMessage("COVID-19 information & resources"),
    "springboard_cdc_symptom_checker_text" : MessageLookupByLibrary.simpleMessage("CDC symptom self-checker"),
    "springboard_enter_pregnancy_text" : MessageLookupByLibrary.simpleMessage("enter pregnancy, occupation, & possible risks"),
    "springboard_enter_travel_exposure_text" : MessageLookupByLibrary.simpleMessage("enter exposure or travel"),
    "springboard_record_COVID19_text" : MessageLookupByLibrary.simpleMessage("record COVID-19 testing"),
    "springboard_record_symptom_text" : MessageLookupByLibrary.simpleMessage("record symptoms & temp"),
    "springboard_review_calendar_history_text" : MessageLookupByLibrary.simpleMessage("review calendar & history"),
    "springboard_update_profile_text" : MessageLookupByLibrary.simpleMessage("update profile & permissions"),
    "support_COVID19" : MessageLookupByLibrary.simpleMessage("Support during COVID-19"),
    "system_announcement" : m4,
    "temperatureErrorMessage" : m5,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("This app was built by the Clinical Informatics Research Group (CIRG), at the University of Washington, in order to benefit people, like you, who may be concerned about infection with Coronavirus (COVID-19). Or, who simply want to know how best to \"stay home\". Faculty, students, and staff at CIRG are doing this work to help people in our university, local, regional, state, national, and global communities.\n\nThe University of Washington (UW) is not responsible or liable for the accuracy or security of the information in the app. The UW did not develop the system, does not operate it, and has not endorsed it.\n\nThe privacy of your information is important to us. We do our best to keep our clinical information systems private and secure, but we are offering this application without any assurance or warranty.\n\nWe do not track GPS location information from your phone. We do not link your IP address to your information. We do use standard web analytic software (Matomo) to understand user patterns and will look at access logs if we suspect an attempt to compromise the security of our systems.\n\nYou can use this app without entering any personal information by skipping the prompts that ask for it. The system will be less able to personalize to your needs, but that\'s OK with us. We want you to use this app however you feel most comfortable doing so.\n\nThe Resources section of the app is available to anyone. You are welcome to use that feature without creating an account or logging in.\n\nIf you choose to create an account you will need to give us an email address, but you are welcome to use a fake email address. If your email is fake, you will not be able to recover your password, but everything else in the app will work the same. You can update your email address later, but you can\'t change your username.\n\nPlease look carefully at the Profile page. We explain on that page the uses of your personal information, such as an email address, a cell phone number, a zip code/postal code, etc. We ask that you either use accurate information in the profile, so we can personalize the app for you, or that you leave these fields blank."),
    "terms_of_use_title" : MessageLookupByLibrary.simpleMessage("Terms of Use"),
    "un_saved_alert_text" : MessageLookupByLibrary.simpleMessage("You have unsaved responses"),
    "value_not_saved_text" : MessageLookupByLibrary.simpleMessage("This value will not be saved."),
    "versionString" : m3,
    "welcome" : MessageLookupByLibrary.simpleMessage("Thank you and welcome"),
    "what_do_you_want_to_do" : MessageLookupByLibrary.simpleMessage("What do you want to do?"),
    "what_is_your_email_address" : MessageLookupByLibrary.simpleMessage("What is your email address?"),
    "what_is_your_name" : MessageLookupByLibrary.simpleMessage("What is your name?")
  };
}
