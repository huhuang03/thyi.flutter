import 'dart:async';

import 'package:build/build.dart';

class ThyiBuilder implements Builder {

  FutureOr<void> build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;
    print(inputId);
    var thyiId = inputId.changeExtension(".thyi.dart");
    var contents = await buildStep.readAsString(inputId);
    await buildStep.writeAsString(thyiId, contents);
  }

  Map<String, List<String>> get buildExtensions {
    return {
      ".dart": [".thyi.dart"]
    };
  }

}