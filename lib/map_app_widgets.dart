/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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

  factory MapAppErrorMessage.loadingErrorWithLogout(BuildContext context) {
    /*
     * if loading error and user is logged in, attempts to log in again
     */
    if (MyApp.of(context).auth.isLoggedIn) {
      MyApp.of(context)
          .auth
          .mapAppLogin()
          .then((value) => MyApp.of(context).dismissLoginScreen(context))
          .catchError((error) {
        snack("$error", context);
        MyApp.of(context).logout(pushLogin: true, context: context);
      });
    } else {
      MyApp.of(context).logout(pushLogin: true, context: context);
    }
    var message = MyApp.of(context).auth.isLoggedIn
        ? S.of(context).attempt_login_text
        : S.of(context).loading_error_log_in_again;
    return MapAppErrorMessage(message);
  }

  factory MapAppErrorMessage.modelError(CarePlanModel model) {
    return MapAppErrorMessage('${model.error}');
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Center(
          child: Padding(
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
      return MapAppErrorMessage.loadingErrorWithLogout(context);
    }
    if (model.error != null) {
      return MapAppErrorMessage('${model.error}');
    }

    if (model.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (model.hasNoUser) {
      return MapAppErrorMessage.loadingErrorWithLogout(context);
    }

    if (model.hasNoPatient) {
      return MapAppErrorMessage(
        S.of(context).no_FHIR_patient_record_text,
        buttonLabel: S.of(context).create_one,
        onButtonPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CreateProfilePage())),
      );
    }

    if (model.hasNoCarePlan) {
      return MapAppErrorMessage(
        S.of(context).no_active_careplan_text,
        buttonLabel: S.of(context).add_the_default_careplan_for_me,
        onButtonPressed: () => model.addDefaultCarePlan(),
      );
    }
    return null;
  }
}

class NoDataWidget extends StatelessWidget {
  final String text;

  const NoDataWidget(
      {this.text = "No data to show yet. Start tracking and your data will show here."});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: MapAppPadding.pageMargins,
      child: Text(
        text,
        style: Theme.of(context).textTheme.caption,
        textAlign: TextAlign.center,
      ),
    ));
  }
}

class SaveAndCancelBar extends StatelessWidget {
  final Function onCancel;
  final Function onSave;

  SaveAndCancelBar({this.onCancel, this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.largeMargin),
      child: Center(
          child: Wrap(
        spacing: Dimensions.halfMargin,
        runSpacing: Dimensions.fullMargin,
        children: <Widget>[
          SecondaryButton(
            child: Text(S.of(context).cancel),
            onPressed: onCancel,
          ),
          RaisedButton(
            padding: MapAppPadding.largeButtonPadding,
            child: Text(S.of(context).save, style: Theme.of(context).textTheme.button),
            onPressed: onSave,
          )
        ],
      )),
    );
  }
}

buildSectionHeader(String text, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: Dimensions.largeMargin, bottom: 4),
    child: Text(text, style: Theme.of(context).textTheme.headline6),
  );
}

Widget paragraph(String text) => padded(MarkdownBody(data: text));

Widget padded(Widget w) => Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.quarterMargin),
      child: w,
    );

class SecondaryButton extends OutlineButton {
  const SecondaryButton({
    Key key,
    @required VoidCallback onPressed,
    Widget child,
    EdgeInsets padding,
    ShapeBorder shape,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: child,
          borderSide: const BorderSide(
            width: 2,
            color: const Color(0x1f000000)
          ),
          padding: padding,
          shape: shape,
        );
}
