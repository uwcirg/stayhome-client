/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:map_app_flutter/KeycloakAuth.dart';
import 'package:map_app_flutter/MapAppDrawer.dart';
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.extraLargeMargin),
                    child: ProfileWidget(popWhenDone: false),
                  )
                  // Divider(),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: Dimensions.largeMargin),
                  //   child: Center(
                  //     child: OutlineButton(
                  //       child: Text(S.of(context).logout),
                  //       onPressed: () => logout(),
                  //     ),
                  //   ),
                  // ),
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
        child: MapAppErrorMessage.loadingErrorWithLogoutButton(context),
      );
    }
    return MapAppPageScaffold(title: title, child: new CircularProgressIndicator());
  }

  void logout() {
    MyApp.of(context).logout();
  }
}

class CreateProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapAppPageScaffold(
      title: "Create profile",
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
  final birthDateCtrl = TextEditingController();

  ProfileWidgetState();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    birthDateCtrl.dispose();
    super.dispose();
  }

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
        MapAppDrawer.navigate(context, '/home');
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
    birthDateCtrl.text = birthDate != null ? DateFormat.yMd().format(birthDate) : "";

    return Padding(
      padding: const EdgeInsets.all(Dimensions.fullMargin),
      child: Form(
          key: _formKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSectionHeader("Location"),
                _buildCollapsibleInfoTile("Click to learn how Location information is used", S.of(context).profile_location_help_text),
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
                //add space to present consistent spacing between sections here
                Container(
                  margin: EdgeInsets.only(
                    top: Dimensions.halfMargin,
                    left: Dimensions.fullMargin,
                    right: Dimensions.fullMargin,
                    bottom: Dimensions.fullMargin
                  ),
                  child: Container(),
                ),
                Divider(),
                _buildSectionHeader("Contact Information"),
                _buildCollapsibleInfoTile("Click to learn how Contact Information is used", S.of(context).profile_contact_info_help_text),
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
                    [ContactPointSystem.email, ContactPointSystem.sms, ContactPointSystem.phone],
                    preferredContactMethod, (value) {
                  preferredContactMethod = value;
                }, displayOverrides: {
                  ContactPointSystem.phone: "voice call",
                  ContactPointSystem.sms: "text"
                }),
                Divider(),
                _buildSectionHeader("About You"),
                _buildCollapsibleInfoTile("Click to learn how About You information is used", S.of(context).profile_identifying_info_help_text),
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
                InkWell(
                  child: IgnorePointer(
                    child:
                      TextFormField(
                        controller: birthDateCtrl,
                        decoration: InputDecoration(
                            icon: Icon(Icons.cake),
                            hintText: "Enter date of birth (m/d/y)",
                            labelText: "Date of birth"),
                        //initialValue: birthDate != null ? DateFormat.yMd().format(birthDate) : "",
                      ),
                    ),
                    onTap:() {
                      DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1850, 1, 1),
                        maxTime: new DateTime.now(),
                        theme: DatePickerTheme(
                          itemStyle: TextStyle(color: Theme.of(context).primaryColor),
                          doneStyle: TextStyle(color: Theme.of(context).primaryColor)
                        ),
                        onConfirm: (date) {
                          final formattedDate = DateFormat.yMd().format(date);
                          birthDate = DateFormat.yMd().parse(formattedDate.toString());
                          birthDateCtrl.text = formattedDate.toString();
                        },
                        currentTime: birthDate??DateTime.now(), locale: Localizations.localeOf(context).languageCode == 'de'? LocaleType.de : LocaleType.en);
                    },
                ),
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.fullMargin, horizontal: Dimensions.extraLargeMargin),
                  child: Text(
                      'clear date of birth',
                      style: TextStyle(decoration: TextDecoration.underline)
                  ),
                  onPressed: () {
                    birthDate = null;
                    birthDateCtrl.text = "";
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
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.largeMargin),
                  child: Center(
                    child: Wrap(
                      spacing: Dimensions.halfMargin,
                      runSpacing: Dimensions.fullMargin,
                      children: <Widget>[
                        OutlineButton(
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
                        OutlineButton(
                          child: Text(S.of(context).cancel),
                          onPressed: () => MapAppDrawer.navigate(context, '/home'),
                        )
                      ],
                    )
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
      padding: const EdgeInsets.only(top: Dimensions.largeMargin, bottom: 4),
      child: Text(text, style: Theme.of(context).textTheme.headline6),
    );
  }

  _buildCollapsibleInfoLabel(String header, bool expanded) {
    
    return Flexible(
        child:
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.help_outline,
              size: IconSize.small,
              semanticLabel: header,
              color: Colors.grey[700]
            ),
            Flexible(
              child:
              Container(
                padding: EdgeInsets.only(left:4, right: 8),
                child: Text(header, style: TextStyle(color: Colors.grey[700])),
              ),),
            Icon(
              expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
              color: Theme.of(context).primaryColor,
              size: IconSize.small,
              semanticLabel: header,
            ),
          ])
      );
  }

  _buildCollapsibleInfoTile(String header, String content) {
    return ConfigurableExpansionTile(
      headerExpanded: _buildCollapsibleInfoLabel(header, false),
      header: _buildCollapsibleInfoLabel(header, true),
      children: [
        Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(color: Theme.of(context).highlightColor),
          child: MarkdownBody(data: content),
        ),
        // + more params, see example !!
      ],
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
        widget._onChanged(_selectedValue);
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
