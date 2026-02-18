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
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/bgimage.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
                if (showTopLogo) Image.asset('assets/images/bazarlogo.png'),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            color: const Color(0xFFF5F0C5),
            child: bottomChild,
          ),
        ),
      ],
    );
  }
}
