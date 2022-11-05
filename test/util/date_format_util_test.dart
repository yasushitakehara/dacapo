// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dacapo/util/date_format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dacapo/main.dart';
import 'package:intl/intl.dart';

// expect yyyyMMddTHHmmss
final _scoreDtoIdFormat = new RegExp(r'^\d{8}T\d{6}$');

void main() {
  test('createScoreDtoID', () {
    // Build our app and trigger a frame.
    String actualStr = DateFormatUtil.createScoreDtoID();
    expect(_scoreDtoIdFormat.hasMatch(actualStr), isTrue);

    DateTime actualDateTime = DateTime.parse(actualStr);
    final diffMS = DateTime.now().difference(actualDateTime).inMilliseconds;

    // actualDateTime must be near current date time.
    expect(diffMS, lessThanOrEqualTo(1000));
  });
}
