import 'package:bazar/features/notification/domain/entities/notification_entity.dart';

class NotificationModel {
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

  const NotificationModel({
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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String? asString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    bool asBool(dynamic value) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) return value.toLowerCase() == 'true';
      return false;
    }

    DateTime asDate(dynamic value) {
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
      return DateTime.now();
    }

    Map<String, dynamic> asMap(dynamic value) {
      if (value is Map<String, dynamic>) return value;
      return <String, dynamic>{};
    }

    NotificationType parseType(String? value) {
      switch ((value ?? '').toLowerCase()) {
        case 'review_like':
          return NotificationType.reviewLike;
        case 'review_dislike':
          return NotificationType.reviewDislike;
        case 'new_shop':
          return NotificationType.newShop;
        case 'shop_reviewed':
          return NotificationType.shopReviewed;
        case 'seller_application':
          return NotificationType.sellerApplication;
        default:
          return NotificationType.general;
      }
    }

    RelatedEntityType parseRelatedEntityType(String? value) {
      switch ((value ?? '').toLowerCase()) {
        case 'shop':
          return RelatedEntityType.shop;
        case 'review':
          return RelatedEntityType.review;
        case 'user':
          return RelatedEntityType.user;
        default:
          return RelatedEntityType.unknown;
      }
    }

    return NotificationModel(
      id: asString(json['_id']) ?? '',
      userId: asString(json['userId']) ?? '',
      type: parseType(asString(json['type'])),
      title: asString(json['title']) ?? '',
      message: asString(json['message']) ?? '',
      relatedEntityId: asString(json['relatedEntityId']),
      relatedEntityType: parseRelatedEntityType(
        asString(json['relatedEntityType']),
      ),
      isRead: asBool(json['isRead']),
      metadata: asMap(json['metadata']),
      createdAt: asDate(json['createdAt']),
      updatedAt: asDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    String typeValue() {
      switch (type) {
        case NotificationType.reviewLike:
          return 'review_like';
        case NotificationType.reviewDislike:
          return 'review_dislike';
        case NotificationType.newShop:
          return 'new_shop';
        case NotificationType.shopReviewed:
          return 'shop_reviewed';
        case NotificationType.sellerApplication:
          return 'seller_application';
        case NotificationType.general:
          return 'general';
      }
    }

    String relatedEntityTypeValue() {
      switch (relatedEntityType) {
        case RelatedEntityType.shop:
          return 'shop';
        case RelatedEntityType.review:
          return 'review';
        case RelatedEntityType.user:
          return 'user';
        case RelatedEntityType.unknown:
          return 'unknown';
      }
    }

    return {
      '_id': id,
      'userId': userId,
      'type': typeValue(),
      'title': title,
      'message': message,
      'relatedEntityId': relatedEntityId,
      'relatedEntityType': relatedEntityTypeValue(),
      'isRead': isRead,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      relatedEntityId: relatedEntityId,
      relatedEntityType: relatedEntityType,
      isRead: isRead,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      title: entity.title,
      message: entity.message,
      relatedEntityId: entity.relatedEntityId,
      relatedEntityType: entity.relatedEntityType,
      isRead: entity.isRead,
      metadata: entity.metadata,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
