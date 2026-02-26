import 'package:bazar/app/theme/colors.dart';
import 'package:flutter/material.dart';

class BrandingSplitLayout extends StatelessWidget {
  const BrandingSplitLayout({
    super.key,
    required this.bottomChild,
    this.showTopLogo = false,
  });

  final Widget bottomChild;
  final bool showTopLogo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/bgimage.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.darkBrown.withValues(alpha: 0.22),
                        Colors.transparent,
                        AppColors.primary.withValues(alpha: 0.32),
                      ],
                    ),
                  ),
                ),
              ),
              if (showTopLogo) Image.asset('assets/images/bazarlogo.png'),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: bottomChild,
          ),
        ),
      ],
    );
  }
}
