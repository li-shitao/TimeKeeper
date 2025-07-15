import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets('App starts and shows loading indicator', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts with a loading indicator.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // We can't easily test the full flow without mocking http,
    // but this confirms the initial state.
  });
}
