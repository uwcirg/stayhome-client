import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:map_app_flutter/MapAppPageScaffold.dart';
import 'package:map_app_flutter/Model.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/i18n.dart';
import 'package:map_app_flutter/services/Repository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  void initState() {
    // TODO: Move this handling somewhere more general so we can display the message whenever it is appropriate
//      MyApp.of(context).auth.getUserInfo().then((value) {
//        setState(() {
//          _error = null;
//        });
//      }).catchError((error) {
//        setState(() {
//          _error = "Error getting user info: $error";
//        });
//        if (MyApp.of(context).auth.refreshTokenExpired) {
//          Navigator.of(context).popUntil(ModalRoute.withName("/home"));
//          Navigator.of(context).pushNamed("/login");
//        }
//      });
    super.initState();
//    }
  }

  @override
  Widget build(BuildContext context) {
    String title = S.of(context).profile;

    if (MyApp.of(context).auth.userInfo != null) {
      return MapAppPageScaffold(
          title: title,
          actions: <Widget>[
            FlatButton(
              textTheme: ButtonTextTheme.normal,
              child: Text(S.of(context).logout),
              onPressed: () => logout(context),
            )
          ],
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.halfMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${MyApp.of(context).auth.userInfo.name}",
                  style: Theme.of(context).textTheme.display1,
                ),
                Text(
                    S.of(context).email(MyApp.of(context).auth.userInfo.email)),
                Text(
                  "Couchbase",
                  style: Theme.of(context).textTheme.display1,
                ),
                ScopedModelDescendant<AppModel>(
                  builder: (context, child, model) {
                    if (model.docExample != null) {
                      return Text(
                          "Couchbase object content: ${model.docExample
                              .getString("click")}");
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                  rebuildOnChange: true,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(MdiIcons.barcode),
                      hintText: "What is your Patient Resource ID?",
                      labelText: "Patient Resource ID"),
                  initialValue:
                      MyApp.of(context).auth.userInfo.patientResourceID,
                  onFieldSubmitted: (String text) {
                    Repository.getPatient(text).then((value) {
                      setState(() {
                        MyApp.of(context).auth.userInfo.patientResourceID =
                            text;
                      });
                    }).catchError((error) => snack(error, context));
                  },
                ),
              ],
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
    MyApp.of(context).auth.mapAppLogout().then((value) {
      setState(() {
        _updateState = !_updateState;
      });
      Navigator.of(context).pushNamed("/login");
    });
  }

  void login(BuildContext context) {
    MyApp.of(context).auth.mapAppLogin().then((value) => setState(() {
          _updateState = !_updateState;
        }));
  }

}
