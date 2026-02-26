import 'package:bazar/core/utils/snackbar_utils.dart';
import 'package:bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:bazar/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:bazar/features/sellerApplication/presentation/pages/account_settings_page.dart';
import 'package:bazar/features/shop/domain/usecases/get_public_shop_by_id_usecase.dart';
import 'package:bazar/features/shop/presentation/pages/shop_public_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> handleNotificationTap({
  required BuildContext context,
  required WidgetRef ref,
  required NotificationEntity notification,
}) async {
  if (!notification.isRead) {
    await ref.read(notificationViewModelProvider.notifier).markAsRead(
      notification.id,
    );
  }

  final entityId = notification.relatedEntityId;
  switch (notification.relatedEntityType) {
    case RelatedEntityType.shop:
      if (entityId == null || entityId.isEmpty) {
        SnackbarUtils.showInfo(context, notification.message);
        return;
      }
      final result = await ref.read(getPublicShopByIdUsecaseProvider)(
        GetPublicShopByIdParams(shopId: entityId),
      );
      if (!context.mounted) return;
      result.fold(
        (_) => SnackbarUtils.showInfo(context, notification.message),
        (shop) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ShopPublicDetailPage(shop: shop)),
          );
        },
      );
      break;
    case RelatedEntityType.review:
      SnackbarUtils.showInfo(
        context,
        'Review detail screen is not available yet. Opening related shop when possible.',
      );
      if (entityId == null || entityId.isEmpty) return;
      final result = await ref.read(getPublicShopByIdUsecaseProvider)(
        GetPublicShopByIdParams(shopId: entityId),
      );
      if (!context.mounted) return;
      result.fold((_) {}, (shop) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ShopPublicDetailPage(shop: shop)),
        );
      });
      break;
    case RelatedEntityType.user:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AccountSettingsPage()),
      );
      break;
    case RelatedEntityType.unknown:
      SnackbarUtils.showInfo(context, notification.message);
      break;
  }
}
