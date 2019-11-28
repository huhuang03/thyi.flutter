import 'package:example/src/api.thyi.dart';
import 'package:thyi/thyi.dart';


main(List<String> args) async {
  var thyi = Thyi("http://5ddf54ed4a658b0014c48859.mockapi.io");
  var baiduApi = SimpleApi__thyiImpl(thyi);
  await print(baiduApi.content().then((data) => print(data)));
}