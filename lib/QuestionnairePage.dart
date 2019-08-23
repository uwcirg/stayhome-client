/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';

import 'const.dart';

class QuestionnairePage extends StatefulWidget {
  final Questionnaire _questionnaire;

  QuestionnairePage(this._questionnaire);

  @override
  State<StatefulWidget> createState() {
    return QuestionnairePageState(_questionnaire);
  }
}

class QuestionnairePageState extends State<QuestionnairePage> {
  final Questionnaire _questionnaire;
  QuestionnaireResponse _response;

  QuestionnairePageState(this._questionnaire,
      {QuestionnaireResponse response}) {
    this._response = response;
    if (this._response == null) {
      this._response =
          new QuestionnaireResponse(_questionnaire.reference, subject);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MapAppPageScaffold(
      title: _questionnaire.title,
      child: QuestionListWidget(_questionnaire.item, _response),
      showDrawer: false,
    );
  }
}

class QuestionnaireItemPage extends StatefulWidget {
  final QuestionnaireItem _questionnaireItem;
  final QuestionnaireResponse _response;

  QuestionnaireItemPage(this._questionnaireItem, this._response);

  @override
  State createState() =>
      QuestionnaireItemPageState(this._questionnaireItem, this._response);
}

class QuestionnaireItemPageState extends State<QuestionnaireItemPage> {
  final QuestionnaireItem _questionnaireItem;
  final QuestionnaireResponse _response;

  QuestionnaireItemPageState(this._questionnaireItem, this._response);

  @override
  Widget build(BuildContext context) {
    return new MapAppPageScaffold(
      title: _questionnaireItem.text,
      child: QuestionListWidget(_questionnaireItem.item, _response),
      showDrawer: false,
    );
  }
}

class QuestionListWidget extends StatefulWidget {
  final List<QuestionnaireItem> _questions;
  final QuestionnaireResponse _response;

  QuestionListWidget(this._questions, this._response);

  @override
  State createState() =>
      QuestionListWidgetState(this._questions, this._response);
}

class QuestionListWidgetState extends State<QuestionListWidget> {
  final List<QuestionnaireItem> _questions;
  final QuestionnaireResponse _response;

  QuestionListWidgetState(this._questions, this._response);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: _questions.length,
            shrinkWrap: true,
            padding: MapAppPadding.cardPageMargins,
            itemBuilder: (context, i) {
              QuestionnaireItem item = _questions[i];
              if (item.isSupported()) {
                return _buildItem(context, item);
              } else if (item.isGroup()) {
                return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            QuestionnaireItemPage(item, _response))),
                    child: Card(
                        child: Padding(
                            padding: MapAppPadding.cardPageMargins,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    item.text,
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                ),
                                Icon(Icons.chevron_right),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ))));
              } else {
                return Card(
                    child: Padding(
                  padding: MapAppPadding.cardPageMargins,
                  child: Text(
                    "Unsupported question. Name: ${item.text}. Type: ${item.type}",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .apply(color: Colors.red),
                  ),
                ));
              }
            }));
  }

  Widget _buildItem(BuildContext context, QuestionnaireItem questionnaireItem) {
    return Card(
      child: Padding(
        padding: MapAppPadding.cardPageMargins,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              questionnaireItem.text,
              style: Theme.of(context).textTheme.title,
            ),
            Wrap(
              runSpacing: -8,
              spacing: Dimensions.halfMargin,
              children: _buildChoices(questionnaireItem, context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChoices(
      QuestionnaireItem questionnaireItem, BuildContext context) {
    if (questionnaireItem.answerOption != null) {
      return _buildChoicesFromAnswerOptions(questionnaireItem, context);
    }
    if (questionnaireItem.answerValueSet != null) {
      return _buildChoicesFromAnswerValueSet(questionnaireItem, context);
    }
    throw UnimplementedError(
        "Only answerOption and answerValueSet are supported");
  }

  List<Widget> _buildChoicesFromAnswerOptions(
      QuestionnaireItem questionnaireItem, BuildContext context) {
    Answer currentResponse =
        _response.getResponseItem(questionnaireItem.linkId) != null
            ? _response.getResponseItem(questionnaireItem.linkId).answer[0]
            : null;

    return questionnaireItem.answerOption.map((AnswerOption option) {
      return _buildChip('$option', currentResponse == option, context,
          questionnaireItem, new Answer.fromAnswerOption(option));
    }).toList();
  }

  List<Widget> _buildChoicesFromAnswerValueSet(
      QuestionnaireItem questionnaireItem, BuildContext context) {
    Answer currentResponse =
        _response.getResponseItem(questionnaireItem.linkId) != null
            ? _response.getResponseItem(questionnaireItem.linkId).answer[0]
            : null;

    return questionnaireItem.answerValueSet.map((CodeableConcept option) {
      return _buildChip('$option', currentResponse == option, context,
          questionnaireItem, new Answer(valueCoding: option));
    }).toList();
  }

  Widget _buildChip(String chipLabel, bool isSelected, BuildContext context,
      QuestionnaireItem questionnaireItem, Answer ifChosen) {
    return ChoiceChip(
      label: Text(
        chipLabel,
        style: isSelected
            ? Theme.of(context).accentTextTheme.body1
            : Theme.of(context).textTheme.body1,
      ),
      selected: isSelected,
      onSelected: (bool) {
        setState(() {
          _response.setAnswer(questionnaireItem.linkId, ifChosen);
        });
      },
      selectedColor: Theme.of(context).accentColor,
    );
  }
}
