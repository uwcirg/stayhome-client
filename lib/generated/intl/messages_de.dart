/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

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
    "cancel" : MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "cdc_symptom_checker_info_text" : MessageLookupByLibrary.simpleMessage("Der Symptom Self-Checker der CDC ist ein interaktives Tool, mit dem Sie Entscheidungen bezüglich der angemessenen medizinische Versorgung für COVID-19 treffen können.\n\nDerzeit müssen Sie Ihre Symptome erneut eingeben, wenn Sie Self-Checker verwenden. Eine zukünftige Version von StayHome wird Self-Checker jedoch die bereits aufgezeichneten Symptome senden können (mit Ihrer Erlaubnis)."),
    "demoVersionBannerText" : m0,
    "developedByCIRG" : MessageLookupByLibrary.simpleMessage("Entwickelt von der Clinical Informatics Research Group (CIRG) an der University of Washington, 2019."),
    "duration" : MessageLookupByLibrary.simpleMessage("Dauer:"),
    "duration_duration_durationunit" : m1,
    "email" : MessageLookupByLibrary.simpleMessage("E-Mail"),
    "frequency" : MessageLookupByLibrary.simpleMessage("Häufigkeit:"),
    "frequency_with_contents" : m2,
    "guest_home_text" : MessageLookupByLibrary.simpleMessage("StayHome enthält eine Liste von Ressourcen, mit denen Sie direkt auf Informationsquellen zugreifen können, von denen wir glauben, dass sie korrekt sind. Wir hoffen, dass diese Quellen Ihnen helfen, Ihre Gesundheit, Sicherheit und Ihr Wohlbefinden während des COVID-19-Ausbruchs zu erhalten.\n\nOhne Konto können Sie unten fortfahren, um diese Quellen zu durchsuchen und den darin enthaltenen Links zu folgen.\n\nWenn Sie jetzt oder später ein Konto erstellen möchten, können Sie:\n\n- Ihre eigenen Symptome und Temperatur verfolgen\n- Reisen und / oder Zeiten, in denen Sie möglicherweise ausgesetzt waren, verfolgen \n- COVID-19-Tests aufzeichnen, und damit dazu beitragen, dass die Gesundheitsbehörden Ihre Ergebnisse mit Ihren Kontaktinformationen in Verbindung bringen können\n- andere Informationen wie Schwangerschaft und Beruf aufzeichnen, die den Gesundheitsbehörden helfen können, bestimmte Programme oder Schutzmaßnahmen für Sie zu ermitteln."),
    "languageName" : MessageLookupByLibrary.simpleMessage("Deutsch (DE)"),
    "loading_error_log_in_again" : MessageLookupByLibrary.simpleMessage("Ladefehler. Versuchen Sie, sich ab- und wieder anzumelden."),
    "login" : MessageLookupByLibrary.simpleMessage("Anmelden"),
    "name_not_entered" : MessageLookupByLibrary.simpleMessage("(Name nicht bekannt)"),
    "not_now" : MessageLookupByLibrary.simpleMessage("Jetzt nicht"),
    "profile" : MessageLookupByLibrary.simpleMessage("Profil"),
    "profile_contact_info_help_text" : MessageLookupByLibrary.simpleMessage("Wenn Sie Ihre E-Mail-Adresse, Ihr Telefon oder beides angeben, können wir diese Informationen dem für Ihre Region zuständigen Gesundheitsamt zur Verfügung stellen, und wir oder sie können Sie bei Bedarf kontaktieren. Sie werden nur kontaktiert, wenn wir oder die Gesundheitsbehörde(n) glauben, dass es in Ihrem besten Interesse ist.\n\nWenn Sie Ihr Konto mit einer gefälschten E-Mail eingerichtet haben, können Sie uns hier eine echte E-Mail-Adresse zur Verfügung stellen, damit wir Sie kontaktieren können. Dadurch wird Ihr Benutzername jedoch nicht geändert. Wenn Sie beim Einrichten Ihres Kontos eine E-Mail-Adresse als Benutzernamen verwendet haben, aber eine andere E-Mail-Adresse als Ihre Kontakt-E-Mail bevorzugen, können Sie diese hier eingeben. Ihr Benutzername wird jedoch nicht geändert."),
    "profile_identifying_info_help_text" : MessageLookupByLibrary.simpleMessage("Sollten Sie eine E-Mail-Adresse und / oder eine Telefonnummer angeben haben, möchten wir wissen, mit wem wir sprechen, wenn wir Sie kontaktieren müssen. Wir würden uns auch freuen, wenn Sie Geschlecht und Geburtsdatum angeben würden, da dies Standardmethoden sind, um sicherzustellen, dass medizinische Informationen der richtigen Person an die richtigen Klinik-, Test- oder Krankenhausunterlagen angehängt werden.\n\nWenn Sie keinen Ort oder keine Kontaktinformationen angegeben haben, wäre es dennoch hilfreich, wenn Sie uns Ihr Geschlecht, das Jahr und möglicherweise den Monat Ihrer Geburt mitteilen könnten (Sie können einen falschen Tag oder Monat eingeben, wenn Sie wollen). Krankheitsbilder nach Alter, Geschlecht und Ort können entscheidend dazu beitragen, dass die Gesundheitsbehörden eine wirksame Reaktion entwickeln."),
    "profile_introduction_help_text" : MessageLookupByLibrary.simpleMessage("Wenn Sie ein Profil erstellen und bestimmte Arten von Informationen hinzufügen, werden Informationen angezeigt, die für Sie relevanter sind, und Sie können Informationen an die Gesundheitsbehörden weitergeben, die Ihrer Gemeinde oder Ihnen persönlich helfen können.\n\nDenken Sie jedoch daran, dass alles in diesem Profil optional ist. Wir sind mehr daran interessiert, dass Sie das System nutzen können, als dass Sie sich Sorgen machen, dass wir Informationen sammeln oder sicher aufbewahren. Das heißt, jedes Element auf dieser Seite hat eine Verwendung, und Sie können jederzeit zurückkehren und es später aktualisieren."),
    "profile_location_help_text" : MessageLookupByLibrary.simpleMessage("Wenn Sie uns Standortinformationen geben, stellen wir möglicherweise Informationen zu Symptomen, Temperatur und COVID-19-Tests anonym (keine identifizierenden Informationen) den für diese Postleitzahlen zuständigen Gesundheitsbehörden zur Verfügung. Sie können einen realen Standort angeben, auch wenn Sie sich mit einer gefälschten E-Mail-Adresse registrieren haben und keine weiteren Informationen angeben. Diese Informationen (Krankheitsgrad, Ort) können jedoch für die Planung der Gesundheitsbehörden hilfreich sein, auch wenn Sie nicht kontaktiert werden können.\n\nWenn Sie Ihren Standort eingeben, können wir auch die Informationen, die wir Ihnen zu COVID-19-Ressourcen geben, personalisieren."),
    "session_expired_please_log_in_again" : MessageLookupByLibrary.simpleMessage("Session abgelaufen, bitte erneut einloggen."),
    "sign_up_or_log_in_to_access_all_functions" : MessageLookupByLibrary.simpleMessage("Bitte melden Sie sich an, um auf alle Funktionen zuzugreifen."),
    "terms_of_use_title" : MessageLookupByLibrary.simpleMessage("Nutzungsbedingungen"),
    "versionString" : m3,
    "welcome" : MessageLookupByLibrary.simpleMessage("Danke und Willkommen"),
    "what_is_your_email_address" : MessageLookupByLibrary.simpleMessage("Was ist Ihre E-Mail Adresse?"),
    "what_is_your_name" : MessageLookupByLibrary.simpleMessage("Wie heißen Sie?")
  };
}
