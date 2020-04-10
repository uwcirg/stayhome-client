/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:map_app_flutter/HistoryLineListingWidget.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/PlanPage.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/map_app_widgets.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:map_app_flutter/trends_charts.dart';
import 'package:scoped_model/scoped_model.dart';

class ProgressInsightsPage extends StatefulWidget {
  @override
  State createState() => new _ProgressInsightsPageState();
}

class _ProgressInsightsPageState extends State<ProgressInsightsPage> {
  String _selectedLinkId;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: MapAppPageScaffold.tabbed(tabs: [
        Tab(icon: Icon(Icons.calendar_today)),
        Tab(icon: Icon(Icons.show_chart)),
        Tab(icon: Icon(Icons.list)),
      ], tabViews: [
        _calendarTabView(),
        _chartTabView(),
        _listTabView(),
      ], tabPageTitles: [S.of(context).calendar,S.of(context).my_trends, S.of(context).history]),
    );
  }

  Widget _calendarTabView() {
    return ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
      Widget errorWidget = MapAppErrorMessage.fromModel(model, context);
      if (errorWidget != null) return errorWidget;
      return Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(Dimensions.halfMargin),
                  child: StayHomeTreatmentCalendarWidget(model),
                );
              },
              itemCount: 1,
              shrinkWrap: true,
            ));
    });
  }

  Widget _listTabView() {
    return ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
      Widget errorWidget = MapAppErrorMessage.fromModel(model, context);
      if (errorWidget != null) return errorWidget;
      return HistoryLineListingWidget(model);
    });
  }

  Widget _chartTabView() {
    return ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
      Widget errorWidget = MapAppErrorMessage.fromModel(model, context);
      if (errorWidget != null) return errorWidget;
      List<QuestionnaireItem> questionChoices = questionsToShow(model);
      return _buildChartPage(questionChoices, model, context);
    });
  }

  List<QuestionnaireItem> questionsToShow(CarePlanModel model) {
    return allQuestionsWithAnswers(model);
  }

  List<QuestionnaireItem> allQuestionsWithAnswers(CarePlanModel model) {
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
    return questionChoices;
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
            hint: Text(S.of(context).select_trend_text),
          ),
        ),
        Visibility(
          visible: this._selectedLinkId != null,
          child: ChartWidget(_selectedLinkId, model),
        )
      ],
    );
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
    if (numberOfItems == 0) {
      return NoDataWidget();
    }
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, i) {
        if (i >= _maxChartsToShow) {
          return Text(S.of(context).more_charts_text);
        }
        return ChartWidget(questionChoices[i].linkId, model);
      },
      itemCount: numberOfItems,
      shrinkWrap: true,
    ));
  }

  @override
  List<QuestionnaireItem> questionsToShow(CarePlanModel model) {
    List<QuestionnaireItem> questionChoices = allQuestionsWithAnswers(model);

    // only show questions from the first questionnaire and only if the type is choice or number
    questionChoices = questionChoices
        .where((QuestionnaireItem i) =>
            model.questionnaires[0].item.contains(i) &&
            (i.type == QuestionType.choice ||
                i.type == QuestionType.decimal ||
                i.type == QuestionType.integer))
        .toList();
    return questionChoices;
  }
}
