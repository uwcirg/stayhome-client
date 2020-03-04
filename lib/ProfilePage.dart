import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/model/AppModel.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:scoped_model/scoped_model.dart';

import 'main.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _updateState = false;
  var _error = "";

  @override
  Widget build(BuildContext context) {
    String title = S
        .of(context)
        .profile;

    if (MyApp
        .of(context)
        .auth
        .userInfo != null) {
      return MapAppPageScaffold(
          title: title,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.fullMargin),
            child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
              var firstName = model.patient.name[0].given[0] ?? MyApp
                  .of(context)
                  .auth
                  .userInfo
                  .givenName;
              var lastName = model.patient.name[0].family ?? MyApp
                  .of(context)
                  .auth
                  .userInfo
                  .familyName;
              var email = model.patient.emailAddress ?? MyApp
                  .of(context)
                  .auth
                  .userInfo
                  .email;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: S
                            .of(context)
                            .what_is_your_name,
                        labelText: "First name"),
                    initialValue: firstName,
                    onFieldSubmitted: (String text) {model.patient.name[0].given[0] = text;},
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(null),
                        hintText: S
                            .of(context)
                            .what_is_your_name,
                        labelText: "Last name"),
                    initialValue: lastName,
                    onFieldSubmitted: (String text) {model.patient.name[0].family = text;},
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        hintText: S
                            .of(context)
                            .what_is_your_email_address,
                        labelText: S
                            .of(context)
                            .email),
                    initialValue: email,
                    onFieldSubmitted: (String text) {model.patient.emailAddress = text;},
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.phone),
                        hintText: "What is your phone number?",
                        labelText: "Phone"),
                    initialValue: model.patient.phoneNumber,
                    onFieldSubmitted: (String text) {model.patient.phoneNumber = text;},
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.contact_mail),
                        hintText: "What is your address?",
                        labelText: "Address"),
                    initialValue: model.patient.address[0]?.toString(),
                    onFieldSubmitted: (String text) {
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.largeMargin),
                    child: Center(
                      child: OutlineButton(
                        child: Text(S
                            .of(context)
                            .logout),
                        onPressed: () => logout(context),
                      ),
                    ),
                  ),
                  Divider(),
                  Text(
                    "CouchDB debug area",
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle,
                  ),
//                  ScopedModelDescendant<AppModel>(
//                    builder: (context, child, model) {
//                      if (model.docExample != null) {
//                        return Text(
//                            "CouchDB object content: ${model.docExample.getString("click")}");
//                      } else {
//                        return CircularProgressIndicator();
//                      }
//                    },
//                    rebuildOnChange: true,
//                  ),
                ],
              );
            }
            ),
          ));
    }
    if (_error != null) {
      return MapAppPageScaffold(
        title: title,
        child: Text(_error),
      );
    }
    return MapAppPageScaffold(
        title: title, child: new CircularProgressIndicator());
  }

  void logout(BuildContext context) {
    MyApp
        .of(context)
        .auth
        .mapAppLogout()
        .then((value) {
      setState(() {
        _updateState = !_updateState;
      });
      Navigator.of(context).pushNamed("/login");
    });
  }

}
