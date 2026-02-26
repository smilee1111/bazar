import 'package:bazar/app/theme/colors.dart';
import 'package:flutter/material.dart';

class ShopSkeletonCard extends StatelessWidget {
  const ShopSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonLine(widthFactor: 0.55, height: 14),
          SizedBox(height: 10),
          _SkeletonLine(widthFactor: 0.95, height: 11),
          SizedBox(height: 6),
          _SkeletonLine(widthFactor: 0.8, height: 11),
          SizedBox(height: 12),
          _SkeletonLine(widthFactor: 0.4, height: 11),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.widthFactor, required this.height});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceStrong,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
