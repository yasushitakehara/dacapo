// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dacapo/main.dart';

void main() {
  testWidgets('Simple UI Test for Da Capo', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DaCapoApp());

    expect(find.text('Da Capo 練習メニュー（楽譜を長押しすると削除できます）'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.help));
    await tester.pumpAndSettle();

    expect(find.text('Da Capoとは？'), findsOneWidget);
    expect(find.text('Da Capo 練習メニュー（楽譜を長押しすると削除できます）'), findsNothing);
  });
}
