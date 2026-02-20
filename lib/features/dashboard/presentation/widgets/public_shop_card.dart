import 'package:bazar/app/theme/colors.dart';
import 'package:bazar/app/theme/textstyle.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:flutter/material.dart';

class PublicShopCard extends StatelessWidget {
  const PublicShopCard({
    super.key,
    required this.shop,
    required this.onTap,
    required this.onToggleSave,
    required this.onToggleFavourite,
    required this.isSaved,
    required this.isFavourite,
    required this.isReviewed,
    this.isSaveBusy = false,
    this.isFavouriteBusy = false,
  });

  final ShopEntity shop;
  final VoidCallback onTap;
  final VoidCallback onToggleSave;
  final VoidCallback onToggleFavourite;
  final bool isSaved;
  final bool isFavourite;
  final bool isReviewed;
  final bool isSaveBusy;
  final bool isFavouriteBusy;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accent2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      shop.shopName,
                      style: AppTextStyle.inputBox.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _ActionIcon(
                    icon: isFavourite ? Icons.favorite : Icons.favorite_border,
                    activeColor: AppColors.error,
                    isActive: isFavourite,
                    isBusy: isFavouriteBusy,
                    onPressed: onToggleFavourite,
                    tooltip: isFavourite
                        ? 'Remove from favourites'
                        : 'Add to favourites',
                  ),
                  const SizedBox(width: 4),
                  _ActionIcon(
                    icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                    activeColor: AppColors.primary,
                    isActive: isSaved,
                    isBusy: isSaveBusy,
                    onPressed: onToggleSave,
                    tooltip: isSaved ? 'Remove from saved' : 'Save shop',
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                shop.shopAddress,
                style: AppTextStyle.minimalTexts.copyWith(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      shop.shopContact,
                      style: AppTextStyle.inputBox.copyWith(fontSize: 12),
                    ),
                  ),
                  if (isReviewed) const _ReviewedTag(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.activeColor,
    required this.isActive,
    required this.isBusy,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color activeColor;
  final bool isActive;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: isBusy
          ? const Padding(
              padding: EdgeInsets.all(6),
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : IconButton(
              onPressed: onPressed,
              tooltip: tooltip,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                icon,
                size: 18,
                color: isActive ? activeColor : Colors.grey.shade600,
              ),
            ),
    );
  }
}

class _ReviewedTag extends StatelessWidget {
  const _ReviewedTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.35)),
      ),
      child: Text(
        'You reviewed this',
        style: AppTextStyle.inputBox.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.info,
        ),
      ),
    );
  }
}
