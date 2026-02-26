import 'package:bazar/core/error/failure.dart';
import 'package:bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, PaginatedNotificationEntity>> getNotifications({
    int page,
    int size,
    bool? isRead,
  });
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, NotificationEntity>> getNotificationById(String id);
  Future<Either<Failure, NotificationEntity>> markAsRead(String id);
  Future<Either<Failure, bool>> markMultipleAsRead(List<String> ids);
  Future<Either<Failure, bool>> markAllAsRead();
  Future<Either<Failure, bool>> deleteNotification(String id);
  Future<Either<Failure, bool>> deleteAllNotifications();
}
