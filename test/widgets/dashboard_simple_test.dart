import 'package:bazar/features/dashboard/presentation/pages/HomeScreen.dart';
import 'package:bazar/screens/SavedScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home screen shows search and primary content', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Homescreen()));
    await tester.pumpAndSettle();

    expect(find.text('Search Bar'), findsOneWidget);
    expect(find.text('Home Screen'), findsOneWidget);
  });

  testWidgets('Saved screen renders placeholder text', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Savedscreen()));
    await tester.pump();

    expect(find.text('Saved Screen'), findsOneWidget);
  });
}
