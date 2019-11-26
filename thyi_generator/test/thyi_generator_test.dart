import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    final animal = Class((b) => b
      ..name = 'Animal'
      ..extend = refer('Organism')
      ..methods.add(Method.returnsVoid((b) => b
        ..name = 'eat'
        ..body = const Code("print('Yum');"))));
      final emitter = DartEmitter();
      print(DartFormatter().format('${animal.accept(emitter)}'));
  });
}
