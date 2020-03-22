import 'package:global_configuration/global_configuration.dart';

class AppConfig {
  static Future init(String fileName) async {
    return GlobalConfiguration().loadFromAsset(fileName);
  }

  static String get fhirBaseUrl => GlobalConfiguration().getString("fhirBaseUrl");

  static String get appRootUrl => GlobalConfiguration().getString("appRootUrl");

  static String get issuerUrl => GlobalConfiguration().getString("issuerUrl");

  static String get clientId => GlobalConfiguration().getString("clientId");

  static String get clientSecret => GlobalConfiguration().getString("clientSecret");
}
