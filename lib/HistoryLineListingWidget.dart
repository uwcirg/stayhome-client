/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/map_app_widgets.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';

class HistoryLineListingWidget extends StatelessWidget {
  final CarePlanModel model;

  const HistoryLineListingWidget(this.model);

  @override
  Widget build(BuildContext context) {
    if (model.questionnaireResponses == null || model.questionnaireResponses.isEmpty) {
      return NoDataWidget();
    }
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, i) => _buildQuestionnaireResponseView(context, i, model),
        itemCount: model.questionnaireResponses.length,
        shrinkWrap: true,
      ),
    );
  }

  _buildQuestionnaireResponseView(BuildContext context, int i, CarePlanModel model) {
    QuestionnaireResponse response = model.questionnaireResponses[i];
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Theme.of(context).primaryColor),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              response.authored != null
                  ? DateFormat.yMd().add_jm().format(response.authored)
                  : S.of(context).no_date,
              style: Theme.of(context).textTheme.caption,
            ),
            Text(model
                .questionnaireForResponse(response)
                .titleLocalized(Localizations.localeOf(context).languageCode))
          ],
        ),
        children: response.item
                ?.map((QuestionnaireResponseItem responseItem) =>
                    _buildQuestionnaireResponseItemView(context, responseItem))
                ?.toList() ??
            [NoDataWidget(text: S.of(context).no_data)],
      ),
    );
  }

  Widget _buildQuestionnaireResponseItemView(
      BuildContext context, QuestionnaireResponseItem responseItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.fullMargin, vertical: Dimensions.quarterMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            model
                .questionForLinkId(responseItem.linkId)
                .textLocalized(Localizations.localeOf(context).languageCode),
            style: Theme.of(context).textTheme.caption,
          ),
          Text(responseItem.answerDisplay)
        ],
      ),
    );
  }
}
