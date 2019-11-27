import 'dart:async';
import 'dart:mirrors';

import 'package:dio/dio.dart';
import 'package:thyi/thyi.dart';

class Thyi {
  Dio dio;

  Thyi(String baseUrl) {
    this.dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

}

class ApiMethod {
  String method;
  String path = "";
  Map<String, String> headers = {};
  Map<String, String> fields = {};
  Map<String, String> queries = {};

  ApiMethod(this.method, this.path, {this.headers, this.fields, this.queries});

  Future<String> send(Thyi thyi) {
    Options options = Options();
    var dio = thyi.dio;
    
    if (this.headers != null && this.headers.isNotEmpty) {
      options.headers.addAll(headers);
    }

    if ("GET" == method.toUpperCase()) {
      print("do get");
      return dio.get(this.path, queryParameters: queries, options: options)
      .then((response) => response.data.toString());
    }
    else if ("POST" == method.toUpperCase()) {
      return dio.post(this.path, queryParameters: queries, options: options, data: fields)
      .then((response) => response.data.toString());
    } else {
      Future.error("for now unsupport http method; ${this.method}");
    }
  }
}


class ThyiParam {
  String value;
  dynamic annotation;

  ThyiParam(this.value, this.annotation);
}