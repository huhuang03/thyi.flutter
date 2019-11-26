import 'dart:async';
import 'dart:mirrors';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:thyi/thyi.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

class ThyiGenerator extends Generator {
  static Type typeGet = reflectClass(GET).reflectedType;
  static Type typePost = reflectClass(POST).reflectedType;
  static List<Type> typeHttpMethods = [typeGet, typePost];

  @override FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    var inputId = buildStep.inputId;
    print("begin parse ${inputId.path}");

    var file = _FileEx(library);
    if (!file.isApi()) {
      return null;
    }

    print("begin handle file: ${inputId.path}");
    return file.build();
  }

  // bool _classIsApi(ClassElement classElement) {
  //   print(classElement.methods);
  //   var methods = classElement.methods;
  //   for (var method in methods) {
  //     print(TypeChecker.fromRuntime(typeGet).hasAnnotationOf(method, throwOnUnresolved: false));
  //     var metaDatas = method.metadata;
  //     for (var meta in metaDatas) {
  //       print("11111");
  //       print(meta);
  //       print(meta.computeConstantValue() is GET);
  //       print(meta.constantValue is GET);
  //       print(meta.source is GET);
  //     }
  //     print(metaDatas);
  //   }
  //   return false;
  // }
}

class _FileEx {
  List<_CleassElementEx> classes = [];

  _FileEx(LibraryReader reader) {
    this.classes = reader.classes.map((clz) => _CleassElementEx(clz)).toList(growable: true);
  }

  bool isApi() {
    return classes.isNotEmpty && classes.any((c) => c.isApi());
  }

  String build() {
    return this.classes.map((clz) => clz.build()).where((str) => str != null).join("\n");
  }
}

class _CleassElementEx {
  static var PREFIX = "thyi";
  static var CLASS_PREFIX = "_thyiImpl";
  List<_MethodElementEx> _methods = [];
  ClassElement element;
  

  _CleassElementEx(this.element) {
    this._methods = element.methods.map((method) => _MethodElementEx(method)).toList(growable: true);
  }

  bool isApi() {
    return _methods.any((method) => method.isApi());
  }

  String build() {
    print(this.element);
    print(this.element.name);
    var c = Class((b) => b
    ..name = "${element.name}_${CLASS_PREFIX}"
    ..methods.addAll(this._methods.map((method) => method.build()).where((method) => method != null))
    );
    return DartFormatter().format("${c.accept(DartEmitter())}");
  }
}

class _MethodElementEx {
  MethodElement element;
  _MethodElementEx(this.element);

  bool isApi() {
    return ThyiGenerator.typeHttpMethods.any((type) {
      return TypeChecker.fromRuntime(type).hasAnnotationOf(this.element, throwOnUnresolved: false);
    });
  }

  Method build() {
    if (!isApi()) {
      return null;
    }
    return Method((b) => b
    ..name = element.displayName
    ..returns = Reference(element.returnType));
  }
}
