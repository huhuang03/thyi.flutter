import 'dart:mirrors';

import 'package:thyi/thyi.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    var mirror = reflectClass(GET);
    print(mirror);
    print(mirror.reflectedType);
    print(mirror.runtimeType);
  });
}
