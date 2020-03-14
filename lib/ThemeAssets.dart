import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app_flutter/ContactCommunityPage.dart';
import 'package:map_app_flutter/DevicesPage.dart';
import 'package:map_app_flutter/GoalsPage.dart';
import 'package:map_app_flutter/HelpPage.dart';
import 'package:map_app_flutter/LearningCenterPage.dart';
import 'package:map_app_flutter/LoginPage.dart';
import 'package:map_app_flutter/PlanPage.dart';
import 'package:map_app_flutter/ProfilePage.dart';
import 'package:map_app_flutter/ProgressInsightsPage.dart';
import 'package:map_app_flutter/SessionPage.dart';
import 'package:map_app_flutter/color_palette.dart';
import 'package:map_app_flutter/const.dart';
import 'package:map_app_flutter/generated/l10n.dart';
import 'package:map_app_flutter/platform_stub.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

abstract class ThemeAssets {
  final primarySwatch;
  final accentColor;
  final highlightColor;
  final completedCalendarItemColor;
  final loginBackgroundImagePath;
  final systemUiOverlayStyle;
  final textTheme;
  final careplanTemplateRef;

  ThemeAssets(
      this.primarySwatch, this.accentColor, this.highlightColor, this.completedCalendarItemColor,
      {this.loginBackgroundImagePath,
      this.systemUiOverlayStyle = SystemUiOverlayStyle.light,
      this.textTheme,
      this.careplanTemplateRef});

  TextTheme textThemeOverride(TextTheme textTheme) {
    return textTheme;
  }

  Widget loginBanner(BuildContext context);

  Widget drawerBanner(BuildContext context);

  List<Widget> additionalLoginPageViews(BuildContext context);

  Widget appBarTitle();

  Map<String, WidgetBuilder> navRoutes(BuildContext context);

  List<MenuItem> navItems(BuildContext context);

  loginBackgroundDecoration() {}
}

class JoyluxThemeAssets extends ThemeAssets {
  JoyluxThemeAssets()
      : super(MapAppColors.vFitPrimary, MapAppColors.vFitAccent, MapAppColors.vFitHighlight,
            MapAppColors.vFitAccent,
            loginBackgroundImagePath: 'assets/photos/woman-login.jpg',
            systemUiOverlayStyle: SystemUiOverlayStyle.dark,
            careplanTemplateRef: "CarePlan/54");

  @override
  Widget loginBanner(BuildContext context) {
    return Image.asset(
      "assets/logos/Joylux_wdmk_color_rgb.png",
      height: 40,
    );
  }

  @override
  Widget drawerBanner(BuildContext context) {
    return Image.asset(
      'assets/logos/Joylux_wdmk_blk_rgb.png',
      height: 20,
    );
  }

  @override
  List<Widget> additionalLoginPageViews(BuildContext context) {
    return [
      Row(
        children: [
          Padding(
              padding: EdgeInsets.all(Dimensions.fullMargin),
              child:
                  Image.asset('assets/logos/Vfit_logo_icon_circle_color_rgb_bg.png', height: 48)),
          Padding(
              padding: EdgeInsets.all(Dimensions.fullMargin),
              child:
                  Image.asset('assets/logos/VSculpt_logo_circle_icon_color_rgb_bg.png', height: 48))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )
    ];
  }

  @override
  loginBackgroundDecoration() {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage(loginBackgroundImagePath),
            fit: BoxFit.fitHeight,
            alignment: FractionalOffset(0.8, 0)));
  }

  @override
  TextTheme textThemeOverride(TextTheme textTheme) {
    return textTheme.apply(
      bodyColor: MapAppColors.vFitPrimary.shade600,
      displayColor: MapAppColors.vFitPrimary.shade600,
    );
  }

  @override
  Widget appBarTitle() {
    return Image.asset(
      'assets/logos/Joylux_wdmk_rev_rgb.png',
      height: 25,
    );
  }

  @override
  List<MenuItem> navItems(BuildContext context) {
    return [
      MenuItem(
        requiresLogin: true,
        title: S.of(context).my_goals,
        icon: Icon(MdiIcons.bullseyeArrow),
        route: '/goals',
      ),
      MenuItem(
        requiresLogin: true,
        title: S.of(context).start_a_session,
        icon: ImageIcon(AssetImage('assets/logos/v-logo-smaller.png')),
        route: '/start_session',
      ),
      MenuItem(
        requiresLogin: true,
        title: S.of(context).plan,
        icon: Icon(Icons.calendar_today),
        route: '/home',
      ),
      MenuItem(
        requiresLogin: true,
        title: S.of(context).progress__insights,
        icon: Icon(MdiIcons.bullseyeArrow),
        route: '/progress_insights',
      ),
      MenuItem(
        requiresLogin: true,
        title: S.of(context).devices,
        icon: Icon(Icons.bluetooth),
        route: '/devices',
      ),
      MenuItem(
        title: S.of(context).learning_center,
        icon: Icon(Icons.lightbulb_outline),
        route: '/learning_center',
      ),
      MenuItem(
        title: S.of(context).contact__community,
        icon: Icon(Icons.chat),
        route: '/contact_community',
      ),
      MenuItem(
        title: S.of(context).about,
        icon: Icon(Icons.people),
        route: '/about',
      )
    ];
  }

  @override
  Map<String, WidgetBuilder> navRoutes(BuildContext context) {
    var learningCenter = (BuildContext context) => JoyluxLearningCenterPage();
    return <String, WidgetBuilder>{
      "/home": (BuildContext context) => new PlanPage(),
      "/guestHome": learningCenter,
      "/profile": (BuildContext context) =>
//          new ScopedModel<AppModel>(model: new AppModel(), child: ProfilePage()),
          ProfilePage(),
      "/start_session": (BuildContext context) => SessionPage(),
      "/devices": (BuildContext context) => DevicesPage(),
      "/contact_community": (BuildContext context) =>
          ContactCommunityPage(ContactPageContents.contents(context)),
      "/progress_insights": (BuildContext context) => ProgressInsightsPage(),
      "/learning_center": learningCenter,
      "/about": (BuildContext context) => HelpPage(),
      "/goals": (BuildContext context) => GoalsPage(),
      "/login": (BuildContext context) => LoginPage(),
      "/authCallback": (BuildContext context) => PlatformDefs().getAuthCallbackPage()
    };
  }
}

class StayHomeThemeAssets extends ThemeAssets {
  StayHomeThemeAssets()
      : super(MapAppColors.stayHomePrimary, MapAppColors.stayHomeAccent,
            MapAppColors.stayHomeHighlight, MapAppColors.stayHomePrimary,
            careplanTemplateRef: "CarePlan/203");

  @override
  Widget loginBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(Dimensions.fullMargin),
              child: Image.asset(
                'assets/stayhome/icon_white.png',
                height: 70,
              )),
          Text(
            this.appName,
            style: Theme.of(context)
                .primaryTextTheme
                .headline2
                .apply(color: Colors.white, fontWeightDelta: 2),
          ),
          Padding(
              padding: EdgeInsets.all(Dimensions.fullMargin),
              child: Image.asset(
                'assets/stayhome/Signature_Left_White.png',
                height: 20,
              )),
          Padding(
              padding: EdgeInsets.only(left: Dimensions.quarterMargin, right: Dimensions.quarterMargin, top: 12, bottom: 12),
              child: Image.asset(
                'assets/stayhome/CIRG_logo_white.png',
                height: 50,
              )),
        ],
      ),
    );
  }
  TextTheme textThemeOverride(TextTheme textTheme) {
    return textTheme.copyWith(button: textTheme.subhead.apply(color: this.primarySwatch, fontWeightDelta: 2));
  }

  get appName => "StayHome";

  @override
  Widget drawerBanner(BuildContext context) {
    return Center(
        child: Text(
      this.appName,
      style: Theme.of(context).textTheme.title,
    ));
  }

  @override
  Widget appBarTitle() {
    return Text(this.appName);
  }

  @override
  List<Widget> additionalLoginPageViews(BuildContext context) {
    // TODO: implement additionalLoginPageViews
    return [];
  }

  @override
  loginBackgroundDecoration() {
    // TODO: implement loginBackgroundDecoration
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [primarySwatch, Color(0xFF5835BD)],
            stops: [0.0, 0.7],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter));
  }

  @override
  List<MenuItem> navItems(BuildContext context) {
    return [
      MenuItem(
        requiresLogin: true,
        title: S.of(context).plan,
        icon: Icon(Icons.calendar_today),
        route: '/home',
      ),
      MenuItem(
        requiresLogin: true,
        title: "Trends",
        icon: Icon(Icons.show_chart),
        route: '/progress_insights',
      ),
      MenuItem(
        title: S.of(context).learning_center,
        icon: Icon(Icons.lightbulb_outline),
        route: '/learning_center',
      ),
      MenuItem(
        title: S.of(context).about,
        icon: Icon(Icons.people),
        route: '/about',
      )
    ];
  }

  @override
  Map<String, WidgetBuilder> navRoutes(BuildContext context) {
    var learningCenter = (BuildContext context) => StayHomeLearningCenterPage();
    return <String, WidgetBuilder>{
      "/home": (BuildContext context) => new StayHomePlanPage(),
      "/guestHome": learningCenter,
      "/profile": (BuildContext context) => ProfilePage(),
      "/progress_insights": (BuildContext context) => ProgressInsightsPage(),
      "/learning_center": learningCenter,
      "/about": (BuildContext context) => StayHomeHelpPage(),
      "/login": (BuildContext context) => LoginPage(),
      "/authCallback": (BuildContext context) => PlatformDefs().getAuthCallbackPage(),
    };
  }
}

class MenuItem {
  final String title;
  final Widget icon;
  final String route;
  final bool requiresLogin;

  MenuItem({this.title = "Undefined", this.icon, this.route = "/home", this.requiresLogin = false});
}
