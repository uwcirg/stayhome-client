import 'package:flutter/material.dart';

class MapAppColors {
  static const MaterialColor stayHomePrimary = Colors.deepPurple;


  static const MaterialAccentColor stayHomeAccent = MaterialAccentColor(
    _stayHomeAccentValue,
    <int, Color>{
      100: Color(_stayHomeHighlightValue),
      200: Color(_stayHomeAccentValue),
    },
  );
  static const int _stayHomeAccentValue = 0xFFD1C4E9;

  static const int _stayHomeHighlightValue = 0xFFD1C4E9; // Deep purple 100

  static const Color stayHomeHighlight = Color(_stayHomeHighlightValue);

  static const Color stayHomeButtonTextColor = Color(0xFF2b4162);
}