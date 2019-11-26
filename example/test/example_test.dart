import 'dart:mirrors';

import 'package:example/src/api.dart';
import 'package:thyi/thyi.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    var reflect = reflectClass(BaiduApi);
    print(reflect);
    print(reflect.reflectedType);
    print(reflect.reflectedType);
      // for (var lib in currentMirrorSystem().libraries.values) {
      //   // print(lib);
      //   // var mirror = lib.declarations[MirrorSystem.getSymbol(name)];
      //   // if (mirror != null) return mirror;
      // }
  });
}
