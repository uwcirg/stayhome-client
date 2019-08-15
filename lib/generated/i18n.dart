import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
class S implements WidgetsLocalizations {
  const S();

  static const GeneratedLocalizationsDelegate delegate =
    GeneratedLocalizationsDelegate();

  static S of(BuildContext context) => Localizations.of<S>(context, S);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get about => "About";
  String get buttonPushText => "You have pushed the button this many times:";
  String get contact__community => "Contact & Community";
  String get demoVersionBannerText => "Demo version - not for clinical use.";
  String get developedByCIRG => "Developed by the Clinical Informatics Research Group (CIRG) at University of Washington, 2019.";
  String get devices => "Devices";
  String get hello => "Hello!";
  String get help => "Help";
  String get language => "Language";
  String get languageName => "English (EN)";
  String get learning_center => "Learning Center";
  String get login => "Login";
  String get logout => "Logout";
  String get not_now => "Not now";
  String get plan => "Plan";
  String get profile => "Profile";
  String get progress__insights => "Progress & Insights";
  String get session_expired_please_log_in_again => "Session expired, please log in again.";
  String get sign_up_or_log_in_to_access_all_functions => "Sign up or Log in to access all functions";
  String email(String email) => "Email: $email";
  String time_left_until_token_expiration(String _timeLeftInSeconds) => "Time left until token expiration: $_timeLeftInSeconds seconds";
  String versionString(String version) => "Version $version";
}

class $de extends S {
  const $de();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get devices => "Geräte";
  @override
  String get profile => "Profil";
  @override
  String get buttonPushText => "Der Knopf wurde so oft gedrückt:";
  @override
  String get about => "Über";
  @override
  String get language => "Sprache";
  @override
  String get progress__insights => "Fortschritt & Einsichten";
  @override
  String get contact__community => "Kontakt & Gemeinschaft";
  @override
  String get sign_up_or_log_in_to_access_all_functions => "Bitte melden Sie sich an, um auf alle Funktionen zuzugreifen.";
  @override
  String get login => "Anmelden";
  @override
  String get learning_center => "Lernzentrum";
  @override
  String get not_now => "Jetzt nicht";
  @override
  String get developedByCIRG => "Entwickelt von der Clinical Informatics Research Group (CIRG) an der University of Washington, 2019.";
  @override
  String get languageName => "Deutsch (DE)";
  @override
  String get help => "Hilfe";
  @override
  String get logout => "Abmelden";
  @override
  String get demoVersionBannerText => "Demo version - nicht für den klinischen Gebrauch vorgesehen.";
  @override
  String get hello => "Hallo!";
  @override
  String get plan => "Plan";
  @override
  String get session_expired_please_log_in_again => "Session abgelaufen, bitte erneut einloggen.";
  @override
  String versionString(String version) => "Version $version";
  @override
  String time_left_until_token_expiration(String _timeLeftInSeconds) => "Zeit bis Token abläuft: $_timeLeftInSeconds Sekunden";
  @override
  String email(String email) => "E-Mail: $email";
}

class $mn extends S {
  const $mn();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get devices => "Hale Ticking Devices";
  @override
  String get profile => "Profile. The ancestor exists?";
  @override
  String get buttonPushText => "You have pushed the button this many times:";
  @override
  String get about => "About. The honorary stem taxes my unread beast.";
  @override
  String get language => "Language";
  @override
  String get progress__insights => "Intricate Concurrence Progress & Capillary Rainforest Insights";
  @override
  String get contact__community => "Contact & Community";
  @override
  String get sign_up_or_log_in_to_access_all_functions => "Sign up or Log in to access all functions. Why does the advantage attempt a lighted representative?";
  @override
  String get login => "Login. The lowering holiday mutters.";
  @override
  String get learning_center => "Learning Center of the Thirstier Halibut";
  @override
  String get not_now => "Not now, utilitarian chaplain!";
  @override
  String get developedByCIRG => "Developed by the Clinical Informatics Research Group (CIRG) at University of Washington, 2019. The gut gowns a worm. A lifestyle stares! The mercury rails! The bite suffixes the bench across a big moron. When can the symmetry dictate the typical cry?";
  @override
  String get languageName => "Long (MN) How will the bitter cry glow within a garage?";
  @override
  String get help => "Help! When will the performance interfere?";
  @override
  String get logout => "Logout. The jail exchanges a bass outset near a parody.";
  @override
  String get demoVersionBannerText => "Demo version - not for clinical use. Into the normal lunchtime glows the fast union.";
  @override
  String get hello => "Hello! Should the expected muck caution?";
  @override
  String get plan => "Plan zigzag email";
  @override
  String get session_expired_please_log_in_again => "Session expired, please log in again. The legendary highlight staggers outside the silicon.";
  @override
  String versionString(String version) => "Why won't the clearance hook the isolate artist? Version $version The still galaxy flies within a racial conscience.";
  @override
  String time_left_until_token_expiration(String _timeLeftInSeconds) => "Time left until token expiration: $_timeLeftInSeconds seconds, The misleading dinner explains the taxi. A postal regime graduates before a substance. How will the applicable bog try? A pointed abstract scans the bored heaven.";
  @override
  String email(String email) => "Email expansive somersaulting: $email";
}

class $en extends S {
  const $en();
}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("de", ""),
      Locale("mn", ""),
      Locale("en", ""),
    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback, bool withCountry = true}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported, withCountry);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback, bool withCountry = true}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported, withCountry);
    };
  }

  @override
  Future<S> load(Locale locale) {
    final String lang = getLang(locale);
    if (lang != null) {
      switch (lang) {
        case "de":
          return SynchronousFuture<S>(const $de());
        case "mn":
          return SynchronousFuture<S>(const $mn());
        case "en":
          return SynchronousFuture<S>(const $en());
        default:
          // NO-OP.
      }
    }
    return SynchronousFuture<S>(const S());
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale, true);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;

  ///
  /// Internal method to resolve a locale from a list of locales.
  ///
  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported, bool withCountry) {
    if (locale == null || !_isSupported(locale, withCountry)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  ///
  /// Returns true if the specified locale is supported, false otherwise.
  ///
  bool _isSupported(Locale locale, bool withCountry) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        // Language must always match both locales.
        if (supportedLocale.languageCode != locale.languageCode) {
          continue;
        }

        // If country code matches, return this locale.
        if (supportedLocale.countryCode == locale.countryCode) {
          return true;
        }

        // If no country requirement is requested, check if this locale has no country.
        if (true != withCountry && (supportedLocale.countryCode == null || supportedLocale.countryCode.isEmpty)) {
          return true;
        }
      }
    }
    return false;
  }
}

String getLang(Locale l) => l == null
  ? null
  : l.countryCode != null && l.countryCode.isEmpty
    ? l.languageCode
    : l.toString();
