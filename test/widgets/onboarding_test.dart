import 'package:bazar/features/auth/presentation/pages/LoginPageScreen.dart';
import 'package:bazar/features/onboarding/presentation/pages/Onboarding2.dart';
import 'package:bazar/features/onboarding/presentation/pages/Onboarding3.dart';
import 'package:bazar/features/onboarding/presentation/pages/OnboardingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';


void main(){
  testWidgets('Should have title ', (WidgetTester tester)async{
    await tester.pumpWidget(
      const MaterialApp(
        home: Onboardingscreen()
        ),
    );

    await tester.pumpAndSettle();
    Finder title = find.text("Welcome , User!");
    expect(title, findsOneWidget);
  });


    testWidgets('should have leave reviews text', (WidgetTester tester)async{
    await tester.pumpWidget(
      const MaterialApp(
        home: Onboarding2()
        ),
    );

    await tester.pumpAndSettle();
    Finder text = find.textContaining("📝 Leave your reviews");
    expect(text, findsOneWidget);
  });


  testWidgets('Should have search shops text', (WidgetTester tester)async{
    await tester.pumpWidget(
      const MaterialApp(
        home: Onboarding3(),
        ),
    );

    await tester.pumpAndSettle();
    Finder text = find.textContaining("🔎 Search for the perfect shop to buy anything ");
    expect(text, findsOneWidget);
  });



  
}