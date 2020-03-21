import 'package:global_configuration/global_configuration.dart';

class AppConfig {
  static Future init(String fileName) async {
    return GlobalConfiguration().loadFromAsset(fileName);
  }

  static String get fhirBaseUrl => GlobalConfiguration().getString("fhirBaseUrl");

  static String get appRootUrl => GlobalConfiguration().getString("appRootUrl");
}
