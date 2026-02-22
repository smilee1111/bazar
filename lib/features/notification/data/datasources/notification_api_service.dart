import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/features/notification/data/models/notification_api_response.dart';
import 'package:bazar/features/notification/data/models/notification_model.dart';
import 'package:bazar/features/notification/data/models/paginated_notification_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class INotificationApiService {
  Future<PaginatedNotificationResponse> getNotifications({
    int page,
    int size,
    bool? isRead,
  });
  Future<int> getUnreadCount();
  Future<NotificationModel> getNotificationById(String id);
  Future<NotificationModel> markAsRead(String id);
  Future<void> markMultipleAsRead(List<String> ids);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<void> deleteAllNotifications();
}

final notificationApiServiceProvider = Provider<INotificationApiService>((ref) {
  return NotificationApiService(apiClient: ref.read(apiClientProvider));
});

class NotificationApiService implements INotificationApiService {
  final ApiClient _apiClient;

  NotificationApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<void> deleteAllNotifications() async {
    await _apiClient.delete(ApiEndpoints.userNotifications);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await _apiClient.delete(ApiEndpoints.userNotificationById(id));
  }

  @override
  Future<NotificationModel> getNotificationById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.userNotificationById(id));
    final parsed = NotificationApiResponse<NotificationModel>.fromJson(
      response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : const <String, dynamic>{},
      dataParser: (data) {
        if (data is Map<String, dynamic>) return NotificationModel.fromJson(data);
        throw Exception('Invalid notification response payload.');
      },
    );
    return parsed.data;
  }

  @override
  Future<PaginatedNotificationResponse> getNotifications({
    int page = 1,
    int size = 20,
    bool? isRead,
  }) async {
    final query = <String, dynamic>{'page': page, 'size': size};
    if (isRead != null) {
      query['isRead'] = isRead;
    }
    final response = await _apiClient.get(
      ApiEndpoints.userNotifications,
      queryParameters: query,
    );
    final payload = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : const <String, dynamic>{};
    return PaginatedNotificationResponse.fromJson(payload);
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get(ApiEndpoints.userNotificationUnreadCount);
    final parsed = NotificationApiResponse<int>.fromJson(
      response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : const <String, dynamic>{},
      dataParser: (data) {
        if (data is Map<String, dynamic>) {
          final value = data['unreadCount'];
          if (value is int) return value;
          if (value is num) return value.toInt();
          if (value is String) return int.tryParse(value) ?? 0;
        }
        return 0;
      },
    );
    return parsed.data;
  }

  @override
  Future<void> markAllAsRead() async {
    await _apiClient.patch(ApiEndpoints.userNotificationMarkAllRead);
  }

  @override
  Future<NotificationModel> markAsRead(String id) async {
    final response = await _apiClient.patch(
      ApiEndpoints.markUserNotificationAsRead(id),
    );
    final parsed = NotificationApiResponse<NotificationModel>.fromJson(
      response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : const <String, dynamic>{},
      dataParser: (data) {
        if (data is Map<String, dynamic>) return NotificationModel.fromJson(data);
        throw Exception('Invalid mark-as-read response payload.');
      },
    );
    return parsed.data;
  }

  @override
  Future<void> markMultipleAsRead(List<String> ids) async {
    await _apiClient.patch(
      ApiEndpoints.userNotificationMarkMultipleRead,
      data: {'notificationIds': ids},
    );
  }
}
