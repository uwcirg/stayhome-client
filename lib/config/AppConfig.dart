import 'package:flutter/services.dart' show rootBundle;
import 'package:global_configuration/global_configuration.dart';
import 'package:yaml/yaml.dart';

class AppConfig {
  static Future<GlobalConfiguration> init(String fileName) async {
    if (fileName.endsWith("yaml")) {
      String content = await rootBundle.loadString("assets/cfg/$fileName");
      YamlMap yamlMap = loadYaml(content);
      Map<String, dynamic> map = new Map();
      yamlMap.forEach((key, value) {
        map[key.toString()] = value;
      });
      GlobalConfiguration g = GlobalConfiguration().loadFromMap(map);
      return Future.value(g);
    } else {
      return GlobalConfiguration().loadFromAsset(fileName);
    }
  }

  static String get fhirBaseUrl => GlobalConfiguration().get("fhirBaseUrl")?.toString();

  static String get appRootUrl => GlobalConfiguration().get("appRootUrl")?.toString();

  static String get issuerUrl => GlobalConfiguration().get("issuerUrl")?.toString();

  static String get clientId => GlobalConfiguration().get("clientId")?.toString();

  static String get clientSecret => GlobalConfiguration().get("clientSecret")?.toString();

  static String get version => GlobalConfiguration().get("version")?.toString();

  static String get careplanTemplateId => GlobalConfiguration().get("careplanTemplateId")?.toString();
  static String get newUserWelcomeMessageTemplateId => GlobalConfiguration().get("newUserWelcomeMessageTemplateId")?.toString();

  static String get deploymentType => GlobalConfiguration().get("deploymentType")?.toString();
  static bool get isProd => deploymentType != null && deploymentType == "prod";

  static String get commitSha => GlobalConfiguration().get("COMMIT_SHA")?.toString();
}
