/// References:
/// https://pub.dev/packages/js
/// https://api.dart.dev/stable/2.8.3/dart-js/dart-js-library.html
/// https://codeburst.io/how-to-use-javascript-libraries-in-your-dart-applications-e44668b8595d

@JS('fhirpath')
library fhirpath;

import "package:js/js.dart";

@JS()
external evaluate(dynamic resourceObject, String fhirPathExpression, {dynamic environment});

@JS()
@anonymous
class Options {
  external bool get responsive;

  external factory Options({bool responsive});
}