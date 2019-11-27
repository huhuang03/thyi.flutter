// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ThyiGenerator
// **************************************************************************

import 'dart:async';
import 'api.dart';
import 'package:thyi/thyi.dart';

class BaiduApi__thyiImpl extends BaiduApi {
  BaiduApi__thyiImpl(Thyi thyi) {
    this.thyi = thyi;
  }

  Thyi thyi;

  Future<String> content() {
    final apiMethod = ApiMethod('GET', '/');
    return apiMethod.send(thyi);
  }
}
