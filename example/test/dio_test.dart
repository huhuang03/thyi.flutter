import 'package:dio/dio.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () async {
    var dio = Dio(BaseOptions(baseUrl: "http://5ddf54ed4a658b0014c48859.mockapi.io"));
    await dio.get("/user/1").then((response) {
      print(response.data.toString());
    });
  });
}
