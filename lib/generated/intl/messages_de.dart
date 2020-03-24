// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static m0(device) => "${device}% geladen";

  static m1(deploymentType) => "System ist im ${deploymentType}-Modus - nicht für den klinischen Gebrauch vorgesehen.";

  static m2(duration, durationUnit) => "${duration} ${durationUnit}";

  static m3(number, unit) => "${number} Mal pro ${unit}";

  static m4(date, time) => "Zuletzt synchronisiert: ${date} at ${time}";

  static m5(timeLeftInSeconds) => "Zeit bis Token abläuft: ${timeLeftInSeconds} Sekunden";

  static m6(version) => "Version ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("Über"),
    "activity" : MessageLookupByLibrary.simpleMessage("Aktivität"),
    "add_the_default_careplan_for_me" : MessageLookupByLibrary.simpleMessage("Den Standardpflegeplan hinzufügen"),
    "battery_level" : m0,
    "buttonPushText" : MessageLookupByLibrary.simpleMessage("Der Knopf wurde so oft gedrückt:"),
    "change" : MessageLookupByLibrary.simpleMessage("Ändern"),
    "contact__community" : MessageLookupByLibrary.simpleMessage("Kontakt & Gemeinschaft"),
    "demoVersionBannerText" : m1,
    "developedByCIRG" : MessageLookupByLibrary.simpleMessage("Entwickelt von der Clinical Informatics Research Group (CIRG) an der University of Washington, 2019."),
    "devices" : MessageLookupByLibrary.simpleMessage("Geräte"),
    "duration" : MessageLookupByLibrary.simpleMessage("Dauer:"),
    "duration_duration_durationunit" : m2,
    "email" : MessageLookupByLibrary.simpleMessage("E-Mail"),
    "forget" : MessageLookupByLibrary.simpleMessage("Vergessen"),
    "frequency" : MessageLookupByLibrary.simpleMessage("Häufigkeit:"),
    "frequency_with_contents" : m3,
    "hello" : MessageLookupByLibrary.simpleMessage("Hallo!"),
    "help" : MessageLookupByLibrary.simpleMessage("Hilfe"),
    "language" : MessageLookupByLibrary.simpleMessage("Sprache"),
    "languageName" : MessageLookupByLibrary.simpleMessage("Deutsch (DE)"),
    "last_synced_date" : m4,
    "learning_center" : MessageLookupByLibrary.simpleMessage("Lernzentrum"),
    "login" : MessageLookupByLibrary.simpleMessage("Anmelden"),
    "logout" : MessageLookupByLibrary.simpleMessage("Abmelden"),
    "more_info" : MessageLookupByLibrary.simpleMessage("Weitere details"),
    "my_goals" : MessageLookupByLibrary.simpleMessage("Meine Ziele"),
    "my_treatment_plan" : MessageLookupByLibrary.simpleMessage("Mein Behandlungsplan"),
    "name" : MessageLookupByLibrary.simpleMessage("Name"),
    "not_now" : MessageLookupByLibrary.simpleMessage("Jetzt nicht"),
    "patient_resource_id" : MessageLookupByLibrary.simpleMessage("Patient Resource ID"),
    "plan" : MessageLookupByLibrary.simpleMessage("Plan"),
    "profile" : MessageLookupByLibrary.simpleMessage("Profil"),
    "progress__insights" : MessageLookupByLibrary.simpleMessage("Fortschritt"),
    "read_our_blog" : MessageLookupByLibrary.simpleMessage("Lesen Sie unseren Blog"),
    "rename" : MessageLookupByLibrary.simpleMessage("Umbenennen"),
    "session_expired_please_log_in_again" : MessageLookupByLibrary.simpleMessage("Session abgelaufen, bitte erneut einloggen."),
    "sign_up_or_log_in_to_access_all_functions" : MessageLookupByLibrary.simpleMessage("Bitte melden Sie sich an, um auf alle Funktionen zuzugreifen."),
    "start_a_session" : MessageLookupByLibrary.simpleMessage("Session starten"),
    "testimonials" : MessageLookupByLibrary.simpleMessage("Kundenreferenzen"),
    "timeFormat" : MessageLookupByLibrary.simpleMessage("H:mm:ss"),
    "time_left_until_token_expiration" : m5,
    "treatment_calendar" : MessageLookupByLibrary.simpleMessage("Behandlungskalender"),
    "versionString" : m6,
    "vfit_faq" : MessageLookupByLibrary.simpleMessage("vFit Häufig Gestellte Fragen"),
    "visit_our_facebook_page" : MessageLookupByLibrary.simpleMessage("Besuchen Sie uns auf Facebook"),
    "what_is_your_email_address" : MessageLookupByLibrary.simpleMessage("Was ist Ihre E-Mail Adresse?"),
    "what_is_your_name" : MessageLookupByLibrary.simpleMessage("Wie heißen Sie?"),
    "what_is_your_patient_resource_id" : MessageLookupByLibrary.simpleMessage("Wie lautet ihre Patientenressourcen-ID?"),
    "womens_health_resources" : MessageLookupByLibrary.simpleMessage("Bildungsressourcen zu frauenspezifischen Gesundheitsthemen"),
    "you_have_no_active_pelvic_floor_management_careplan" : MessageLookupByLibrary.simpleMessage("Sie haben keinen aktiven Pflegeplan.")
  };
}
