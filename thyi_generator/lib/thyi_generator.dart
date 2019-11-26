import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/thyi_generator.dart';


Builder thyiBuilder(BuilderOptions options) => LibraryBuilder(ThyiGenerator(), generatedExtension: '.thyi.dart');