import 'package:flutter/foundation.dart';
import 'package:simple_logger/simple_logger.dart';

// Referenece
// https://medium.com/flutter-jp/logger-ec25d8dd179a
final logger = SimpleLogger()
  ..setLevel(
    Level.FINEST,
    includeCallerInfo: kDebugMode, // include in debug mode
  );
