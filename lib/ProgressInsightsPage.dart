/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

class ProgressInsightsPage extends StatefulWidget {
  @override
  State createState() => new _ProgressInsightsPageState();
}

class _ProgressInsightsPageState extends State<ProgressInsightsPage> {
  String _selectedLinkId;

  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        title: "Trends",
        child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
          if (model.questionnaireResponses == null)
            return Container(
              height: 0,
            );

          List<QuestionnaireItem> questionChoices = [];

          for (QuestionnaireResponse q in model.questionnaireResponses) {
            if (q.item != null) {
              for (QuestionnaireResponseItem i in q.item) {
                var questionForLinkId = model.questionForLinkId(i.linkId);
                if (questionForLinkId != null) questionChoices.add(questionForLinkId);
              }
            }
          }
          questionChoices = questionChoices.toSet().toList();

          return _buildChartPage(questionChoices, model, context);
        }));
  }

  Widget _buildChartPage(
      List<QuestionnaireItem> questionChoices, CarePlanModel model, BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: MapAppPadding.pageMargins,
          child: DropdownButton(
            isExpanded: true,
            items: questionChoices
                .map((QuestionnaireItem question) =>
                    DropdownMenuItem(value: question.linkId, child: Text(question.text)))
                .toList(),
            onChanged: (String selectedLinkId) =>
                setState(() => this._selectedLinkId = selectedLinkId),
            value: this._selectedLinkId,
            hint: Text("Select a question to see trends"),
          ),
        ),
        Visibility(
          visible: this._selectedLinkId != null,
          child: _buildChartWidget(_selectedLinkId, model, context),
        )
      ],
    );
  }

  Widget _buildChartWidget(String linkId, CarePlanModel model, BuildContext context) {
    charts.NumericAxisSpec displayMappingSpec =
        SimpleTimeSeriesChart._displayMappingSpec(model, linkId);
    var timeSeries = SimpleTimeSeriesChart._createTimeSeries(model, linkId, context);

    QuestionnaireItem question = model.questionForLinkId(linkId);
    var chart;
    if (question.code.firstWhere((Coding c) => c.system.contains("loinc")).code == "8310-5") {
      chart = _temperatureChart(timeSeries, displayMappingSpec);
    } else {
      chart = _chart(timeSeries, displayMappingSpec);
    }
    return Padding(
      padding: const EdgeInsets.all(Dimensions.fullMargin),
      child: Column(
        children: <Widget>[
          Center(child: Text(question.text)),
          SizedBox(height: 250.0, child: chart),
        ],
      ),
    );
  }

  Widget _chart(
      List<charts.Series<AnswerTimeSeries, DateTime>> timeSeries, var displayMappingSpec) {
    return SimpleTimeSeriesChart(timeSeries, animate: true, displayMappingSpec: displayMappingSpec);
  }

  Widget _temperatureChart(
      List<charts.Series<AnswerTimeSeries, DateTime>> timeSeries, var displayMappingSpec) {
    return charts.TimeSeriesChart(timeSeries,
        animate: true,
        primaryMeasureAxis: charts.NumericAxisSpec.from(displayMappingSpec,
            tickProviderSpec: new charts.BasicNumericTickProviderSpec(zeroBound: false)),
        behaviors: [
          new charts.RangeAnnotation([
            new charts.RangeAnnotationSegment(97, 99, charts.RangeAnnotationAxisType.measure,
                labelAnchor: charts.AnnotationLabelAnchor.end,
                color: charts.ColorUtil.fromDartColor(Theme.of(context).accentColor))
          ], defaultLabelPosition: charts.AnnotationLabelPosition.margin),
        ]);
  }
}

class StayHomeTrendsPage extends ProgressInsightsPage {
  @override
  State<StatefulWidget> createState() => _StayHomeTrendsPageState();
}

class _StayHomeTrendsPageState extends _ProgressInsightsPageState {
  final int _maxChartsToShow = 8;

  @override
  Widget _buildChartPage(
      List<QuestionnaireItem> questionChoices, CarePlanModel model, BuildContext context) {
    int numberOfItems = questionChoices.length;
    if (numberOfItems > _maxChartsToShow) {
      numberOfItems = _maxChartsToShow + 1;
    }
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, i) {
        if (i >= _maxChartsToShow) {
          return Text("There are more children which aren't shown.");
        }
        return _buildChartWidget(questionChoices[i].linkId, model, context);
      },
      itemCount: numberOfItems,
      shrinkWrap: true,
    ));
  }
}

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  var displayMappingSpec;

  SimpleTimeSeriesChart(this.seriesList, {this.animate, this.displayMappingSpec});

  static charts.NumericAxisSpec _displayMappingSpec(CarePlanModel model, String linkId) {
    var displayMappings = _displayMappings(model, linkId);
    return new charts.NumericAxisSpec(
        tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
            (num measure) => displayMappings != null ? displayMappings[measure] : '$measure'));
  }

  static Map<num, String> _displayMappings(CarePlanModel model, String linkId) {
    QuestionnaireItem questionnaireItem = model.questionForLinkId(linkId);
    if (questionnaireItem.answerOption == null || questionnaireItem.answerOption.isEmpty) {
      return null;
    }
    var displayMappings = new Map<num, String>();
    questionnaireItem.answerOption.forEach((AnswerOption option) {
      if (option.extension != null &&
          option.extension.any((Extension e) => e.url.contains("ordinalValue"))) {
        String name = option.valueCoding.toString();
        num value = option.extension
            .firstWhere((Extension e) => e.url.contains("ordinalValue"))
            .valueDecimal
            .toDouble();
        displayMappings[value] = name;
      }
    });
    return displayMappings;
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      defaultRenderer: new charts.LineRendererConfig(includePoints: true, includeArea: false),
      primaryMeasureAxis: displayMappingSpec,
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
        if (answers.length > 0 && answers[0].answer != null && answers[0].answer.length > 0) {
          Answer answer = answers[0].answer[0];
          double answerValue = answer.valueDecimal;
          if (answerValue == null) answerValue = answer.valueInteger as double;
          if (questionnaireItem.answerOption != null && questionnaireItem.answerOption.length > 0) {
            if (questionnaireItem.answerOption[0].extension != null &&
                questionnaireItem.answerOption[0].extension
                    .any((Extension e) => e.url.contains("ordinalValue"))) {
              AnswerOption option = questionnaireItem.answerOption
                  .firstWhere((AnswerOption o) => answer == o, orElse: () => null);
              if (option != null) {
                answerValue = option.extension
                    .firstWhere((Extension e) => e.url.contains("ordinalValue"))
                    .valueDecimal
                    .toDouble();
              }
            }
          }
          data.add(AnswerTimeSeries(response.authored, answer, answerValue));
        }
      }
    }
    data.sort((AnswerTimeSeries a, AnswerTimeSeries b) => a.time.compareTo(b.time));

    return [
      new charts.Series<AnswerTimeSeries, DateTime>(
        id: 'Answers',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
        areaColorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Theme.of(context).highlightColor.withAlpha(150)),
        domainFn: (AnswerTimeSeries series, _) => series.time,
        measureFn: (AnswerTimeSeries series, _) => series.displayValue,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class AnswerTimeSeries {
  final DateTime time;
  final Answer answer;
  final double displayValue;

  AnswerTimeSeries(this.time, this.answer, this.displayValue);
}
