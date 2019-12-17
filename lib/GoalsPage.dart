/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/QuestionnairePage.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'fhir/FhirResources.dart';
import 'main.dart';

class GoalsPage extends StatefulWidget {
  GoalsPage();

  static _GoalsPageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_GoalsPageState>());

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  _GoalsPageState();

  @override
  Widget build(BuildContext context) {
    String title = "My Goals";
    return MapAppPageScaffold(
        title: title,
        child: ScopedModelDescendant<CarePlanModel>(
            builder: (context, child, model) => _buildScreen(context, model)));
  }

  Widget _buildScreen(BuildContext context, CarePlanModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.halfMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _sectionHeader(context, "Issues I'm concerned about:"),
          ..._concernsRows(context, model),
          _sectionHeader(context, "Session goal:"),
          ..._goalsRows(context, model)
        ],
      ),
    );
  }

  Container _sectionHeader(BuildContext context, String title) {
    return Container(
        color: Theme.of(context).highlightColor,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Center(
              child: Text(
            title,
            style: Theme.of(context).textTheme.subhead,
          )),
        ));
  }

  List<Widget> _concernsRows(BuildContext context, CarePlanModel model) {
    return model.goals.concerns.entries
        .map((MapEntry<HealthIssue, int> e) => _row(e, _concernsChips, model))
        .toList();
  }

  List<Widget> _goalsRows(BuildContext context, CarePlanModel model) {
    return model.goals.goals.entries
        .map((MapEntry<HealthIssue, SessionGoal> e) => _row(e, _goalsChips, model))
        .toList();
  }

  Widget _row(MapEntry<HealthIssue, dynamic> mapEntry, chipsFunction, model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              mapEntry.key.image,
              height: 30,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              mapEntry.key.name,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          Expanded(
            flex:3,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: chipsFunction(model, mapEntry.key)),
          )
        ],
      ),
    );
  }

  List<Widget> _concernsChips(CarePlanModel model, HealthIssue issue) {
    List<Widget> chips = List<Widget>();
    for (int i = 0; i < 5; i++) {
      chips.add(ChoiceChip(
        label: Text('$i',
            style: model.goals.concerns[issue] == i
                ? Theme.of(context).accentTextTheme.body1
                : Theme.of(context).textTheme.body1),
        selected: model.goals.concerns[issue] == i,
        selectedColor: Theme.of(context).accentColor,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              model.goals.concerns[issue] = i;
            } else {
              model.goals.concerns[issue] = -1;
            }
          });
        },
      ));
    }
    return chips;
  }

  List<Widget> _goalsChips(CarePlanModel model, HealthIssue issue) {
    return [SessionGoal.Wellness, SessionGoal.Maintenance].map((SessionGoal goal) {
      return ChoiceChip(
        label: Text('$goal',
            style: model.goals.goals[issue] == goal
                ? Theme.of(context).accentTextTheme.body1
                : Theme.of(context).textTheme.body1),
        selected: model.goals.goals[issue] == goal,
        selectedColor: Theme.of(context).accentColor,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              model.goals.goals[issue] = goal;
            } else {
              model.goals.goals[issue] = null;
            }
          });
        },
      );
    }).toList();
  }
}
