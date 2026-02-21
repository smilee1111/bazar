import 'package:bazar/app/theme/textstyle.dart';
import 'package:flutter/material.dart';

class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: onPressed,
            child: Text(
              'Continue with Google',
              style: AppTextStyle.minimalTexts,
            ),
          ),
          const SizedBox(width: 10),
          Image.asset('assets/icons/googlelogo.png', width: 30, height: 30),
        ],
      ),
    );
  }
}
