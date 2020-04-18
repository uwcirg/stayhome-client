/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/map_app_widgets.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

class SwitchFormField extends FormField<bool> {
  final String title;
  final Function(bool) onChanged;

  SwitchFormField({this.title, bool initialValue, this.onChanged})
      : super(
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return SwitchListTile(
                  contentPadding: const EdgeInsets.all(0.0),
                  title: Text(
                    title ?? "",
                    style: Theme.of(state.context).textTheme.body1,
                  ),
                  value: state.value,
                  onChanged: (value) {
                    onChanged(value);
                    state.didChange(value);
                  },
                  activeColor: Theme.of(state.context).primaryColor);
            });
}

class ProgramConsentWidget extends StatefulWidget {
  final Reference consentGroupRef;

  final String expandedTextMarkdown;
  final String shareItemLabel;
  final String programTitle;

  const ProgramConsentWidget(
      {Key key,
      this.programTitle,
      this.consentGroupRef,
      this.expandedTextMarkdown,
      this.shareItemLabel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ProgramConsentWidgetState();
}

class ProgramConsentWidgetState extends State<ProgramConsentWidget> {
  bool isProgramMember = false;

  ProgramConsentWidgetState();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CarePlanModel>(
        rebuildOnChange: true,
        builder: (context, child, model) {
          ConsentGroup consentGroup = model.consents[widget.consentGroupRef];

          // open the program consent widget if consent has been given.
          if (consentGroup.shareAll) isProgramMember = true;

          Widget programTitle = SwitchFormField(
            title: widget.programTitle,
            initialValue: isProgramMember,
            onChanged: (newValue) {
              setState(() {
                this.isProgramMember = newValue;
                if (!isProgramMember) {
                  consentGroup.shareAll = false;
                }
              });
            },
          );

          if (!isProgramMember) {
            return programTitle;
          }

          return Column(
            children: <Widget>[
              programTitle,
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.fullMargin, vertical: Dimensions.halfMargin),
                color: Theme.of(context).highlightColor,
                child: Column(children: [
                  paragraph(widget.expandedTextMarkdown),
                  SwitchFormField(
                    title: widget.shareItemLabel,
                    initialValue: consentGroup.shareAll,
                    onChanged: (newValue) {
                      consentGroup.shareAll = newValue;
                    },
                  ),
                ]),
              )
            ],
          );
        });
  }
}

class ConsentGroupWidget extends StatefulWidget {
  final Reference consentGroupRef;

  const ConsentGroupWidget({Key key, this.consentGroupRef}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConsentGroupWidgetState();
}

class ConsentGroupWidgetState extends State<ConsentGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CarePlanModel>(
        rebuildOnChange: true,
        builder: (context, child, model) {
          ConsentGroup consentGroup = model.consents[widget.consentGroupRef];

          return Column(
            children: <Widget>[
              SwitchFormField(
                title: "Share my symptoms, testing, and health conditions",
                initialValue: consentGroup.shareSymptoms,
                onChanged: (value) {
                  consentGroup.shareSymptoms = value;
                },
              ),
              SwitchFormField(
                title: "Share my general location (zip code)",
                initialValue: consentGroup.shareLocation,
                onChanged: (value) {
                  consentGroup.shareLocation = value;
                },
              ),
              SwitchFormField(
                title: "Share my name and contact information (email and/or phone number)",
                initialValue: consentGroup.shareContactInfo,
                onChanged: (value) {
                  consentGroup.shareContactInfo = value;
                },
              ),
            ],
          );
        });
  }
}
