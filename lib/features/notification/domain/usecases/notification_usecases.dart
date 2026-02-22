import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/notification/data/repositories/notification_repository.dart';
import 'package:bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:bazar/features/notification/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetNotificationsParams extends Equatable {
  final int page;
  final int size;
  final bool? isRead;

  const GetNotificationsParams({
    this.page = 1,
    this.size = 20,
    this.isRead,
  });

  @override
  List<Object?> get props => [page, size, isRead];
}

class NotificationIdParams extends Equatable {
  final String id;

  const NotificationIdParams(this.id);

  @override
  List<Object?> get props => [id];
}

class MultipleNotificationIdsParams extends Equatable {
  final List<String> ids;

  const MultipleNotificationIdsParams(this.ids);

  @override
  List<Object?> get props => [ids];
}

final getNotificationsUsecaseProvider = Provider<GetNotificationsUsecase>((
  ref,
) {
  return GetNotificationsUsecase(repository: ref.read(notificationRepositoryProvider));
});

class GetNotificationsUsecase
    implements
        UsecaseWithParams<PaginatedNotificationEntity, GetNotificationsParams> {
  final INotificationRepository _repository;

  GetNotificationsUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, PaginatedNotificationEntity>> call(
    GetNotificationsParams params,
  ) {
    return _repository.getNotifications(
      page: params.page,
      size: params.size,
      isRead: params.isRead,
    );
  }
}

final getUnreadCountUsecaseProvider = Provider<GetUnreadCountUsecase>((ref) {
  return GetUnreadCountUsecase(repository: ref.read(notificationRepositoryProvider));
});

class GetUnreadCountUsecase implements UsecaseWithoutParams<int> {
  final INotificationRepository _repository;

  GetUnreadCountUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, int>> call() {
    return _repository.getUnreadCount();
  }
}

final getNotificationByIdUsecaseProvider = Provider<GetNotificationByIdUsecase>((
  ref,
) {
  return GetNotificationByIdUsecase(repository: ref.read(notificationRepositoryProvider));
});

class GetNotificationByIdUsecase
    implements UsecaseWithParams<NotificationEntity, NotificationIdParams> {
  final INotificationRepository _repository;

  GetNotificationByIdUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, NotificationEntity>> call(NotificationIdParams params) {
    return _repository.getNotificationById(params.id);
  }
}

final markNotificationAsReadUsecaseProvider = Provider<MarkNotificationAsReadUsecase>((
  ref,
) {
  return MarkNotificationAsReadUsecase(repository: ref.read(notificationRepositoryProvider));
});

class MarkNotificationAsReadUsecase
    implements UsecaseWithParams<NotificationEntity, NotificationIdParams> {
  final INotificationRepository _repository;

  MarkNotificationAsReadUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, NotificationEntity>> call(NotificationIdParams params) {
    return _repository.markAsRead(params.id);
  }
}

final markMultipleNotificationsReadUsecaseProvider =
    Provider<MarkMultipleNotificationsReadUsecase>((ref) {
      return MarkMultipleNotificationsReadUsecase(
        repository: ref.read(notificationRepositoryProvider),
      );
    });

class MarkMultipleNotificationsReadUsecase
    implements UsecaseWithParams<bool, MultipleNotificationIdsParams> {
  final INotificationRepository _repository;

  MarkMultipleNotificationsReadUsecase({
    required INotificationRepository repository,
  }) : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(MultipleNotificationIdsParams params) {
    return _repository.markMultipleAsRead(params.ids);
  }
}

final markAllNotificationsReadUsecaseProvider =
    Provider<MarkAllNotificationsReadUsecase>((ref) {
      return MarkAllNotificationsReadUsecase(
        repository: ref.read(notificationRepositoryProvider),
      );
    });

class MarkAllNotificationsReadUsecase implements UsecaseWithoutParams<bool> {
  final INotificationRepository _repository;

  MarkAllNotificationsReadUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call() {
    return _repository.markAllAsRead();
  }
}

final deleteNotificationUsecaseProvider = Provider<DeleteNotificationUsecase>((
  ref,
) {
  return DeleteNotificationUsecase(repository: ref.read(notificationRepositoryProvider));
});

class DeleteNotificationUsecase
    implements UsecaseWithParams<bool, NotificationIdParams> {
  final INotificationRepository _repository;

  DeleteNotificationUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(NotificationIdParams params) {
    return _repository.deleteNotification(params.id);
  }
}

final deleteAllNotificationsUsecaseProvider =
    Provider<DeleteAllNotificationsUsecase>((ref) {
      return DeleteAllNotificationsUsecase(
        repository: ref.read(notificationRepositoryProvider),
      );
    });

class DeleteAllNotificationsUsecase implements UsecaseWithoutParams<bool> {
  final INotificationRepository _repository;

  DeleteAllNotificationsUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call() {
    return _repository.deleteAllNotifications();
  }
}
