/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';

class DemoVersionWarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: !Foundation.kReleaseMode,
        child: Container(
            padding: const EdgeInsets.all(Dimensions.quarterMargin),
            color: Colors.amber.shade100,
            child: Text(
              S.of(context).demoVersionBannerText,
              textAlign: Theme.of(context).platform == TargetPlatform.iOS
                  ? TextAlign.center
                  : TextAlign.start,
            )));
  }
}