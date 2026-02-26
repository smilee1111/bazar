import 'package:bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:bazar/features/notification/presentation/state/notification_state.dart';
import 'package:bazar/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:bazar/features/notification/presentation/widgets/notification_bell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestNotificationViewModel extends NotificationViewModel {
  @override
  NotificationState build() {
    return NotificationState(
      unreadCount: 120,
      notifications: [
        NotificationEntity(
          id: 'n1',
          userId: 'u1',
          type: NotificationType.general,
          title: 'Welcome',
          message: 'Hello',
          relatedEntityId: null,
          relatedEntityType: RelatedEntityType.unknown,
          isRead: false,
          metadata: const {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ],
      hasLoaded: true,
    );
  }
}

void main() {
  testWidgets('shows capped badge as 99+', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationViewModelProvider.overrideWith(_TestNotificationViewModel.new),
        ],
        child: const MaterialApp(
          home: Scaffold(body: Center(child: NotificationBell())),
        ),
      ),
    );

    expect(find.text('99+'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_rounded), findsOneWidget);
  });
}
