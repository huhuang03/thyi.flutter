import 'dart:async';
import 'dart:mirrors';

import 'package:example/src/api.dart';
import 'package:thyi/thyi.dart';

class TheRight extends BaiduApi {
  Thyi thyi;
  InstanceMirror thisMirror;

  TheRight(this.thyi) {
    this.thisMirror = reflect(this);
    // thisMirror.type.instanceMembers
  }

  @GET("/")
  @override FutureOr<String> content() {
    List<ThyiParam> param = [];
    var methodMirror = _findMethod(#content);
    TypeMirror returnType = methodMirror.returnType;

    var method = methodMirror.metadata.first as dynamic;
    var value = method.path;
    param.add(ThyiParam(value, method));

    thyi.doRequest(param);
  }

  MethodMirror _findMethod(Symbol name) {
    MethodMirror rst;
    this.thisMirror.type.instanceMembers.forEach((symbol, method) {
      if (symbol == #content) {
        rst = method;
      } 
    });
    return rst;
  }

}