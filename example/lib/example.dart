import 'dart:mirrors';

import 'package:example/src/api.thyi.dart';
import 'package:thyi/thyi.dart';

import 'src/api.dart';

main(List<String> args) async {
  var thyi = Thyi("http://www.baidu.com");
  var baiduApi = BaiduApi__thyiImpl(thyi);
  await print(baiduApi.content().then((data) => print(data)));
}