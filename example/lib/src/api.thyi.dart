// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ThyiGenerator
// **************************************************************************

import 'dart:async';
import 'dart:convert';
import 'api.dart';
import 'package:thyi/thyi.dart';
import 'package:example/src/user.dart';

class SimpleApi__thyiImpl extends SimpleApi {
  SimpleApi__thyiImpl(Thyi this.thyi) {
    this.thyi = thyi;
  }

  Thyi thyi;

  @override
  Future<User> content() {
    final apiMethod = ApiMethod('GET', '/user/1');
    return apiMethod.send(thyi).then((d) {
      return User.fromJson(jsonDecode(d));
    });
  }
}
