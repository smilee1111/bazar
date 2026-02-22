import 'package:bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:flutter/material.dart';

class NotificationUiUtils {
  static IconData iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.reviewLike:
        return Icons.thumb_up_alt_rounded;
      case NotificationType.reviewDislike:
        return Icons.thumb_down_alt_rounded;
      case NotificationType.newShop:
        return Icons.storefront_rounded;
      case NotificationType.shopReviewed:
        return Icons.star_rounded;
      case NotificationType.sellerApplication:
        return Icons.assignment_rounded;
      case NotificationType.general:
        return Icons.notifications_rounded;
    }
  }

  static Color iconColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.reviewLike:
        return const Color(0xFF2E7D32);
      case NotificationType.reviewDislike:
        return const Color(0xFFC62828);
      case NotificationType.newShop:
        return const Color(0xFF6D4C41);
      case NotificationType.shopReviewed:
        return const Color(0xFFF9A825);
      case NotificationType.sellerApplication:
        return const Color(0xFF5E35B1);
      case NotificationType.general:
        return const Color(0xFF1976D2);
    }
  }

  static String relativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    final weeks = (diff.inDays / 7).floor();
    if (weeks < 5) return '${weeks}w ago';
    final months = (diff.inDays / 30).floor();
    if (months < 12) return '${months}mo ago';
    final years = (diff.inDays / 365).floor();
    return '${years}y ago';
  }

  static String sectionLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final item = DateTime(date.year, date.month, date.day);
    final diff = today.difference(item).inDays;
    if (diff <= 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return 'This Week';
    return 'Older';
  }
}
