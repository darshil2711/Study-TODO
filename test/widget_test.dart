// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:studytodo/main.dart';

void main() {
  testWidgets('Study TO DO loads and shows add button', (
    WidgetTester tester,
  ) async {
    // Provide a fake SharedPreferences implementation for tests.
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const StudyTodoApp());

    // Wait for async init (SharedPreferences, FutureBuilder) to complete.
    await tester.pumpAndSettle();

    expect(find.text('Study TO DO'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
