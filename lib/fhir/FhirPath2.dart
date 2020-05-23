@JS('fhirpath')
library fhirpath;

import "package:js/js.dart";

@JS()
external evaluate(Options resourceObject, String fhirPathExpression, environment);

@JS()
@anonymous
class Options {
  external bool get responsive;

  external factory Options({bool responsive});
}