import 'dart:async';
import 'dart:mirrors';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:thyi/thyi.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/code_builder.dart' as cb;
import 'package:dart_style/dart_style.dart';

class ThyiGenerator extends Generator {
  static Type typeGet = reflectClass(GET).reflectedType;
  static Type typePost = reflectClass(POST).reflectedType;
  static List<Type> typeHttpMethods = [typeGet, typePost];

  @override FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    var inputId = buildStep.inputId;
    var file = _FileEx(library, inputId);
    if (!file.isApi()) {
      return null;
    }

    print("begin handle file: ${inputId.path}");
    return file.build(inputId);
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
  static String PKG_THYI = "package:thyi/thyi.dart";
  List<_CleassElementEx> classes = [];
  List<String> pathSegments;

  _FileEx(LibraryReader reader, AssetId assetId) {
    this.classes = reader.classes.map((clz) => _CleassElementEx(clz)).toList(growable: true);
    this.pathSegments = assetId.pathSegments;
  }

  bool isApi() {
    return "test" != this.pathSegments[0] && classes.any((c) => c.isApi());
  }

  String build(AssetId inputId) {
    final library = Library((b) => b
    ..directives.addAll(
      [Directive.import('dart:async')
      , Directive.import(this.pathSegments.last)
      , Directive.import(PKG_THYI)])
    ..body.addAll(this.classes.map((clz) => clz.build(inputId, b)).where((c) => c != null)));
    return DartFormatter().format('${library.accept(DartEmitter())}');
  }
}

class _CleassElementEx {
  static var PREFIX = "thyi";
  static var CLASS_PREFIX = "_thyiImpl";
  List<_MethodElementEx> _methods = [];
  ClassElement element;
  String name;
  

  _CleassElementEx(this.element) {
    this._methods = element.methods.map((method) => _MethodElementEx(method)).toList(growable: true);
    this.name = "${element.name}_${CLASS_PREFIX}";
  }

  bool isApi() {
    return _methods.any((method) => method.isApi());
  }

  Class build(AssetId inputId, cb.LibraryBuilder library) {
    var c = Class((b) => b
    ..name = this.name
    ..fields.addAll(this._buildFields())
    ..constructors.add(this._buildConstructor())
    ..extend = refer("${element.name}")
    ..methods.addAll(this._methods.map((method) => method.build(inputId, library)).where((method) => method != null))
    );
    return c;
  }

  List<Field> _buildFields() {
    List<Field> rst = [];
    rst.add(Field((b) {b
    ..name = "thyi"
    ..type = refer("Thyi");
    }));
    return rst;
  }

  Constructor _buildConstructor() {
    return Constructor((c) {c
    ..requiredParameters.add(Parameter((p) {p
      ..name = "thyi"
      ..toThis = true
      ..type = refer("Thyi");
    }))
    ..body = Code('this.thyi = thyi;');
    });
  }
}

class _MethodElementEx {
  static String VAR_API_METHOD = "apiMethod";
  MethodElement element;
  _MethodElementEx(this.element);

  bool isApi() {
    return ThyiGenerator.typeHttpMethods.any((type) {
      return TypeChecker.fromRuntime(type).hasAnnotationOf(this.element, throwOnUnresolved: false);
    });
  }

  Method build(AssetId inputId, cb.LibraryBuilder library) {
    if (!isApi()) {
      return null;
    }
    var returnType = element.returnType;
    if (!returnType.isDartAsyncFuture) {
      throw ArgumentError("for now can only support return Future");
    }

    this._buildReturnImport(inputId, library);

    List<Code> codes = [];
    codes.add(this._buildApiMethod());
    codes.add(this._buildReturn());
    
    var method = Method((b) => b
    ..name = element.displayName
    ..annotations.add(refer("override"))
    ..returns = refer(element.returnType.displayName, 'dart:async')
    ..body = Block.of(codes.where((code) => code != null).toList())
    );
    return method;
  }

  void _buildReturnImport(AssetId inputId, cb.LibraryBuilder library) {
    var returnType = this.element.returnType as ParameterizedType;
    var package = inputId.package;

    returnType.typeArguments.forEach((p) {
      print("import element");
      var fullPath = p.element.library.source.toString();
      fullPath = fullPath.substring(1);
      if (!fullPath.startsWith("${package}/")) {
        throw ArgumentError("doesn't impl import out package: ${fullPath}, current pkg: ${inputId.path}");
      }
      fullPath = fullPath.replaceAll("/lib/", "/");
      fullPath = "package:" + fullPath;
      library.directives.add(Directive.import(fullPath));
    });
  }

  Code _buildApiMethod() {
    var params = <Expression>[];
    final method = this._getHttpMethod();
    params.add(literal(method[0]));
    params.add(literal(method[1]));
    return refer("ApiMethod").newInstance(params).assignFinal(VAR_API_METHOD).statement;
  }

  Code _buildReturn() {
    return refer("apiMethod.send").call([refer("thyi")]).returned.statement;
  }

  List<String> _getHttpMethod() {
    var meta = element.metadata.first;
    if (meta == null) {
      return ["GET", ""];
    }
    return [meta.constantValue.type.toString(), meta.constantValue.getField("path").toStringValue()];
  }

}
