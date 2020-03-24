/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_app_flutter/ProfilePage.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/main.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';

class MapAppErrorMessage extends StatelessWidget {
  final String _message;
  final String _buttonLabel;
  final Function _onPressed;

  const MapAppErrorMessage(this._message, {String buttonLabel, Function onButtonPressed})
      : _buttonLabel = buttonLabel,
        _onPressed = onButtonPressed;

  factory MapAppErrorMessage.loadingErrorWithLogoutButton(BuildContext context) {
    return MapAppErrorMessage(
      S.of(context).loading_error_log_in_again,
      buttonLabel: "logout",
      onButtonPressed: () => MyApp.of(context).logout(context: context),
    );
  }

  factory MapAppErrorMessage.modelError(CarePlanModel model) {
    return MapAppErrorMessage('${model.error}');
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Center(child: Padding(
        padding: const EdgeInsets.all(Dimensions.halfMargin),
        child: Text(_message, textAlign: TextAlign.center),
      )),
    ];
    if (_buttonLabel != null) {
      children.add(RaisedButton(child: Text(_buttonLabel), onPressed: _onPressed));
    }
    return Column(children: children);
  }

  static Widget fromModel(CarePlanModel model, BuildContext context) {
    if (model == null) {
      print("Model is null.");
      return MapAppErrorMessage.loadingErrorWithLogoutButton(context);
    }
    if (model.error != null) {
      return MapAppErrorMessage('${model.error}');
    }

    if (model.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (model.hasNoUser) {
      return MapAppErrorMessage.loadingErrorWithLogoutButton(context);
    }

    if (model.hasNoPatient) {
      return MapAppErrorMessage(
        "You do not have a patient record in the FHIR database.",
        buttonLabel: "create one",
        onButtonPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateProfilePage())),
      );
    }

    if (model.hasNoCarePlan) {
      return MapAppErrorMessage(
        S.of(context).you_have_no_active_pelvic_floor_management_careplan,
        buttonLabel: S.of(context).add_the_default_careplan_for_me,
        onButtonPressed: () => model.addDefaultCareplan(),
      );
    }
    return null;
  }
}
