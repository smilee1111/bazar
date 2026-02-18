import 'package:bazar/app/routes/app_routes.dart';
import 'package:bazar/features/auth/presentation/pages/SignupPageScreen.dart';
import 'package:bazar/features/onboarding/presentation/pages/Onboarding3.dart';
import 'package:bazar/features/onboarding/presentation/widgets/onboarding_content.dart';
import 'package:flutter/material.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingContent(
        points: const ['Shops near you', 'Leave your reviews'],
        onNext: () {
          AppRoutes.push(context, const Onboarding3());
        },
        onSkip: () {
          AppRoutes.pushAndRemoveUntil(context, const Signuppagescreen());
        },
      ),
    );
  }
}
