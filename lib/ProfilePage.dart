import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:map_app_flutter/KeycloakAuth.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/generated/l10n.dart';
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
  var _error = "";

  @override
  Widget build(BuildContext context) {
    String title = S.of(context).profile;

    if (MyApp.of(context).auth.userInfo != null) {
      return MapAppPageScaffold(
          title: title,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.fullMargin),
            child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
              return Column(
                children: [
                  ProfileWidget(model.patient, MyApp.of(context).auth.userInfo,
                      (Patient patient) => model.updatePatientResource(patient)),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.largeMargin),
                    child: Center(
                      child: OutlineButton(
                        child: Text(S.of(context).logout),
                        onPressed: () => logout(context),
                      ),
                    ),
                  ),
//                  Text(
//                    "CouchDB debug area",
//                    style: Theme
//                        .of(context)
//                        .textTheme
//                        .subtitle,
//                  ),
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
            }),
          ));
    }
    if (_error != null) {
      return MapAppPageScaffold(
        title: title,
        child: Text(_error),
      );
    }
    return MapAppPageScaffold(title: title, child: new CircularProgressIndicator());
  }

  void logout(BuildContext context) {
    MyApp.of(context).logout(context: context);
  }
}

class CreateProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
        title: "create patient record",
        showDrawer: false,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.fullMargin),
          child: ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
            return ProfileWidget(model.patient, MyApp.of(context).auth.userInfo, (Patient patient) {
              model.updatePatientResource(patient);
              Navigator.of(context).pop();
            });
          }),
        ));
  }
}

class ProfileWidget extends StatefulWidget {
  final Patient _patient;
  final UserInfo _userInfo;
  final Function _onPressed;

  ProfileWidget(this._patient, this._userInfo, this._onPressed);

  @override
  State createState() => ProfileWidgetState(this._patient, this._userInfo, this._onPressed);
}

class ProfileWidgetState extends State<ProfileWidget> {
  final Patient _originalPatient;
  final UserInfo _userInfo;
  final Function _onPressed;

  final _formKey = GlobalKey<FormState>();

  ProfileWidgetState(Patient patient, this._userInfo, this._onPressed)
      : this._originalPatient = patient != null ? Patient.fromJson(patient.toJson()) : Patient();

  @override
  Widget build(BuildContext context) {
    String firstName = _originalPatient.firstName ?? _userInfo.givenName;
    String lastName = _originalPatient.lastName ?? _userInfo.familyName;
    String email = _originalPatient.emailAddress ?? _userInfo.email;
    String phone = _originalPatient.phoneNumber;
    String zip = _originalPatient.zipcode;
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: S.of(context).what_is_your_name,
                labelText: "First name"),
            initialValue: firstName,
            validator: (value) {
              if (value.isEmpty) {
                return 'This field is required';
              }
              firstName = value;
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                icon: Icon(null),
                hintText: S.of(context).what_is_your_name,
                labelText: "Last name"),
            initialValue: lastName,
            validator: (value) {
              if (value.isEmpty) {
                return 'This field is required';
              }
              lastName = value;
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                icon: Icon(Icons.email),
                hintText: S.of(context).what_is_your_email_address,
                labelText: S.of(context).email),
            initialValue: email,
            validator: (value) {
              if (!isValid("email", value)) {
                return "A valid email address is required";
              }
              email = value;
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                icon: Icon(Icons.phone),
                hintText: "What is your phone number?",
                labelText: "Phone"),
            initialValue: phone,
            validator: (value) {
              if (value.isNotEmpty && !isValid("phone", value)) {
                return "A valid phone number is required";
              }
              phone = value;
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                icon: Icon(Icons.contact_mail),
                hintText: "What is your zip code?",
                labelText: "Zip code"),
            initialValue: zip,
            validator: (value) {
              // empty zip code is allowed
              if (value.isNotEmpty && !isValid("zip", value)) {
                return "A valid zip code is required";
              }
              zip = value;
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: Dimensions.largeMargin),
            child: Center(
              child: OutlineButton(
                child: Text("save"),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _onPressed(Patient.fromNewPatientForm(_originalPatient,
                        firstName: firstName,
                        lastName: lastName,
                        phoneNumber: phone,
                        emailAddress: email,
                        zipCode: zip));
                  }
                },
              ),
            ),
          ),
        ]));
  }

  isValid(String type, String toValidate) {
    String source;
    switch (type) {
      case "email":
        source =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
        break;
      case "phone":
        source = r"^(1?)(-| ?)(\()?([0-9]{3})(\)|-| |\)-|\) )?([0-9]{3})(-| )?([0-9]{4}|[0-9]{4})$";
        break;
      case "zip":
        source = r"^\d{5}-\d{4}|\d{5}|[A-Z]\d[A-Z] \d[A-Z]\d$";
        break;
      default:
        throw ArgumentError("No such type");
    }
    return RegExp(source).hasMatch(toValidate);
  }
}
