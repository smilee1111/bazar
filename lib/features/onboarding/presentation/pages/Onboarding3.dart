import 'package:bazar/app/routes/app_routes.dart';
import 'package:bazar/features/auth/presentation/pages/SignupPageScreen.dart';
import 'package:bazar/features/onboarding/presentation/widgets/onboarding_content.dart';
import 'package:flutter/material.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingContent(
        points: const [
          'Shops near you',
          'Leave your reviews',
          'Search for the perfect shop to buy anything',
        ],
        showBottomImage: true,
        onNext: () {
          AppRoutes.pushAndRemoveUntil(context, const Signuppagescreen());
        },
        onSkip: () {
          AppRoutes.pushAndRemoveUntil(context, const Signuppagescreen());
        },
      ),
    );
  }
}
