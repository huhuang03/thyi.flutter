import 'dart:async';

import 'package:thyi/thyi.dart';

abstract class BaiduApi {
  @GET("/")
  FutureOr<String> content();
}