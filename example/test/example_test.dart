import 'dart:mirrors';

import 'package:example/src/api.dart';
import 'package:thyi/thyi.dart';
import 'package:test/test.dart';

class Response {
  String data = "hello from data";
}

Future<String> foo() {
  return Future.value(Response()).then((response) => response.data);
}

void main() {
  test('calculate', () async {
    var response = foo();
    print(response);
  });
}
