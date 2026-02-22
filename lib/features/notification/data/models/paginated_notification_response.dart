import 'package:bazar/features/notification/data/models/notification_model.dart';
import 'package:bazar/features/notification/domain/entities/notification_entity.dart';

class PaginationModel {
  final int page;
  final int size;
  final int total;
  final int totalPages;

  const PaginationModel({
    required this.page,
    required this.size,
    required this.total,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic value, int fallback) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    return PaginationModel(
      page: asInt(json['page'], 1),
      size: asInt(json['size'], 20),
      total: asInt(json['total'], 0),
      totalPages: asInt(json['totalPages'], 1),
    );
  }

  NotificationPaginationEntity toEntity() {
    return NotificationPaginationEntity(
      page: page,
      size: size,
      total: total,
      totalPages: totalPages,
    );
  }
}

class PaginatedNotificationResponse {
  final bool success;
  final List<NotificationModel> data;
  final PaginationModel pagination;
  final int unreadCount;
  final String message;

  const PaginatedNotificationResponse({
    required this.success,
    required this.data,
    required this.pagination,
    required this.unreadCount,
    required this.message,
  });

  factory PaginatedNotificationResponse.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic value, int fallback) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    final rawItems = json['data'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(NotificationModel.fromJson)
              .toList()
        : <NotificationModel>[];
    final rawPagination = json['pagination'];
    final pagination = rawPagination is Map<String, dynamic>
        ? PaginationModel.fromJson(rawPagination)
        : const PaginationModel(page: 1, size: 20, total: 0, totalPages: 1);

    return PaginatedNotificationResponse(
      success: json['success'] == true,
      data: items,
      pagination: pagination,
      unreadCount: asInt(json['unreadCount'], 0),
      message: (json['message'] ?? '').toString(),
    );
  }

  PaginatedNotificationEntity toEntity() {
    return PaginatedNotificationEntity(
      items: data.map((item) => item.toEntity()).toList(),
      pagination: pagination.toEntity(),
      unreadCount: unreadCount,
      message: message,
    );
  }
}
