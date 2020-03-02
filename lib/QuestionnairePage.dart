/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';

import 'const.dart';

class QuestionnairePage extends StatefulWidget {
  final Questionnaire _questionnaire;

  CarePlanModel _carePlanModel;

  QuestionnairePage(this._questionnaire, this._carePlanModel);

  @override
  State<StatefulWidget> createState() {
    return QuestionnairePageState(_questionnaire, _carePlanModel);
  }
}

class QuestionnairePageState extends State<QuestionnairePage> {
  final Questionnaire _questionnaire;
  QuestionnaireResponse _response;
  CarePlanModel _model;

  QuestionnairePageState(this._questionnaire, this._model, {QuestionnaireResponse response}) {
    this._response = response;
    if (this._response == null) {
      this._response = new QuestionnaireResponse(
          _questionnaire, Reference.from(_model.patient), _model.carePlan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MapAppPageScaffold(
      title: _questionnaire.title,
      child: QuestionListWidget(_questionnaire.item, _response, () {
        _response.status = QuestionnaireResponseStatus.completed;
        _model.postQuestionnaireResponse(_response).then((value) {
          Navigator.of(context).pop();
        }).catchError((error) => snack(error, context));
      }),
      showDrawer: false,
    );
  }
}

class QuestionnaireItemPage extends StatefulWidget {
  final QuestionnaireItem _questionnaireItem;
  final QuestionnaireResponse _response;

  QuestionnaireItemPage(this._questionnaireItem, this._response);

  @override
  State createState() => QuestionnaireItemPageState(this._questionnaireItem, this._response);
}

class QuestionnaireItemPageState extends State<QuestionnaireItemPage> {
  final QuestionnaireItem _questionnaireItem;
  final QuestionnaireResponse _response;

  QuestionnaireItemPageState(this._questionnaireItem, this._response);

  @override
  Widget build(BuildContext context) {
    return new MapAppPageScaffold(
      title: _questionnaireItem.text,
      child:
          QuestionListWidget(_questionnaireItem.item, _response, () => Navigator.of(context).pop()),
      showDrawer: false,
    );
  }
}

class QuestionListWidget extends StatefulWidget {
  final List<QuestionnaireItem> _questions;
  final QuestionnaireResponse _response;
  final Function _onPressed;

  QuestionListWidget(this._questions, this._response, this._onPressed);

  @override
  State createState() => QuestionListWidgetState(this._questions, this._response, this._onPressed);
}

class QuestionListWidgetState extends State<QuestionListWidget> {
  final List<QuestionnaireItem> _questions;
  final QuestionnaireResponse _response;
  final Function _onPressed;

  QuestionListWidgetState(this._questions, this._response, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: _questions.length + 1,
            shrinkWrap: true,
            padding: MapAppPadding.cardPageMargins,
            itemBuilder: (context, i) {
              if (i == _questions.length) {
                return Padding(
                  padding: const EdgeInsets.all(Dimensions.halfMargin),
                  child: RaisedButton(
                    padding: MapAppPadding.largeButtonPadding,
                    child: Text("Done"),
                    onPressed: _onPressed,
                  ),
                );
              }

              QuestionnaireItem item = _questions[i];
              if (item.isSupported()) {
                return _buildItem(context, item);
              } else if (item.isGroup()) {
                return _buildGroupCard(context, item);
              } else {
                return _buildUnsupportedItemCard(context, item);
              }
            }));
  }

  Widget _buildGroupCard(BuildContext context, QuestionnaireItem item) {
    return InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => QuestionnaireItemPage(item, _response))),
        child: Card(
            color: Theme.of(context).highlightColor,
            child: Padding(
                padding: MapAppPadding.cardPageMargins,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.text,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).textTheme.title.color,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ))));
  }

  Card _buildUnsupportedItemCard(BuildContext context, QuestionnaireItem item) {
    return Card(
        child: Padding(
      padding: MapAppPadding.cardPageMargins,
      child: Text(
        "Unsupported question. Name: ${item.text}. Type: ${item.type}",
        style: Theme.of(context).textTheme.title.apply(color: Colors.red),
      ),
    ));
  }

  Widget _buildItem(BuildContext context, QuestionnaireItem questionnaireItem) {
    return Padding(
      padding: MapAppPadding.cardPageMargins,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.halfMargin),
            child: Text(
              questionnaireItem.text,
              style: Theme.of(context).textTheme.title,
            ),
          ),
//          Wrap(
//            runSpacing: -8,
//            spacing: Dimensions.halfMargin,
//            children: _buildChoices(questionnaireItem, context),
//          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildChoices(questionnaireItem, context))
        ],
      ),
    );
  }

  List<Widget> _buildChoices(QuestionnaireItem questionnaireItem, BuildContext context) {
    Answer currentResponse = _response.getResponseItem(questionnaireItem.linkId) != null
        ? _response.getResponseItem(questionnaireItem.linkId).answer[0]
        : null;

    if (questionnaireItem.answerOption != null) {
      return _buildChoicesFromAnswerOptions(questionnaireItem, currentResponse, context);
    }
    if (questionnaireItem.answerValueSet != null) {
      return _buildChoicesFromAnswerValueSet(questionnaireItem, currentResponse, context);
    }
    throw UnimplementedError("Only answerOption and answerValueSet are supported");
  }

  List<Widget> _buildChoicesFromAnswerOptions(
      QuestionnaireItem questionnaireItem, Answer currentResponse, BuildContext context) {
    return questionnaireItem.answerOption.map((AnswerOption option) {
      return _buildChip(
          '${option.ordinalValue() != -1 ? option.ordinalValue() : option}',
          currentResponse == option,
          context,
          questionnaireItem,
          new Answer.fromAnswerOption(option),
          helpLabel: '$option');
    }).toList();
  }

  List<Widget> _buildChoicesFromAnswerValueSet(
      QuestionnaireItem questionnaireItem, Answer currentResponse, BuildContext context) {
    return questionnaireItem.answerValueSet.map((Coding option) {
      return _buildChip('$option', currentResponse == option, context, questionnaireItem,
          new Answer(valueCoding: option));
    }).toList();
  }

  Widget _buildChip(String chipLabel, bool isSelected, BuildContext context,
      QuestionnaireItem questionnaireItem, Answer ifChosen,
      {String helpLabel}) {
    if (chipLabel == "-1") {
      chipLabel = helpLabel;
      helpLabel = null;
    }
    return Flexible(
      child: Column(
        children: <Widget>[
          ChoiceChip(
              label: Text("  "),
              selected: isSelected,
              onSelected: (bool) {
                setState(() {
                  _response.setAnswer(questionnaireItem.linkId, ifChosen);
                });
              }),
          Visibility(
            visible: helpLabel != null,
            child: Text(
              helpLabel == "Somewhat" ? "Some\u00ADwhat" : helpLabel,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
