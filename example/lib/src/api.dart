import 'dart:async';

import 'package:example/src/user.dart';
import 'package:thyi/thyi.dart';

abstract class SimpleApi {
  @GET("/user/1")
  Future<User> content();
}