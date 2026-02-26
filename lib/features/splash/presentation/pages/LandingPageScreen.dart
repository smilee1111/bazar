import 'package:bazar/app/routes/app_routes.dart';
import 'package:bazar/app/theme/colors.dart';
import 'package:bazar/app/theme/textstyle.dart';
import 'package:bazar/features/onboarding/presentation/pages/OnboardingScreen.dart';
import 'package:bazar/features/splash/presentation/widgets/branding_split_layout.dart';
import 'package:flutter/material.dart';

class LandingPageScreen extends StatelessWidget {
  const LandingPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cream,
      ),
      body: BrandingSplitLayout(
        bottomChild: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Find your Shop.',
              style: AppTextStyle.h1.copyWith(
                fontSize: 32,
                fontStyle: FontStyle.italic,
                color: AppColors.primary,
              ),
            ),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: () {
                  AppRoutes.push(context, const Onboardingscreen());
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'BEGIN',
                  style: AppTextStyle.buttonText.copyWith(
                    fontSize: 20,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
