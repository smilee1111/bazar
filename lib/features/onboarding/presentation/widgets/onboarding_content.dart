import 'package:bazar/app/theme/textstyle.dart';
import 'package:flutter/material.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.points,
    required this.onSkip,
    required this.onNext,
    this.showBottomImage = false,
  });

  final List<String> points;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final bool showBottomImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNext,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/bazarlogo.png', width: 90, height: 90),
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/image.png'),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Welcome , User!',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.h1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: points
                                .map(
                                  (point) => Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(
                                      point,
                                      style: AppTextStyle.landingTexts,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      if (showBottomImage) ...[
                        const SizedBox(height: 10),
                        Image.asset('assets/images/image2.png', height: 150),
                      ],
                    ],
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
