/*
 * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

class WhatPage extends StatefulWidget {

  WhatPage();
  static _WhatPageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_WhatPageState>());

  @override
  _WhatPageState createState() => _WhatPageState();
}

class _WhatPageState extends State<WhatPage> {

  _WhatPageState();

  @override
  Widget build(BuildContext context) {
     return MapAppPageScaffold(
        title: "What is StayHome",
        child: ScopedModelDescendant<CarePlanModel>(
            builder: (context, child, model) => _buildContent(context)));
  }

  Widget _buildContent(context) {
    return  Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("What is StayHome?")
      );
  }
}
