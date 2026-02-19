import 'package:bazar/app/theme/colors.dart';
import 'package:bazar/app/theme/textstyle.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:flutter/material.dart';

class ShopPublicDetailPage extends StatelessWidget {
  const ShopPublicDetailPage({super.key, required this.shop});

  final ShopEntity shop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(shop.shopName)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.shopName,
                  style: AppTextStyle.inputBox.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if ((shop.slug ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '@${shop.slug}',
                    style: AppTextStyle.minimalTexts.copyWith(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                _InfoTile(
                  icon: Icons.location_on_outlined,
                  text: shop.shopAddress,
                ),
                _InfoTile(icon: Icons.phone_outlined, text: shop.shopContact),
                if ((shop.contactNumber ?? '').isNotEmpty)
                  _InfoTile(
                    icon: Icons.call_outlined,
                    text: shop.contactNumber!,
                  ),
                if ((shop.email ?? '').isNotEmpty)
                  _InfoTile(
                    icon: Icons.mail_outline_rounded,
                    text: shop.email!,
                  ),
                if ((shop.description ?? '').isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    'About',
                    style: AppTextStyle.inputBox.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    shop.description!,
                    style: AppTextStyle.minimalTexts.copyWith(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.inputBox.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
