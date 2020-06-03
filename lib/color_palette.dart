import 'package:flutter/material.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/map_app_code_system.dart';

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

  static Color colorForFlagPriority(Coding flagPriority) {
    return colorForPriority(priorityForFlagPriority(flagPriority));
  }

  static Color colorForPriority(Priority priority) {
    switch (priority) {
      case Priority.routine:
        return Colors.blue[50];
      case Priority.urgent:
        return Colors.yellow[50];
      case Priority.asap:
        return Colors.orange[50];
      case Priority.stat:
        return Colors.red[50];
      default:
        return Colors.grey[50];
    }
  }

  static Priority priorityForFlagPriority(Coding flagPriority) {
    if (flagPriority == FlagPriority.noAlarm) return Priority.routine;
    if (flagPriority == FlagPriority.lowPriority) return Priority.urgent;
    if (flagPriority == FlagPriority.mediumPriority) return Priority.asap;
    if (flagPriority == FlagPriority.highPriority) return Priority.stat;
    return null;
  }
}