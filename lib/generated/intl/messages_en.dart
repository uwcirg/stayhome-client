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

  static m0(device) => "${device}% charged";

  static m1(duration, durationUnit) => "${duration} ${durationUnit}";

  static m2(number, unit) => "Once every ${number} ${unit}";

  static m3(date, time) => "Last synced: ${date} at ${time}";

  static m4(timeLeftInSeconds) => "Time left until token expiration: ${timeLeftInSeconds} seconds";

  static m5(version) => "Version ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("About"),
    "activity" : MessageLookupByLibrary.simpleMessage("Activity"),
    "add_the_default_careplan_for_me" : MessageLookupByLibrary.simpleMessage("Add the default care plan for me"),
    "battery_level" : m0,
    "buttonPushText" : MessageLookupByLibrary.simpleMessage("You have pushed the button this many times:"),
    "change" : MessageLookupByLibrary.simpleMessage("Change"),
    "contact__community" : MessageLookupByLibrary.simpleMessage("Contact"),
    "demoVersionBannerText" : MessageLookupByLibrary.simpleMessage("Demo version - not for clinical use."),
    "developedByCIRG" : MessageLookupByLibrary.simpleMessage("Developed by the Clinical Informatics Research Group (CIRG) at University of Washington, 2019."),
    "devices" : MessageLookupByLibrary.simpleMessage("Devices"),
    "duration" : MessageLookupByLibrary.simpleMessage("Duration:"),
    "duration_duration_durationunit" : m1,
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "forget" : MessageLookupByLibrary.simpleMessage("Forget"),
    "frequency" : MessageLookupByLibrary.simpleMessage("Frequency:"),
    "frequency_with_contents" : m2,
    "hello" : MessageLookupByLibrary.simpleMessage("Hello!"),
    "help" : MessageLookupByLibrary.simpleMessage("Help"),
    "language" : MessageLookupByLibrary.simpleMessage("Language"),
    "languageName" : MessageLookupByLibrary.simpleMessage("English (EN)"),
    "last_synced_date" : m3,
    "learning_center" : MessageLookupByLibrary.simpleMessage("Learning center & Help"),
    "login" : MessageLookupByLibrary.simpleMessage("login / register"),
    "logout" : MessageLookupByLibrary.simpleMessage("logout"),
    "more_info" : MessageLookupByLibrary.simpleMessage("More info"),
    "my_goals" : MessageLookupByLibrary.simpleMessage("My goals"),
    "my_treatment_plan" : MessageLookupByLibrary.simpleMessage("My Treatment Plan"),
    "name" : MessageLookupByLibrary.simpleMessage("Name"),
    "not_now" : MessageLookupByLibrary.simpleMessage("guest user"),
    "patient_resource_id" : MessageLookupByLibrary.simpleMessage("Patient Resource ID"),
    "plan" : MessageLookupByLibrary.simpleMessage("Calendar"),
    "profile" : MessageLookupByLibrary.simpleMessage("Profile"),
    "progress__insights" : MessageLookupByLibrary.simpleMessage("Check progress"),
    "read_our_blog" : MessageLookupByLibrary.simpleMessage("Read our Blog"),
    "rename" : MessageLookupByLibrary.simpleMessage("Rename"),
    "session_expired_please_log_in_again" : MessageLookupByLibrary.simpleMessage("Session expired, please log in again."),
    "sign_up_or_log_in_to_access_all_functions" : MessageLookupByLibrary.simpleMessage("Sign up or Log in to access all functions"),
    "start_a_session" : MessageLookupByLibrary.simpleMessage("Start a session"),
    "testimonials" : MessageLookupByLibrary.simpleMessage("Testimonials"),
    "timeFormat" : MessageLookupByLibrary.simpleMessage("h:mm:ss aaa"),
    "time_left_until_token_expiration" : m4,
    "treatment_calendar" : MessageLookupByLibrary.simpleMessage("Treatment Calendar"),
    "versionString" : m5,
    "vfit_faq" : MessageLookupByLibrary.simpleMessage("vFit FAQ"),
    "visit_our_facebook_page" : MessageLookupByLibrary.simpleMessage("Visit our Facebook Page"),
    "what_is_your_email_address" : MessageLookupByLibrary.simpleMessage("What is your email address?"),
    "what_is_your_name" : MessageLookupByLibrary.simpleMessage("What is your name?"),
    "what_is_your_patient_resource_id" : MessageLookupByLibrary.simpleMessage("What is your Patient Resource ID?"),
    "womens_health_resources" : MessageLookupByLibrary.simpleMessage("Women\'s Health Resources"),
    "you_have_no_active_pelvic_floor_management_careplan" : MessageLookupByLibrary.simpleMessage("You have no active care plan.")
  };
}
