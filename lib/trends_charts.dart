/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';

class ChartWidget extends StatefulWidget {
  final String _linkId;
  final CarePlanModel _model;
  final bool animate;

  ChartWidget(this._linkId, this._model, {this.animate = false});

  @override
  State<StatefulWidget> createState() => ChartWidgetState(_linkId, _model);
}

class ChartWidgetState extends State<ChartWidget> {
  String _linkId;
  DateTime _time;
  CarePlanModel _model;
  Map<String, Answer> _measures;

  ChartWidgetState(this._linkId, this._model);

  @override
  Widget build(BuildContext context) {
    return _buildChartWidget(_linkId, _model, context);
  }

  Widget _buildChartWidget(String linkId, CarePlanModel model, BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;
    charts.NumericAxisSpec displayMappingSpec = _displayMappingSpec(model, linkId, languageCode);
    var timeSeries = _createTimeSeries(model, linkId, context);

    QuestionnaireItem question = model.questionForLinkId(linkId);
    var chart;
    if (question.isTemperature()) {
      chart = _temperatureChart(timeSeries, displayMappingSpec);
    } else {
      chart = _chart(timeSeries, displayMappingSpec);
    }
    String selectedDate = _time != null ? '${DateFormat.MMMd().add_jm().format(_time)}' : "";
    return Padding(
      padding: const EdgeInsets.all(Dimensions.fullMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.halfMargin),
            child: Text(
              question.text,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Stack(
            children: <Widget>[
              SizedBox(height: 250.0, child: chart),
              Visibility(
                  visible: _time != null,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      selectedDate,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${_measures != null ? _measures['Answers'].displayString(languageCode) : ""}'),
                    )
                  ]))
            ],
          ),
        ],
      ),
    );
  }

  Widget _chart(
      List<charts.Series<AnswerTimeSeries, DateTime>> timeSeries, var displayMappingSpec) {
    return new charts.TimeSeriesChart(
      timeSeries,
      animate: widget.animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      defaultRenderer: new charts.LineRendererConfig(includePoints: true, includeArea: false),
      primaryMeasureAxis: displayMappingSpec,
      selectionModels: [
        charts.SelectionModelConfig(
            type: charts.SelectionModelType.info, changedListener: _onSelectionChangedListener)
      ],
      behaviors: [
        new charts.InitialSelection(
            selectedDataConfig: [new charts.SeriesDatumConfig('Answers', _time)]),
        new charts.PanAndZoomBehavior()
      ],
    );
  }

  Widget _temperatureChart(
      List<charts.Series<AnswerTimeSeries, DateTime>> timeSeries, var displayMappingSpec) {
    return charts.TimeSeriesChart(
      timeSeries,
      animate: widget.animate,
      primaryMeasureAxis: charts.NumericAxisSpec.from(displayMappingSpec,
          tickProviderSpec: new charts.BasicNumericTickProviderSpec(zeroBound: false)),
      behaviors: [
        new charts.RangeAnnotation([
          new charts.RangeAnnotationSegment(97, 99, charts.RangeAnnotationAxisType.measure,
              labelAnchor: charts.AnnotationLabelAnchor.end,
              color: charts.ColorUtil.fromDartColor(Theme.of(context).accentColor))
        ], defaultLabelPosition: charts.AnnotationLabelPosition.margin),
        new charts.InitialSelection(
            selectedDataConfig: [new charts.SeriesDatumConfig('Answers', _time)])
      ],
      selectionModels: [
        charts.SelectionModelConfig(
            type: charts.SelectionModelType.info, changedListener: _onSelectionChangedListener)
      ],
    );
  }

  _onSelectionChangedListener(charts.SelectionModel<DateTime> model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, Answer>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        Answer answer = datumPair.datum.answer as Answer;
        measures[datumPair.series.displayName] = answer;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  static charts.NumericAxisSpec _displayMappingSpec(
      CarePlanModel model, String linkId, String languageCode) {
    var displayMappings = _displayMappings(model, linkId, languageCode);

    List<num> keys = displayMappings?.keys?.toList();
    keys?.sort();
    num minVal = keys?.first;
    num maxVal = keys?.last;

    return new charts.NumericAxisSpec(
      tickFormatterSpec: charts.BasicNumericTickFormatterSpec((num measure) {
        if (displayMappings == null) return '$measure';
        var displayName = displayMappings[measure];
        if (displayName == null) return "";
        return displayName;
      }),
      viewport: displayMappings != null ? new charts.NumericExtents(minVal, maxVal) : null,
    );
  }

  static Map<num, String> _displayMappings(
      CarePlanModel model, String linkId, String languageCode) {
    QuestionnaireItem questionnaireItem = model.questionForLinkId(linkId);
    if (questionnaireItem.answerOption == null || questionnaireItem.answerOption.isEmpty) {
      return null;
    }
    var displayMappings = new Map<num, String>();
    questionnaireItem.answerOption.forEach((AnswerOption option) {
      if (option.extension != null &&
          option.extension.any((Extension e) => e.url.contains("ordinalValue"))) {
        String name = option.valueCoding.display;
        num value = option.extension
            .firstWhere((Extension e) => e.url.contains("ordinalValue"))
            .valueDecimal
            .toDouble();
        displayMappings[value] = name;
      }
    });
    return displayMappings;
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
