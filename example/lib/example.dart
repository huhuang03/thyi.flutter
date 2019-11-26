import 'dart:mirrors';

import 'package:thyi/thyi.dart';

import 'src/api.dart';

main(List<String> args) async {
  var thyi = Thyi("http://www.baidu.com");
  var baiduApi = thyi.create(reflectClass(BaiduApi)) as BaiduApi;
  await print(baiduApi.content());
}