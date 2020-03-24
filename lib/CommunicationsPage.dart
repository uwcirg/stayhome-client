/*
 * Copyright (c) 2020 CIRG. All rights reserved. 
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/map_app_widgets.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

class CommunicationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      child: ScopedModelDescendant<CarePlanModel>(
        builder: (context, child, model) {
          Widget errorWidget = MapAppErrorMessage.fromModel(model, context);
          if (errorWidget != null) return errorWidget;
          return _buildScreen(model);
        },
        rebuildOnChange: true,
      ),
      title: "communications",
    );
  }

  Widget _buildScreen(CarePlanModel model) {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, i) {
        return Theme(
          // override the accent color here to make the expansion tile's header be purple (not the
          // default gold/accent color). caveat: overriding the color like this will cause the
          // accent color to be incorrect in all children (e.g. notification widget).
          data: Theme.of(context).copyWith(accentColor: Theme.of(context).primaryColor),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(i == 0 ? "Active" : "Completed"),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: Dimensions.fullMargin,
                    right: Dimensions.fullMargin,
                    bottom: Dimensions.fullMargin),
                child:
                    i == 0 ? ActiveNotificationsWidget(model) : NonActiveNotificationsWidget(model),
              )
            ],
          ),
        );
      },
      itemCount: 2,
      shrinkWrap: true,
    ));
  }
}

class ActiveNotificationsWidget extends StatelessWidget {
  final CarePlanModel model;

  const ActiveNotificationsWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return NotificationsWidget(
      model.activeCommunications,
      onButtonPress: (Communication c) {
        c.status = CommunicationStatus.completed;
        this.model.updateCommunication(c);
      },
    );
  }
}

class NonActiveNotificationsWidget extends StatelessWidget {
  final CarePlanModel model;

  const NonActiveNotificationsWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return NotificationsWidget(model.nonActiveCommunications);
  }
}

class NotificationsWidget extends StatelessWidget {
  final List<Communication> communications;
  final Function(Communication) onButtonPress;

  const NotificationsWidget(this.communications, {this.onButtonPress});

  @override
  Widget build(BuildContext context) {
    if (communications == null || communications.isEmpty) {
      return Text("Nothing here", style: Theme.of(context).textTheme.caption);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: communications.map((Communication c) {
        String text = c.payload[0]?.contentString ?? "<no content>";
        return Card(
          color: _colorForPriority(c.priority),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.halfMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  c.sent != null
                      ? "${DateFormat.MEd().format(c.sent)} ${DateFormat.jm().format(c.sent)}"
                      : "No date",
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(text),
                Visibility(
                  visible: onButtonPress != null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      OutlineButton(child: Text("Dismiss"), onPressed: () => onButtonPress(c)),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  _colorForPriority(Priority priority) {
    switch (priority) {
      case Priority.routine:
        return Colors.blue[50];
      case Priority.urgent:
        return Colors.yellow[50];
      case Priority.asap:
        return Colors.orange[50];
      case Priority.stat:
        return Colors.red[50];
      default:
        return Colors.grey[50];
    }
  }
}
