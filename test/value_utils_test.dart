import 'package:map_app_flutter/value_utils.dart';
import 'package:test/test.dart';

void main() {
  test('ºC to ºF conversion', () => expect(cToF(0), 32));
  test('ºC to ºF conversion', () => expect(cToF(-40), -40));
  test('ºC to ºF conversion', () => expect(cToF(100), 212));
}