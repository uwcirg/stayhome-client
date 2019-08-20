/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/fhir/QuestionnaireResponse.dart';

import 'const.dart';
import 'fhir/Questionnaire.dart';

class QuestionnairePage extends StatefulWidget {
  Questionnaire _questionnaire;

  QuestionnairePage(this._questionnaire);

  @override
  State<StatefulWidget> createState() {
    return QuestionnairePageState(_questionnaire);
  }
}

class QuestionnairePageState extends State<QuestionnairePage> {
  Questionnaire _questionnaire;
  QuestionnaireResponse _response;

  QuestionnairePageState(this._questionnaire,
      {QuestionnaireResponse response}) {
    this._response = response;
    if (this._response == null) {
      this._response = new QuestionnaireResponse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MapAppPageScaffold(
      title: _questionnaire.title,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.halfMargin),
        child: Column(children: _buildQuestions(context)),
      ),
      showDrawer: false,
    );
  }

  List<Widget> _buildQuestions(BuildContext context) {
    List<Widget> widgets = [];
    for (QuestionnaireItem item in _questionnaire.item) {
      widgets.add(_buildItem(context, item));
    }
    return widgets;
  }

  Widget _buildItem(BuildContext context, QuestionnaireItem questionnaireItem) {
    var currentResponse =
        _response.getResponseItem(questionnaireItem.linkId) != null
            ? _response
                .getResponseItem(questionnaireItem.linkId)
                .answer[0]
                .valueInteger
            : null;

    return Card(
      child: Padding(
        padding: MapAppPadding.cardPageMargins,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              questionnaireItem.text,
              style: Theme.of(context).textTheme.title,
            ),
            Row(
              children:
                  questionnaireItem.answerOption.map((AnswerOption option) {
                bool isSelected = currentResponse == option.valueInteger;
                return ChoiceChip(
                  label: Text(
                    '${option.valueInteger}',
                    style: isSelected
                        ? Theme.of(context).accentTextTheme.body1
                        : Theme.of(context).textTheme.body1,
                  ),
                  selected: isSelected,
                  onSelected: (bool) {
                    setState(() {
                      _response.setAnswer(questionnaireItem.linkId,
                          new Answer(valueInteger: option.valueInteger));
                    });
                  },
                  selectedColor: Theme.of(context).accentColor,
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
