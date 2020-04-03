import 'package:flutter/material.dart';

class MapAppColors {
  static const Color c = Colors.deepPurple;

  static const MaterialColor stayHomePrimary =  MaterialColor(
    _stayHomePrimaryValue,
    <int, Color>{
      50: Color(0xFFEDE7F6),
      100: Color(0xFFD1C4E9),
      200: Color(0xFFB39DDB),
      300: Color(0xFF9575CD),
      400: Color(0xFF7E57C2),
      500: Color(_stayHomePrimaryValue),
      600: Color(0xFF5E35B1),
      700: Color(0xFF512DA8),
      800: Color(0xFF4527A0),
      900: Color(0xFF311B92),
    },
  );
  static const int _stayHomePrimaryValue = 0xFF4b2e83; // UW color

  static const MaterialAccentColor stayHomeAccent = MaterialAccentColor(
    _stayHomeAccentValue,
    <int, Color>{
      100: Color(_stayHomeHighlightValue),
      200: Color(_stayHomeAccentValue),
    },
  );
  static const int _stayHomeAccentValue = 0xFFE8E4D2; // not UW Gold

  static const int _stayHomeHighlightValue = 0xFFD1C4E9; // Deep purple 100

  static const Color stayHomeHighlight = Color(_stayHomeHighlightValue);
}