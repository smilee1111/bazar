import 'package:bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:bazar/features/notification/presentation/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  NotificationEntity buildNotification({required bool isRead}) {
    return NotificationEntity(
      id: 'n1',
      userId: 'u1',
      type: NotificationType.newShop,
      title: 'New shop added',
      message: 'A new shop is available',
      relatedEntityId: 's1',
      relatedEntityType: RelatedEntityType.shop,
      isRead: isRead,
      metadata: const {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  testWidgets('shows unread action when notification is unread', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationItem(notification: buildNotification(isRead: false)),
        ),
      ),
    );

    expect(find.text('New shop added'), findsOneWidget);
    expect(find.byIcon(Icons.done_rounded), findsOneWidget);
  });

  testWidgets('hides unread action when notification is already read', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationItem(notification: buildNotification(isRead: true)),
        ),
      ),
    );

    expect(find.byIcon(Icons.done_rounded), findsNothing);
  });
}
