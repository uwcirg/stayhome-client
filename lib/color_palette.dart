import 'package:flutter/material.dart';

class MapAppColors {
  static const MaterialColor vFitPrimary = MaterialColor(
    _vFitPrimaryValue,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      350: Color(0xFFD6D6D6), // only for raised button while pressed in light theme
      400: Color(0xFFBDBDBD),
      500: Color(_vFitPrimaryValue),
      600: Color(0xFF717d7d),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      850: Color(0xFF273238), // only for background color in dark theme
      900: Color(0xFF212121),
    },
  );
  static const int _vFitPrimaryValue = 0xFF727c7e;

  static const MaterialAccentColor vFitAccent = MaterialAccentColor(
    _vFitAccentValue,
    <int, Color>{
      100: Color(_vFitHighlightValue),
      200: Color(_vFitAccentValue),
    },
  );
  static const int _vFitAccentValue = 0xFFa3343a;
  
  static const int _vFitHighlightValue = 0xFFe4d4d4;
  
  static const Color vFitHighlight = Color(_vFitHighlightValue);
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
  static const int _stayHomeAccentValue = 0xFFb7a57a; // UW Gold

  static const int _stayHomeHighlightValue = 0xFFD1C4E9; // Deep purple 100

  static const Color stayHomeHighlight = Color(_stayHomeHighlightValue);
}