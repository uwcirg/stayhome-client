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
    "add_the_default_careplan_for_me" : MessageLookupByLibrary.simpleMessage("add the default care plan for me"),
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
    "loading_error_log_in_again" : MessageLookupByLibrary.simpleMessage("Loading error. Try logging out and in again."),
    "login" : MessageLookupByLibrary.simpleMessage("login / register"),
    "logout" : MessageLookupByLibrary.simpleMessage("logout"),
    "more_info" : MessageLookupByLibrary.simpleMessage("More info"),
    "my_goals" : MessageLookupByLibrary.simpleMessage("My goals"),
    "my_treatment_plan" : MessageLookupByLibrary.simpleMessage("My Treatment Plan"),
    "name" : MessageLookupByLibrary.simpleMessage("Name"),
    "not_now" : MessageLookupByLibrary.simpleMessage("continue without logging in"),
    "patient_resource_id" : MessageLookupByLibrary.simpleMessage("Patient Resource ID"),
    "plan" : MessageLookupByLibrary.simpleMessage("Calendar"),
    "profile" : MessageLookupByLibrary.simpleMessage("Profile"),
    "profile_contact_info_help_text" : MessageLookupByLibrary.simpleMessage("If you set up your account with a fake email, you can provide us a real one here.  It won’t change your username, but **if you also verify your email or phone or both**, you agree that we, or a public health jurisdiction responsible for your location, can contact you if there is a specific need that we, or they, believe to be in your interest."),
    "profile_identifying_info_help_text" : MessageLookupByLibrary.simpleMessage("If you **are willing** to provide a verified email and/or phone number, we’d like to know who we’re speaking with if we do have a need to contact you.  Similarly, if you provide information about who you are, we’d appreciate it if you’d include sex and date of birth as those are standard ways of ensuring someone’s medical information gets attached to the correct clinic, testing, or hospital records.\n\nIf you don’t provide contact, location, or identifying information, we’d like you to provide us with your sex and as much of your date of birth as you’re willing to share.  Patterns of illness by age, sex, and location can be critical in helping public health shape an effective response."),
    "profile_introduction_help_text" : MessageLookupByLibrary.simpleMessage("If you create a profile and add certain types of information, you can see information more relevant to you, and you can convey information to public health that may help your community, or help you personally.\n\nBut remember, everything on this profile is optional.  We’re more interested in having you able to use the system than in having you worry about us collecting information, or keeping it safe.  That said, each item on this page has a use, and you can always come back and update it later."),
    "profile_location_help_text" : MessageLookupByLibrary.simpleMessage("If you give us location information, we may make your symptom temperature and testing information available anonymously (no identifying information) to public health agencies responsible for those zip codes.  You can provide a real location, even if you register with a fake email address.  But, that information (level of illness, location) may be useful for public health planning even if you can not be contacted.  \n\nIf we have your location we can also personalize the information we give you about COVID-19 resources."),
    "progress__insights" : MessageLookupByLibrary.simpleMessage("Check progress"),
    "read_our_blog" : MessageLookupByLibrary.simpleMessage("Read our Blog"),
    "rename" : MessageLookupByLibrary.simpleMessage("Rename"),
    "session_expired_please_log_in_again" : MessageLookupByLibrary.simpleMessage("Session expired, please log in again."),
    "sign_up_or_log_in_to_access_all_functions" : MessageLookupByLibrary.simpleMessage("Log in to access all functions"),
    "start_a_session" : MessageLookupByLibrary.simpleMessage("Start a session"),
    "testimonials" : MessageLookupByLibrary.simpleMessage("Testimonials"),
    "timeFormat" : MessageLookupByLibrary.simpleMessage("h:mm:ss aaa"),
    "time_left_until_token_expiration" : m4,
    "treatment_calendar" : MessageLookupByLibrary.simpleMessage("Treatment Calendar"),
    "versionString" : m5,
    "vfit_faq" : MessageLookupByLibrary.simpleMessage("vFit FAQ"),
    "visit_our_facebook_page" : MessageLookupByLibrary.simpleMessage("Visit our Facebook Page"),
    "welcome" : MessageLookupByLibrary.simpleMessage("thank you and welcome"),
    "what_is_your_email_address" : MessageLookupByLibrary.simpleMessage("What is your email address?"),
    "what_is_your_name" : MessageLookupByLibrary.simpleMessage("What is your name?"),
    "what_is_your_patient_resource_id" : MessageLookupByLibrary.simpleMessage("What is your Patient Resource ID?"),
    "womens_health_resources" : MessageLookupByLibrary.simpleMessage("Women\'s Health Resources"),
    "you_have_no_active_pelvic_floor_management_careplan" : MessageLookupByLibrary.simpleMessage("You have no active care plan.")
  };
}
