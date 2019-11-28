import 'dart:async';

import 'package:example/src/user.dart';
import 'package:thyi/thyi.dart';

abstract class BaiduApi {
  @GET("/")
  Future<User> content();
}