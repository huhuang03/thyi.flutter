// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ThyiGenerator
// **************************************************************************

import 'dart:async';
import 'dart:convert';
import 'api.dart';
import 'package:thyi/thyi.dart';
import 'package:example/src/user.dart';

class BaiduApi__thyiImpl extends BaiduApi {
  BaiduApi__thyiImpl(Thyi this.thyi) {
    this.thyi = thyi;
  }

  Thyi thyi;

  @override
  Future<User> content() {
    final apiMethod = ApiMethod('GET', '/');
    return apiMethod.send(thyi).then((d) => User.fromJson(jsonDecode(d)));
  }
}
