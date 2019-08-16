/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';

class DevicesPage extends StatefulWidget {
  @override
  State createState() {
    return new _DevicesPageState();
  }
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        title: S.of(context).devices,
        child: Expanded(
            child: ListView.builder(
          padding: const EdgeInsets.all(Dimensions.halfMargin),
          itemBuilder: (context, i) {
            return DeviceWidget(Device.devices()[i]);
          },
          itemCount: Device.devices().length,
          shrinkWrap: true,
        )));
  }
}

class Device {
  final String name;
  final double batteryLevel;
  final DateTime lastSynced;

  Device(this.name, this.batteryLevel, this.lastSynced);

  static devices() {
    return [
      Device("My vFit", 0.98, DateTime(2019, 8, 15, 13, 56, 12)),
      Device("My vFit PLUS", 0.62, DateTime(2019, 8, 14, 12, 01, 38)),
      Device("My other vFit", 0.28, DateTime(1976, 8, 14, 12, 01, 38)),
    ];
  }
}

class DeviceWidget extends StatelessWidget {
  final Device _device;

  DeviceWidget(this._device);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.halfMargin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _device.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            right: Dimensions.quarterMargin),
                        child: Icon(batteryIcon(_device.batteryLevel)),
                      ),
                      Text(S.of(context).battery_level("${(_device.batteryLevel * 100).round()}"))
                    ],
                  ),
                  Text(
                      S.of(context).last_synced_date(DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(_device.lastSynced), DateFormat(S.of(context).timeFormat).format(_device.lastSynced)))
                ],
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return [S.of(context).rename, S.of(context).forget, S.of(context).more_info]
                    .map((String menuItemName) =>
                        PopupMenuItem(child: Text(menuItemName)))
                    .toList();
              },
            )
          ],
        ),
      ),
    );
  }

  IconData batteryIcon(double batteryLevel) {
    if (batteryLevel > 0.9) return CupertinoIcons.battery_full;
    if (batteryLevel > 0.5) return CupertinoIcons.battery_75_percent;
    if (batteryLevel > 0.25) return CupertinoIcons.battery_25_percent;
    return CupertinoIcons.battery_empty;
  }
}
