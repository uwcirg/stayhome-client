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

  static m1(deploymentType) => "This is a ${deploymentType} system - not for real data.";

  static m2(duration, durationUnit) => "${duration} ${durationUnit}";

  static m3(number, unit) => "Once every ${number} ${unit}";

  static m4(date, time) => "Last synced: ${date} at ${time}";

  static m5(timeLeftInSeconds) => "Time left until token expiration: ${timeLeftInSeconds} seconds";

  static m6(version) => "Version ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("About"),
    "activity" : MessageLookupByLibrary.simpleMessage("Activity"),
    "add_the_default_careplan_for_me" : MessageLookupByLibrary.simpleMessage("add the default care plan for me"),
    "battery_level" : m0,
    "buttonPushText" : MessageLookupByLibrary.simpleMessage("You have pushed the button this many times:"),
    "cancel" : MessageLookupByLibrary.simpleMessage("cancel"),
    "change" : MessageLookupByLibrary.simpleMessage("Change"),
    "contact__community" : MessageLookupByLibrary.simpleMessage("Contact"),
    "demoVersionBannerText" : m1,
    "developedByCIRG" : MessageLookupByLibrary.simpleMessage("Developed by the Clinical Informatics Research Group (CIRG) at University of Washington, 2019-2020."),
    "devices" : MessageLookupByLibrary.simpleMessage("Devices"),
    "duration" : MessageLookupByLibrary.simpleMessage("Duration:"),
    "duration_duration_durationunit" : m2,
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "forget" : MessageLookupByLibrary.simpleMessage("Forget"),
    "frequency" : MessageLookupByLibrary.simpleMessage("Frequency:"),
    "frequency_with_contents" : m3,
    "guest_home_text" : MessageLookupByLibrary.simpleMessage("StayHome includes a list of resources that gives you direct access to information sources that we believe to be accurate. We hope these sources will help you maintain your health, safety, and well-being during the COVID-19 outbreak.\n\nWithout an account, you can “continue” below to browse these sources, and follow the links they contain.\n\nIf you do decide to create an account, now or later, you can:\n\n- track your own symptoms and temperature\n- track travel and/or times you may have been exposed\n- record COVID-19 testing, which can help public health match your results with a way to contact you\n- record other information such as pregnancy and occupation that may help public health identify specific programs or protections for you."),
    "hello" : MessageLookupByLibrary.simpleMessage("Hello!"),
    "help" : MessageLookupByLibrary.simpleMessage("Help"),
    "language" : MessageLookupByLibrary.simpleMessage("Language"),
    "languageName" : MessageLookupByLibrary.simpleMessage("English (EN)"),
    "last_synced_date" : m4,
    "learning_center" : MessageLookupByLibrary.simpleMessage("Learning center & Help"),
    "loading_error_log_in_again" : MessageLookupByLibrary.simpleMessage("Loading error. Try logging out and in again."),
    "login" : MessageLookupByLibrary.simpleMessage("login / register"),
    "logout" : MessageLookupByLibrary.simpleMessage("logout"),
    "more_info" : MessageLookupByLibrary.simpleMessage("More info"),
    "my_goals" : MessageLookupByLibrary.simpleMessage("My goals"),
    "my_treatment_plan" : MessageLookupByLibrary.simpleMessage("My Treatment Plan"),
    "name" : MessageLookupByLibrary.simpleMessage("Name"),
    "name_not_entered" : MessageLookupByLibrary.simpleMessage("(name not entered)"),
    "not_now" : MessageLookupByLibrary.simpleMessage("continue without logging in"),
    "patient_resource_id" : MessageLookupByLibrary.simpleMessage("Patient Resource ID"),
    "plan" : MessageLookupByLibrary.simpleMessage("Calendar"),
    "profile" : MessageLookupByLibrary.simpleMessage("Profile"),
    "profile_contact_info_help_text" : MessageLookupByLibrary.simpleMessage("If you provide your email, phone, or both, then we can make that info available to the public health agency responsible for your area, and we or they can contact you if needed. You will only be contacted if there is a specific reason to do so, one that we or the public health agency(s) believe to be in your best interest.\n\nIf you chose to set up your account with a fake email, you may provide us with a real one here, so we may contact you. But, doing so will not change your username. Likewise, if you used one email as a username when setting up your account, but would prefer a different email as your contact email, you can enter it here, but it will not change your username."),
    "profile_identifying_info_help_text" : MessageLookupByLibrary.simpleMessage("If you **do provide** an email and/or phone number, we\'d like to know who we are speaking with, if we do have a need to contact you. We’d also appreciate it if you\'d include sex and date of birth as those are standard ways of ensuring that the right person\'s medication information gets attached to the correct clinic, testing, or hospital records.\n\nIf you **have not provided** location or contact information, it would still be helpful if you could let us know your sex, the year, and perhaps the month of your birth (you can enter a fake day, or month, if you want). Patterns of illness by age, sex, and location can be critical in helping public health shape an effective response."),
    "profile_introduction_help_text" : MessageLookupByLibrary.simpleMessage("If you create a profile and add certain types of information, you can see information more relevant to you, and you can convey information to public health that may help your community, or help you personally.\n\nBut remember, everything on this profile is optional. We’re more interested in having you able to use the system than in having you worry about us collecting information, or keeping it safe. That said, each item on this page has a use, and you can always come back and update it later."),
    "profile_location_help_text" : MessageLookupByLibrary.simpleMessage("If you give us location information, we may make symptom temperature and COVID-19 testing information available anonymously (no identifying information) to public health agencies responsible for those zip codes. You can provide a real location, even if you register with a fake email address and provide no other information. But that information (level of illness, location) may be useful for public health planning even if you can not be contacted.\n\nIf you enter your location, we can also personalize the information we give you about COVID-19 resources."),
    "progress__insights" : MessageLookupByLibrary.simpleMessage("Check progress"),
    "read_our_blog" : MessageLookupByLibrary.simpleMessage("Read our Blog"),
    "rename" : MessageLookupByLibrary.simpleMessage("Rename"),
    "session_expired_please_log_in_again" : MessageLookupByLibrary.simpleMessage("Session expired, please log in again."),
    "sign_up_or_log_in_to_access_all_functions" : MessageLookupByLibrary.simpleMessage("Log in to access all functions"),
    "start_a_session" : MessageLookupByLibrary.simpleMessage("Start a session"),
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("This app was built by the Clinical Informatics Research Group (CIRG), at the University of Washington, in order to benefit people, like you, who may be concerned about infection with Coronavirus (COVID-19). Or, who simply want to know how best to \"stay home\". Faculty, students, and staff at CIRG are doing this work to help people in our university, local, regional, state, national, and global communities.\n\nThe University of Washington (UW) is not responsible or liable for the accuracy or security of the information in the app. The UW did not develop the system, does not operate it, and has not endorsed it.\n\nThe privacy of your information is important to us. We do our best to keep our clinical information systems private and secure, but we are offering this application without any assurance or warranty.\n\nWe do not track GPS location information from your phone. We do not link your IP address to your information. We do use standard web analytic software (Matomo) to understand user patterns and will look at access logs if we suspect an attempt to compromise the security of our systems.\n\nYou can use this app without entering any personal information by skipping the prompts that ask for it. The system will be less able to personalize to your needs, but that\'s OK with us. We want you to use this app however you feel most comfortable doing so.\n\nThe Resources section of the app is available to anyone. You are welcome to use that feature without creating an account or logging in.\n\nIf you choose to create an account you will need to give us an email address, but you are welcome to use a fake email address. If your email is fake, you will not be able to recover your password, but everything else in the app will work the same. You can update your email address later, but you can\'t change your username.\n\nPlease look carefully at the Profile page. We explain on that page the uses of your personal information, such as an email address, a cell phone number, a zip code/postal code, etc. We ask that you either use accurate information in the profile, so we can personalize the app for you, or that you leave these fields blank."),
    "terms_of_use_title" : MessageLookupByLibrary.simpleMessage("Terms of Use"),
    "testimonials" : MessageLookupByLibrary.simpleMessage("Testimonials"),
    "timeFormat" : MessageLookupByLibrary.simpleMessage("h:mm:ss aaa"),
    "time_left_until_token_expiration" : m5,
    "treatment_calendar" : MessageLookupByLibrary.simpleMessage("Treatment Calendar"),
    "versionString" : m6,
    "vfit_faq" : MessageLookupByLibrary.simpleMessage("vFit FAQ"),
    "visit_our_facebook_page" : MessageLookupByLibrary.simpleMessage("Visit our Facebook Page"),
    "welcome" : MessageLookupByLibrary.simpleMessage("Thank you and welcome"),
    "what_is_your_email_address" : MessageLookupByLibrary.simpleMessage("What is your email address?"),
    "what_is_your_name" : MessageLookupByLibrary.simpleMessage("What is your name?"),
    "what_is_your_patient_resource_id" : MessageLookupByLibrary.simpleMessage("What is your Patient Resource ID?"),
    "womens_health_resources" : MessageLookupByLibrary.simpleMessage("Women\'s Health Resources"),
    "you_have_no_active_pelvic_floor_management_careplan" : MessageLookupByLibrary.simpleMessage("You have no active care plan."),
    "cancel" : MessageLookupByLibrary.simpleMessage("cancel")
  };
}
