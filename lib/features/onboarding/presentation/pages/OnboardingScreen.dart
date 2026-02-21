import 'package:bazar/app/routes/app_routes.dart';
import 'package:bazar/features/auth/presentation/pages/SignupPageScreen.dart';
import 'package:bazar/features/onboarding/presentation/pages/Onboarding2.dart';
import 'package:bazar/features/onboarding/presentation/widgets/onboarding_content.dart';
import 'package:flutter/material.dart';

class Onboardingscreen extends StatelessWidget {
  const Onboardingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingContent(
        points: const ['Shops near you'],
        onNext: () {
          AppRoutes.push(context, const Onboarding2());
        },
        onSkip: () {
          AppRoutes.pushAndRemoveUntil(context, const Signuppagescreen());
        },
      ),
    );
  }
}
