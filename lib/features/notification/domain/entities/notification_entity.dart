import 'package:equatable/equatable.dart';

enum NotificationType {
  reviewLike,
  reviewDislike,
  newShop,
  shopReviewed,
  sellerApplication,
  general,
}

enum RelatedEntityType { shop, review, user, unknown }

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final String? relatedEntityId;
  final RelatedEntityType relatedEntityType;
  final bool isRead;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.relatedEntityId,
    required this.relatedEntityType,
    required this.isRead,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  NotificationEntity copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    String? relatedEntityId,
    bool clearRelatedEntityId = false,
    RelatedEntityType? relatedEntityType,
    bool? isRead,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      relatedEntityId: clearRelatedEntityId
          ? null
          : (relatedEntityId ?? this.relatedEntityId),
      relatedEntityType: relatedEntityType ?? this.relatedEntityType,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    title,
    message,
    relatedEntityId,
    relatedEntityType,
    isRead,
    metadata,
    createdAt,
    updatedAt,
  ];
}

class NotificationPaginationEntity extends Equatable {
  final int page;
  final int size;
  final int total;
  final int totalPages;

  const NotificationPaginationEntity({
    required this.page,
    required this.size,
    required this.total,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [page, size, total, totalPages];
}

class PaginatedNotificationEntity extends Equatable {
  final List<NotificationEntity> items;
  final NotificationPaginationEntity pagination;
  final int unreadCount;
  final String message;

  const PaginatedNotificationEntity({
    required this.items,
    required this.pagination,
    required this.unreadCount,
    required this.message,
  });

  @override
  List<Object?> get props => [items, pagination, unreadCount, message];
}
