import 'package:bazar/app/theme/textstyle.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('CLICK\n\nTYPE\n\nFIND\n\nyour shop.', style: AppTextStyle.h1),
        const SizedBox(width: 5),
        SizedBox(
          width: 200,
          height: 300,
          child: Image.asset(
            'assets/images/image2.png',
            fit: BoxFit.cover,
            width: 100,
            height: 200,
          ),
        ),
      ],
    );
  }
}
