import 'package:bazar/app/theme/textstyle.dart';
import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/bazarlogo.png', width: 90, height: 90),
        const SizedBox(width: 20),
        Text(
          "Let's get you\nshopping smarter.",
          style: AppTextStyle.h1,
        ),
      ],
    );
  }
}
