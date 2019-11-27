import 'dart:async';
import 'dart:mirrors';

import 'package:dio/dio.dart';
import 'package:thyi/thyi.dart';

class Thyi {
  String rootUrl;
  Thyi(this.rootUrl);

  // do the request
  FutureOr<dynamic> doRequest(List<ThyiParam> params) {

  }

}

class APiMethod {
  String method;
  String path = "";
  Map<String, String> headers = {};
  Map<String, String> fields = {};
  Map<String, String> queries = {};

  APiMethod(this.method, this.path, {this.headers, this.fields, this.queries});

  FutureOr<dynamic> send(Thyi thyi, Dio dio) {
    Options options = Options();
    String fullUrl = thyi.rootUrl + this.path;
    
    if (this.headers != null && this.headers.isNotEmpty) {
      options.headers.addAll(headers);
    }

    if ("GET" == method.toUpperCase()) {
      return dio.get(fullUrl, queryParameters: queries, options: options)
      .then((response) => response.data.toString());
    }
    else if ("POST" == method.toUpperCase()) {
      return dio.post(fullUrl, queryParameters: queries, options: options, data: fields)
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