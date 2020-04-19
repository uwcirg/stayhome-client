/*
 * Copyright (c) 2020 CIRG. All rights reserved.
 */

import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:map_app_flutter/KeycloakAuth.dart';
import 'package:map_app_flutter/MapAppDrawer.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/fhir/FhirResources.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/map_app_code_system.dart';
import 'package:map_app_flutter/map_app_widgets.dart';
import 'package:map_app_flutter/model/CarePlanModel.dart';
import 'package:map_app_flutter/permissions_widgets.dart';
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
      title: S.of(context).profile_create_text,
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
    return ScopedModelDescendant<CarePlanModel>(
      builder: (context, child, model) {
        if (model == null) {
          return MapAppErrorMessage.loadingErrorWithLogoutButton(context);
        }
        if (model.error != null) {
          return MapAppErrorMessage.modelError(model);
        }
        model.isFirstTimeUser = false;
        return _buildForm(model);
      },
      rebuildOnChange: true,
    );
  }

  void _onPressed({Patient patient, CarePlanModel model}) {
    Future.wait([model.updateConsents(), model.updatePatientResource(patient)], eagerError: true)
        .then((value) {
      setState(() {
        _formError = null;
      });
      if (widget.popWhenDone) {
        Navigator.of(context).pop();
      } else {
        snack(S.of(context).profile_updated_text, context);
        MapAppDrawer.navigate(context, '/home');
      }
    }).catchError((error) {
      print('$error');
      setState(() {
        _formError = S.of(context).profile_save_error_text;
      });
      snack(S.of(context).profile_save_error_text, context);
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
                Text(S.of(context).profile_info_sharing_text),
                buildSectionHeader(S.of(context).profile_location_title_text, context),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.contact_mail),
                      hintText: S.of(context).profile_zipcode_hint_text,
                      labelText: S.of(context).profile_home_zipcode_label_text),
                  initialValue: homeZip,
                  autovalidate: true,
                  validator: (value) {
                    // empty zip code is allowed
                    if (value.isNotEmpty && !isValid("zip", value)) {
                      return S.of(context).profile_zipcode_validation_error_text;
                    }
                    homeZip = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(null),
                      hintText: S.of(context).profile_secondary_zipcode_hint_text,
                      labelText: S.of(context).profile_secondary_zipcode_label_text),
                  initialValue: secondZip,
                  autovalidate: true,
                  validator: (value) {
                    // empty zip code is allowed
                    if (value.isNotEmpty && !isValid("zip", value)) {
                      return S.of(context).profile_zipcode_validation_error_text;
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
                      bottom: Dimensions.fullMargin),
                  child: Container(),
                ),
                Divider(),
                buildSectionHeader(S.of(context).profile_contact_title_text, context),
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
                      return S.of(context).profile_email_validation_error_text;
                    }
                    email = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      hintText: S.of(context).profile_phone_hint_text,
                      labelText: S.of(context).profile_phone_label_text),
                  initialValue: phone,
                  autovalidate: true,
                  validator: (value) {
                    // empty phone is allowed
                    if (value.isNotEmpty && !isValid("phone", value)) {
                      return S.of(context).profile_phone_validation_error_text;
                    }
                    phone = value;
                    return null;
                  },
                ),
                RadioButtonFormField(
                    S.of(context).profile_preferred_contact_text,
                    [ContactPointSystem.email, ContactPointSystem.sms, ContactPointSystem.phone],
                    preferredContactMethod, (value) {
                  preferredContactMethod = value;
                }, displayOverrides: {
                      ContactPointSystem.email: S.of(context).contact_point_system_email,
                  ContactPointSystem.phone: S.of(context).profile_preferred_contact_voicecall_text,
                  ContactPointSystem.sms: S.of(context).profile_preferred_contact_sms_text
                }),
                Divider(),
                buildSectionHeader(S.of(context).profile_about_you_title_text, context),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: S.of(context).what_is_your_name,
                      labelText: S.of(context).firstname),
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
                      labelText: S.of(context).lastname),
                  initialValue: lastName,
                  autovalidate: true,
                  validator: (value) {
                    lastName = value;
                    return null;
                  },
                ),
                InkWell(
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: birthDateCtrl,
                      decoration: InputDecoration(
                          icon: Icon(Icons.cake),
                          hintText: S.of(context).birthdate_hint_text,
                          labelText: S.of(context).birthdate),
                    ),
                  ),
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: birthDate ?? DateTime.now(),
                            firstDate: DateTime(1850, 1, 1),
                            lastDate: new DateTime.now(),
                            locale: Locale(Localizations.localeOf(context).languageCode, ''))
                        .then((DateTime pickerdate) {
                      if (pickerdate != null) {
                        final formattedDate = DateFormat.yMd().format(pickerdate);
                        birthDate = DateFormat.yMd().parse(formattedDate.toString());
                        birthDateCtrl.text = formattedDate.toString();
                      }
                    });
                  },
                ),
                FlatButton(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.fullMargin, horizontal: Dimensions.extraLargeMargin),
                  child: Text(S.of(context).clear_birthdate_text,
                      style: TextStyle(decoration: TextDecoration.underline)),
                  onPressed: () {
                    birthDate = null;
                    birthDateCtrl.text = "";
                  },
                ),
                RadioButtonFormField(
                  S.of(context).gender,
                  [Gender.female, Gender.male, Gender.other, Gender.unknown],
                  gender,
                  (value) {
                    gender = value;
                  },
                  displayOverrides: {
                    Gender.unknown: S.of(context).decline_to_state,
                    Gender.male: S.of(context).gender_male,
                    Gender.female: S.of(context).gender_female,
                    Gender.other: S.of(context).gender_other
                  },
                ),
                Divider(),
                ..._permissionsPageContent(model),
                SaveAndCancelBar(
                  onCancel: () {
                    model.consents.reset();
                    _formKey.currentState.reset();
                    MapAppDrawer.navigate(context, '/home');
                  },
                  onSave: () {
                    if (_formKey.currentState.validate()) {
                      _onPressed(
                          patient: Patient.fromNewPatientForm(originalPatient,
                              firstName: firstName,
                              lastName: lastName,
                              phoneNumber: phone,
                              emailAddress: email,
                              homeZip: homeZip,
                              secondZip: secondZip,
                              preferredContactMethod: preferredContactMethod,
                              gender: gender,
                              birthDate: birthDate),
                          model: model);
                    } else {
                      setState(() {
                        _formError = S.of(context).form_error_text;
                      });
                    }
                  },
                ),
                Visibility(
                  visible: _formError != null,
                  child: Center(
                    child: Text(
                      _formError != null ? _formError : "",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .apply(color: Theme.of(context).errorColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ])),
    );
  }

  List<Widget> _permissionsPageContent(CarePlanModel model) {
    return [
      buildSectionHeader(S.of(context).information_sharing, context),
      paragraph(S.of(context).information_sharing_info),
      paragraph(S.of(context).public_health_information_sharing_info),
      paragraph(S.of(context).public_health_information_sharing_question),
      ConsentGroupWidget(
        consentGroupRef: OrganizationReference.publicHealthAgencies,
      ),
      Divider(),
      paragraph(S.of(context).research_information_sharing_info),
      paragraph(S.of(context).research_information_sharing_question),
      ConsentGroupWidget(
        consentGroupRef: OrganizationReference.researchers,
      ),
      Divider(),
      padded(
        Text(
          S.of(context).member_program_question,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      ProgramConsentWidget(
        programTitle: S.of(context).fiu_title,
        consentGroupRef: OrganizationReference.fiu,
        expandedTextMarkdown: S.of(context).fiu_body,
        shareItemLabel: S.of(context).fiu_toggle,
      ),
      ProgramConsentWidget(
        programTitle: S.of(context).fiuNH_title,
        consentGroupRef: OrganizationReference.fiuNeighborhoodHelp,
        expandedTextMarkdown: S.of(context).fiuNH_body,
        shareItemLabel: S.of(context).fiuNH_toggle,
      ),
      ProgramConsentWidget(
        programTitle: S.of(context).scan_title,
        consentGroupRef: OrganizationReference.scan,
        expandedTextMarkdown: S.of(context).scan_body,
        shareItemLabel: S.of(context).scan_toggle,
      )
    ];
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
          AbsorbPointer(
            child: Radio(
              value: option,
              groupValue: _selectedValue,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {},
            ),
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
