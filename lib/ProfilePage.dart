import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:map_app_flutter/KeycloakAuth.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/map_app_widgets.dart';
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
          child: Expanded(
              child: ListView.builder(
            itemBuilder: (context, i) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileWidget(popWhenDone: false),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.largeMargin),
                    child: Center(
                      child: OutlineButton(
                        child: Text(S.of(context).logout),
                        onPressed: () => logout(),
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: 1,
            shrinkWrap: true,
          )));
    }

    if (_error != null) {
      return MapAppPageScaffold(
        title: title,
        child: Text(_error),
      );
    }
    return MapAppPageScaffold(title: title, child: new CircularProgressIndicator());
  }

  void logout() {
    MyApp.of(context).logout(context: context);
  }
}

class CreateProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      title: "create profile",
      showDrawer: false,
      child: Expanded(
        child: ListView.builder(
          itemBuilder: (context, i) {
            return ProfileWidget(popWhenDone: true);
          },
          itemCount: 1,
          shrinkWrap: true,
        ),
      ),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  final bool popWhenDone;

  ProfileWidget({this.popWhenDone});

  @override
  State createState() => ProfileWidgetState();
}

class ProfileWidgetState extends State<ProfileWidget> {
  String _formError;
  final _formKey = GlobalKey<FormState>();

  ProfileWidgetState();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CarePlanModel>(builder: (context, child, model) {
      if (model == null) {
        return MapAppErrorMessage.loadingErrorWithLogoutButton(context);
      }
      if (model.error != null) {
        return MapAppErrorMessage.modelError(model);
      }
      return _buildForm(model);
    });
  }

  void _onPressed(Patient patient, CarePlanModel model) {
    model.updatePatientResource(patient).then((value) {
      setState(() {
        _formError = null;
      });
      if (widget.popWhenDone) {
        Navigator.of(context).pop();
      } else {
        snack("Profile updates saved", context);
      }
    }).catchError((error) {
      setState(() {
        _formError = "There has been an error while saving profile updates. Please try again.";
      });
      snack("Error saving profile updates", context);
    });
  }

  _buildForm(CarePlanModel model) {
    if (model.isLoading) return Center(child: CircularProgressIndicator());
    if (model.hasNoUser) {
      KeycloakAuth auth = MyApp.of(context).auth;
      print("model has no user / KeycloakAuth has user id: ${auth.userInfo.keycloakUserId}");
      return MapAppErrorMessage.loadingErrorWithLogoutButton(context);
    }
    UserInfo userInfo = MyApp.of(context).auth.userInfo;
    Patient originalPatient =
        model.patient != null ? Patient.fromJson(model.patient.toJson()) : Patient();
    String firstName = originalPatient.firstName;
    String lastName = originalPatient.lastName;
    String email = originalPatient.emailAddress ?? userInfo.email;
    String phone = originalPatient.phoneNumber;
    String homeZip = originalPatient.homeZip;
    String secondZip = originalPatient.secondZip;
    ContactPointSystem preferredContactMethod = originalPatient.preferredContactMethod;
    Gender gender = originalPatient.gender;
    DateTime birthDate = originalPatient.birthDate;

    return Padding(
      padding: const EdgeInsets.all(Dimensions.fullMargin),
      child: Form(
          key: _formKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildInfoTextSection(S.of(context).profile_introduction_help_text),
                _buildSectionHeader("Location"),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.contact_mail),
                      hintText: "Where you spend most of your time",
                      labelText: "Home zip code"),
                  initialValue: homeZip,
                  autovalidate: true,
                  validator: (value) {
                    // empty zip code is allowed
                    if (value.isNotEmpty && !isValid("zip", value)) {
                      return "Leave blank or enter a valid zip code";
                    }
                    homeZip = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(null),
                      hintText:
                          "if you spend a lot of time in a different location (work, school, family, etc.)",
                      labelText: "Second zip code"),
                  initialValue: secondZip,
                  autovalidate: true,
                  validator: (value) {
                    // empty zip code is allowed
                    if (value.isNotEmpty && !isValid("zip", value)) {
                      return "Leave blank or enter a valid zip code";
                    }
                    secondZip = value;
                    return null;
                  },
                ),
                _buildInfoTextSection(S.of(context).profile_location_help_text),
                _buildSectionHeader("Contact information"),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: S.of(context).what_is_your_email_address,
                      labelText: S.of(context).email),
                  initialValue: email,
                  autovalidate: true,
                  validator: (value) {
                    // empty email is allowed
                    if (value.isNotEmpty && !isValid("email", value)) {
                      return "Leave blank or enter a valid email address";
                    }
                    email = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      hintText: "What is your phone number?",
                      labelText: "Cell/mobile Phone"),
                  initialValue: phone,
                  autovalidate: true,
                  validator: (value) {
                    // empty phone is allowed
                    if (value.isNotEmpty && !isValid("phone", value)) {
                      return "Leave blank or enter a valid phone number";
                    }
                    phone = value;
                    return null;
                  },
                ),
                RadioButtonFormField(
                    "Preferred contact method",
                    [ContactPointSystem.email, ContactPointSystem.phone, ContactPointSystem.sms],
                    preferredContactMethod, (value) {
                  preferredContactMethod = value;
                }, displayOverrides: {
                  ContactPointSystem.phone: "call",
                  ContactPointSystem.sms: "text"
                }),
                _buildInfoTextSection(S.of(context).profile_contact_info_help_text),
                _buildSectionHeader("Identifying Information"),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: S.of(context).what_is_your_name,
                      labelText: "First name"),
                  initialValue: firstName,
                  autovalidate: true,
                  validator: (value) {
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
                  autovalidate: true,
                  validator: (value) {
                    lastName = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.cake),
                      hintText: "Enter date of birth (m/d/y)",
                      labelText: "Date of birth"),
                  initialValue: birthDate != null ? DateFormat.yMd().format(birthDate) : "",
                  autovalidate: true,
                  validator: (value) {
                    if (value.isEmpty) return null;
                    try {
                      birthDate = DateFormat.yMd().parse(value);
                      print("parsed birthdate: ${birthDate.toIso8601String()}");
                    } catch (FormatException) {
                      return "Enter a valid date";
                    }
                    return null;
                  },
                ),
                RadioButtonFormField(
                  "Sex",
                  [Gender.female, Gender.male, Gender.other, Gender.unknown],
                  gender,
                  (value) {
                    gender = value;
                  },
                  displayOverrides: {Gender.unknown: "decline to state"},
                ),
                _buildInfoTextSection(S.of(context).profile_identifying_info_help_text),
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.largeMargin),
                  child: Center(
                    child: OutlineButton(
                      child: Text("save"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _onPressed(
                              Patient.fromNewPatientForm(originalPatient,
                                  firstName: firstName,
                                  lastName: lastName,
                                  phoneNumber: phone,
                                  emailAddress: email,
                                  homeZip: homeZip,
                                  secondZip: secondZip,
                                  preferredContactMethod: preferredContactMethod,
                                  gender: gender,
                                  birthDate: birthDate),
                              model);
                        } else {
                          setState(() {
                            _formError = "Form has errors. Please scroll up and fix your entries.";
                          });
                        }
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _formError != null,
                  child: Text(_formError != null ? _formError : "",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .apply(color: Theme.of(context).errorColor)),
                )
              ])),
    );
  }

  _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.fullMargin),
      child: Text(text, style: Theme.of(context).textTheme.headline6),
    );
  }

  _buildInfoTextSection(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.halfMargin),
      child: MarkdownBody(data: text),
    );
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

class RadioButtonFormField extends StatefulWidget {
  final String _title;
  final List<dynamic> _options;
  final Function _onChanged;
  final _initialValue;
  final Map<dynamic, String> displayOverrides;

  const RadioButtonFormField(this._title, this._options, this._initialValue, this._onChanged,
      {Map<dynamic, String> displayOverrides})
      : displayOverrides = displayOverrides != null ? displayOverrides : const {};

  @override
  State<StatefulWidget> createState() => RadioButtonFormFieldState(_initialValue);
}

class RadioButtonFormFieldState extends State<RadioButtonFormField> {
  var _selectedValue;

  RadioButtonFormFieldState(this._selectedValue);

  String displayString(option) {
    if (widget.displayOverrides.containsKey(option)) {
      return widget.displayOverrides[option];
    }
    return option.toString();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = widget._options.map((option) {
      var onChanged = (value) {
        if (_selectedValue != option) {
          setState(() {
            _selectedValue = option;
          });
        } else {
          setState(() {
            _selectedValue = null;
          });
        }
        widget._onChanged(option);
      };
      return InkWell(
        onTap: () => onChanged(option),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Radio(
            value: option,
            groupValue: _selectedValue,
            activeColor: Theme.of(context).primaryColor,
            onChanged: null,
          ),
          Text(displayString(option)),
        ]),
      );
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: Dimensions.fullMargin),
            child: Text(widget._title, style: Theme.of(context).textTheme.caption)),
        Wrap(children: children),
      ],
    );
  }
}
