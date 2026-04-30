// This is a basic Flutter widget test for BitVerse

import 'package:flutter_test/flutter_test.dart';

import 'package:bitverse/main.dart';

void main() {
  testWidgets('BitVerse app loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BitVerseApp());

    // Verify that the app loads with the correct title.
    expect(find.text('BITVERSE'), findsOneWidget);
  });
}
