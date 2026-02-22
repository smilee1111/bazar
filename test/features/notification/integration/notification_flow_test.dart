import 'package:bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:bazar/features/notification/presentation/pages/notification_list_page.dart';
import 'package:bazar/features/notification/presentation/state/notification_state.dart';
import 'package:bazar/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FlowNotificationViewModel extends NotificationViewModel {
  @override
  NotificationState build() {
    return NotificationState(
      unreadCount: 2,
      hasLoaded: true,
      notifications: [
        NotificationEntity(
          id: 'n1',
          userId: 'u1',
          type: NotificationType.reviewLike,
          title: 'Review liked',
          message: 'Someone liked your review',
          relatedEntityId: 's1',
          relatedEntityType: RelatedEntityType.shop,
          isRead: false,
          metadata: const {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        NotificationEntity(
          id: 'n2',
          userId: 'u1',
          type: NotificationType.newShop,
          title: 'New shop',
          message: 'New shop is now available',
          relatedEntityId: 's2',
          relatedEntityType: RelatedEntityType.shop,
          isRead: false,
          metadata: const {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ],
    );
  }

  @override
  Future<void> loadNotifications({bool forceRefresh = false, bool silent = false}) async {}

  @override
  Future<void> loadUnreadCount({bool forceRefresh = false}) async {}

  @override
  Future<void> refresh() async {}

  @override
  Future<void> loadMore() async {}

  @override
  Future<bool> markAllAsRead() async {
    state = state.copyWith(
      notifications: state.notifications
          .map((item) => item.copyWith(isRead: true))
          .toList(),
      unreadCount: 0,
    );
    return true;
  }
}

void main() {
  testWidgets('mark all as read updates unread count', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationViewModelProvider.overrideWith(_FlowNotificationViewModel.new),
        ],
        child: const MaterialApp(home: NotificationListPage()),
      ),
    );

    expect(find.text('2 unread'), findsOneWidget);
    await tester.tap(find.text('Mark all as read'));
    await tester.pumpAndSettle();
    expect(find.text('0 unread'), findsOneWidget);
  });
}
