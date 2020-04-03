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

  static m0(deploymentType) => "System ist im ${deploymentType}-Modus - nicht für den klinischen Gebrauch vorgesehen.";

  static m1(duration, durationUnit) => "${duration} ${durationUnit}";

  static m2(number, unit) => "${number} Mal pro ${unit}";

  static m3(version) => "Version ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("Über"),
    "add_the_default_careplan_for_me" : MessageLookupByLibrary.simpleMessage("Den Standardpflegeplan hinzufügen"),
    "demoVersionBannerText" : m0,
    "developedByCIRG" : MessageLookupByLibrary.simpleMessage("Entwickelt von der Clinical Informatics Research Group (CIRG) an der University of Washington, 2019."),
    "duration" : MessageLookupByLibrary.simpleMessage("Dauer:"),
    "duration_duration_durationunit" : m1,
    "email" : MessageLookupByLibrary.simpleMessage("E-Mail"),
    "frequency" : MessageLookupByLibrary.simpleMessage("Häufigkeit:"),
    "frequency_with_contents" : m2,
    "languageName" : MessageLookupByLibrary.simpleMessage("Deutsch (DE)"),
    "login" : MessageLookupByLibrary.simpleMessage("Anmelden"),
    "my_goals" : MessageLookupByLibrary.simpleMessage("Meine Ziele"),
    "not_now" : MessageLookupByLibrary.simpleMessage("Jetzt nicht"),
    "profile" : MessageLookupByLibrary.simpleMessage("Profil"),
    "session_expired_please_log_in_again" : MessageLookupByLibrary.simpleMessage("Session abgelaufen, bitte erneut einloggen."),
    "sign_up_or_log_in_to_access_all_functions" : MessageLookupByLibrary.simpleMessage("Bitte melden Sie sich an, um auf alle Funktionen zuzugreifen."),
    "versionString" : m3,
    "what_is_your_email_address" : MessageLookupByLibrary.simpleMessage("Was ist Ihre E-Mail Adresse?"),
    "what_is_your_name" : MessageLookupByLibrary.simpleMessage("Wie heißen Sie?")
  };
}
