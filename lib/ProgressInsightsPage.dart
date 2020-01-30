/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

class ProgressInsightsPage extends StatefulWidget {
  @override
  State createState() {
    return new _ProgressInsightsPageState();
  }
}

class _ProgressInsightsPageState extends State<ProgressInsightsPage> {
  String _selectedLinkId;

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        title: S.of(context).progress__insights,
        child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
          return _buildScreen(context, model);
        }));
  }

  Widget _buildScreen(BuildContext context, CarePlanModel model) {
    if (model.questionnaireResponses == null)
      return Container(
        height: 0,
      );

    List<QuestionnaireItem> questions = [];

    for (QuestionnaireResponse q in model.questionnaireResponses) {
      if (q.item != null) {
        for (QuestionnaireResponseItem i in q.item) {
          questions.add(model.questionForLinkId(i.linkId));
        }
      }
    }
    questions = questions.toSet().toList();

    return Padding(
      padding: MapAppPadding.pageMargins,
      child: Column(
        children: <Widget>[
          Container(
            child: DropdownButton(
              isExpanded: true,
              items: questions
                  .map(
                    (QuestionnaireItem question) =>
                        DropdownMenuItem(value: question.linkId, child: Text(question.text)),
                  )
                  .toList(),
              onChanged: (String selectedLinkId) =>
                  setState(() => this._selectedLinkId = selectedLinkId),
              value: this._selectedLinkId,
              hint: Text("Select a question to see trends"),
            ),
          ),
          Visibility(
              visible: this._selectedLinkId != null,
              child: SizedBox(
                  height: 250.0,
                  child: SimpleTimeSeriesChart.fromQuestionnaireResponses(
                      model, this._selectedLinkId, context)))
        ],
      ),
    );
//    return Expanded(
//        child: ListView.builder(
//            itemCount: 1,
//            shrinkWrap: true,
//            padding: MapAppPadding.cardPageMargins,
//            itemBuilder: (context, i) {
//              return SizedBox(
//                  height: 250.0,
//                  child: SimpleTimeSeriesChart.fromQuestionnaireResponses(
//                      model.questionnaireResponses));
//            }));
  }
}

/// Timeseries chart example
class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.fromQuestionnaireResponses(
      CarePlanModel model, String linkId, BuildContext context) {
    return new SimpleTimeSeriesChart(
      _createTimeSeries(model, linkId, context),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      defaultRenderer: new charts.LineRendererConfig(includePoints: true, includeArea: true),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickFormatterSpec: charts.BasicNumericTickFormatterSpec((num value) {
        switch (value) {
          case 0:
            return "Not at all";
          case 1:
            return "A little bit";
          case 2:
            return "Somewhat";
          case 3:
            return "Quite a bit";
          default:
            return "Very much";
        }
      })),
    );
  }

  static List<charts.Series<AnswerTimeSeries, DateTime>> _createTimeSeries(
      CarePlanModel model, String linkId, BuildContext context) {
    if (linkId == null) return [];
    List<QuestionnaireResponse> responses = model.questionnaireResponses;
    QuestionnaireItem questionnaireItem = model.questionForLinkId(linkId);

    List<AnswerTimeSeries> data = [];
    for (QuestionnaireResponse response in responses) {
      if (response.item != null) {
        var answers =
            response.item.where((QuestionnaireResponseItem r) => r.linkId == linkId).toList();
        if (answers.length > 0) {
          Answer answer = answers[0].answer[0];
          int answerValue = answer.valueInteger;
          if (questionnaireItem.answerOption[0].extension != null &&
              questionnaireItem.answerOption[0].extension
                  .any((Extension e) => e.url.contains("ordinalValue"))) {
            AnswerOption option = questionnaireItem.answerOption
                .firstWhere((AnswerOption o) => answer == o, orElse: () => null);
            if (option != null) {
              answerValue = option.extension
                  .firstWhere((Extension e) => e.url.contains("ordinalValue"))
                  .valueDecimal;
            }
          }
          data.add(AnswerTimeSeries(response.authored, answerValue));
        }
      }
    }
    data.sort((AnswerTimeSeries a, AnswerTimeSeries b) => a.time.compareTo(b.time));

    return [
      new charts.Series<AnswerTimeSeries, DateTime>(
        id: 'Answers',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Theme.of(context).accentColor),
        areaColorFn: (_, __) => charts.ColorUtil.fromDartColor(Theme.of(context).highlightColor),
        domainFn: (AnswerTimeSeries series, _) => series.time,
        measureFn: (AnswerTimeSeries series, _) => series.answer,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class AnswerTimeSeries {
  final DateTime time;
  final int answer;

  AnswerTimeSeries(this.time, this.answer);
}
