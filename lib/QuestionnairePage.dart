/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:map_app_flutter/value_utils.dart';

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

  _onDonePressed() {
    _response.status = QuestionnaireResponseStatus.completed;
    _model.postQuestionnaireResponse(_response).then((value) {
      Navigator.of(context).pop();
    }).catchError((error) => snack(error, context));
  }

  _onCancelPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new MapAppPageScaffold(
        title: _questionnaire.title,
        child: QuestionListWidget(
            questions: _questionnaire.item,
            response: _response,
            onDonePressed: _onDonePressed,
            onCancelPressed: _onCancelPressed),
            showDrawer: false,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_response.isEmpty) {
      return true;
    }
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text("You have unsaved responses"),
            content: new Text('What do you want to do?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false); //dismiss dialog with result
                  _onCancelPressed();
                },
                child: new Text('discard'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false); //dismiss dialog with result
                  _onDonePressed();
                },
                child: new Text('save'),
              ),
            ],
          ),
        )) ??
        false;
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
      child: QuestionListWidget(
          questions: _questionnaireItem.item,
          response: _response,
          onDonePressed: () => Navigator.of(context).pop(),
          onCancelPressed: () =>
              Navigator.of(context).popUntil((route) => route.toString() == '/home')),
      showDrawer: false,
    );
  }
}

class QuestionListWidget extends StatefulWidget {
  final List<QuestionnaireItem> questions;
  final QuestionnaireResponse response;
  final Function onDonePressed;
  final Function onCancelPressed;

  QuestionListWidget({this.questions, this.response, this.onDonePressed, this.onCancelPressed});

  @override
  State createState() => QuestionListWidgetState(
      this.questions, this.response, this.onDonePressed, this.onCancelPressed);
}

class QuestionListWidgetState extends State<QuestionListWidget> {
  final List<QuestionnaireItem> _questions;
  final QuestionnaireResponse _response;
  final Function _onDonePressed;
  final Function _onCancelPressed;

  QuestionListWidgetState(
      this._questions, this._response, this._onDonePressed, this._onCancelPressed);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: _questions.length + 1,
            shrinkWrap: true,
            padding: MapAppPadding.cardPageMargins,
            itemBuilder: (context, i) {
              if (i == _questions.length) {
                return _buildSubmitButton(context);
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

  Padding _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: Dimensions.halfMargin,
          right: Dimensions.halfMargin,
          top: Dimensions.halfMargin,
          bottom: 200),
      child: Row(
        children: <Widget>[
          OutlineButton(
            padding: MapAppPadding.largeButtonPadding,
            child: Text("cancel"),
            onPressed: _onCancelPressed,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: Dimensions.fullMargin),
              child: RaisedButton(
                padding: MapAppPadding.largeButtonPadding,
                child: Text("save", style: Theme.of(context).textTheme.button),
                onPressed: _onDonePressed,
              ),
            ),
          ),
        ],
      ),
    );
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
    var questionTitleStyle = Theme.of(context).textTheme.title;
    Widget item;
    if (questionnaireItem.isTemperature()) {
      item = _buildTemperatureItem(questionnaireItem, context);
    } else if (questionnaireItem.type == "choice") {
      item = _buildChoiceItem(questionnaireItem, context);
    } else if (questionnaireItem.type == "display") {
      item = Container();
      questionTitleStyle =
          questionTitleStyle.apply(color: Theme.of(context).primaryColor, fontWeightDelta: 2);
    } else if (questionnaireItem.type == "string") {
      item = _buildStringItem(questionnaireItem, context);
    } else if (questionnaireItem.type == "date") {
      item = _buildDateItem(questionnaireItem, context);
    } else if (questionnaireItem.type == "dateTime") {
      item = _buildDateTimeItem(questionnaireItem, context);
    } else {
      throw UnimplementedError("Not implemented: ${questionnaireItem.type}");
    }
    return Padding(
        padding: MapAppPadding.cardPageMargins,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          Visibility(
            visible: questionnaireItem.text != null && questionnaireItem.text.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.halfMargin),
              child: Text(questionnaireItem.text ?? "", style: questionTitleStyle),
            ),
          ),
          Visibility(
              visible: questionnaireItem.helpText != null && questionnaireItem.helpText.isNotEmpty,
              child: Text(
                questionnaireItem.helpText ?? "",
                style: Theme.of(context).textTheme.caption,
              )),
          item
        ]));
  }

  Widget _buildStringItem(QuestionnaireItem questionnaireItem, BuildContext context) {
    return Padding(
      padding: MapAppPadding.cardPageMargins,
      child: TextFormField(
        decoration: InputDecoration(hintText: questionnaireItem.text),
        onChanged: (value) {
          setState(() {
            _response.setAnswer(questionnaireItem.linkId, Answer(valueString: value));
          });
        },
      ),
    );
  }

  Widget _buildDateItem(QuestionnaireItem questionnaireItem, BuildContext context) {
    DateTime date;
    final dateCtrl = TextEditingController();
    return Padding(
      padding: MapAppPadding.cardPageMargins,
      child: InkWell(
            child: IgnorePointer(
              child: TextFormField(
                controller: dateCtrl,
                decoration: InputDecoration(
                  hintText: questionnaireItem.text,
                ),
              ),
            ),
            onTap:() {
              DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(2019, 1, 1),
                maxTime: new DateTime.now(),
                theme: DatePickerTheme(
                    itemStyle: TextStyle(color: Theme.of(context).primaryColor),
                    doneStyle: TextStyle(color: Theme.of(context).primaryColor)
                ),
                onConfirm: (pickerdate) {
                  final formattedDate = DateFormat.yMd().format(pickerdate);
                  date = DateFormat.yMd().parse(formattedDate.toString());
                  dateCtrl.text = formattedDate.toString();
                  _response.setAnswer(questionnaireItem.linkId, Answer(valueDate: date));
                },
                currentTime: DateTime.now(), locale: Localizations.localeOf(context).languageCode == 'de'? LocaleType.de : LocaleType.en);
            },
          ),
    );
  }

  Widget _buildDateTimeItem(QuestionnaireItem questionnaireItem, BuildContext context) {
    DateTime date;
    final dateCtrl = TextEditingController();
    return Padding(
      padding: MapAppPadding.cardPageMargins,
      child: InkWell(
        child: IgnorePointer(
          child: TextFormField(
            controller: dateCtrl,
            decoration: InputDecoration(
              hintText: questionnaireItem.text
            ),
          ),
        ),
        onTap:() {
          DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(2019, 1, 1, 12, 12, 0, 0),
            maxTime: new DateTime.now(),
            theme: DatePickerTheme (
                itemStyle: TextStyle(color: Theme.of(context).primaryColor),
                doneStyle: TextStyle(color: Theme.of(context).primaryColor)
            ),
            onConfirm: (pickerdate) {
              final formattedDate = DateFormat.yMd().format(pickerdate);
              date = DateFormat.yMd().parseStrict(formattedDate.toString());
              dateCtrl.text = formattedDate.toString();
              _response.setAnswer(questionnaireItem.linkId, Answer(valueDateTime: date));
            },
            //TODO make the locale population dynamic
            currentTime: DateTime.now(), locale: Localizations.localeOf(context).languageCode == 'de'? LocaleType.de : LocaleType.en);
        },
      ),
    );
  }

  Widget _buildChoiceItem(QuestionnaireItem questionnaireItem, BuildContext context) {
    if (questionnaireItem.choiceCount > 5) return _buildDropDown(questionnaireItem);
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildChoices(questionnaireItem, context));
  }

  Widget _buildDropDown(QuestionnaireItem questionnaireItem) {
    Answer currentResponse = _response.getResponseItem(questionnaireItem.linkId) != null
        ? _response.getResponseItem(questionnaireItem.linkId).answer[0]
        : null;
    List<ChoiceOption> choices = questionnaireItem.choiceOptions;

    return DropdownButton(
      isExpanded: true,
      hint: Text(
        currentResponse != null ? currentResponse.toString() : "Select",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      items: choices.map((ChoiceOption choice) {
        return new DropdownMenuItem<ChoiceOption>(
          child: Text(choice.toString()),
          value: choice,
        );
      }).toList(),
      onChanged: (ChoiceOption item) {
        setState(() {
          _response.setAnswer(questionnaireItem.linkId, item.ifSelected);
        });
      },
    );
  }

  Widget _buildTemperatureItem(QuestionnaireItem questionnaireItem, BuildContext context) {
    return TextFormField(
      decoration:
          InputDecoration(hintText: "Enter body temperature, in either °F or °C", errorMaxLines: 3),
      inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      autovalidate: true,
      validator: (value) {
        String message;
        double result;
        if (value.isEmpty) {
          result = null;
        } else {
          result = double.tryParse(value);
          if (result == null) {
            message = "Please enter a valid decimal";
          } else {
            if (!isValidTempF(result) && !isValidTempC(result)) {
              message = "Enter a value between ${QuestionnaireConstants.minF} and "
                  "${QuestionnaireConstants.maxF} (°F) or ${QuestionnaireConstants.minC} and "
                  "${QuestionnaireConstants.maxC} (°C). This value will not be saved.";
            }
            // restrict to 2 decimals
            if (!isValidTempF(result)) result = double.parse(cToF(result).toStringAsFixed(2));
          }
        }
        _response.setAnswer(questionnaireItem.linkId, Answer(valueDecimal: result));
        return message;
      },
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
          new Answer(valueCoding: option),
          helpLabel: '$option');
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
              selectedColor: Theme.of(context).primaryColor,
              selected: isSelected,
              onSelected: (bool) {
                setState(() {
                  _response.setAnswer(questionnaireItem.linkId, ifChosen);
                });
              }),
          Visibility(
            visible: helpLabel != null,
            child: Text(
              helpLabel == "Somewhat" ? "Some\u00ADwhat" : (helpLabel ?? ""),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange}) : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") && value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
