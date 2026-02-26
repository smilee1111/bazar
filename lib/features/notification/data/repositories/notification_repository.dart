import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/services/connectivity/network_info.dart';
import 'package:bazar/features/notification/data/datasources/notification_api_service.dart';
import 'package:bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:bazar/features/notification/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  return NotificationRepository(
    apiService: ref.read(notificationApiServiceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class NotificationRepository implements INotificationRepository {
  final INotificationApiService _apiService;
  final NetworkInfo _networkInfo;

  NotificationRepository({
    required INotificationApiService apiService,
    required NetworkInfo networkInfo,
  }) : _apiService = apiService,
       _networkInfo = networkInfo;

  String _extractErrorMessage(Object? data, String fallback) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) return message;
    }
    if (data is String && data.trim().isNotEmpty) return data;
    return fallback;
  }

  Future<bool> _guardNetwork() async {
    return _networkInfo.isConnected;
  }

  @override
  Future<Either<Failure, bool>> deleteAllNotifications() async {
    if (!await _guardNetwork()) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      await _apiService.deleteAllNotifications();
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractErrorMessage(
            e.response?.data,
            'Failed to delete all notifications',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNotification(String id) async {
    if (!await _guardNetwork()) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      await _apiService.deleteNotification(id);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractErrorMessage(
            e.response?.data,
            'Failed to delete notification',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> getNotificationById(
    String id,
  ) async {
    if (!await _guardNetwork()) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final model = await _apiService.getNotificationById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractErrorMessage(
            e.response?.data,
            'Failed to fetch notification',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedNotificationEntity>> getNotifications({
    int page = 1,
    int size = 20,
    bool? isRead,
  }) async {
    if (!await _guardNetwork()) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final response = await _apiService.getNotifications(
        page: page,
        size: size,
        isRead: isRead,
      );
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractErrorMessage(
            e.response?.data,
            'Failed to fetch notifications',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    if (!await _guardNetwork()) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final count = await _apiService.getUnreadCount();
      return Right(count);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractErrorMessage(
            e.response?.data,
            'Failed to fetch unread count',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAllAsRead() async {
    if (!await _guardNetwork()) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      await _apiService.markAllAsRead();
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractErrorMessage(
            e.response?.data,
            'Failed to mark all notifications as read',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> markAsRead(String id) async {
    if (!await _guardNetwork()) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final model = await _apiService.markAsRead(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractErrorMessage(
            e.response?.data,
            'Failed to mark notification as read',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markMultipleAsRead(List<String> ids) async {
    if (!await _guardNetwork()) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      await _apiService.markMultipleAsRead(ids);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          statusCode: e.response?.statusCode,
          message: _extractErrorMessage(
            e.response?.data,
            'Failed to mark notifications as read',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
