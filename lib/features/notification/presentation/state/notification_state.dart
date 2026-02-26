import 'package:bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:equatable/equatable.dart';

enum NotificationReadFilter { all, unread, read }

class NotificationState extends Equatable {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isMarkingAllRead;
  final bool isDeletingAll;
  final bool hasLoaded;
  final bool hasMore;
  final int page;
  final int size;
  final int totalPages;
  final String? errorMessage;
  final NotificationReadFilter filter;
  final Set<String> processingIds;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.isMarkingAllRead = false,
    this.isDeletingAll = false,
    this.hasLoaded = false,
    this.hasMore = true,
    this.page = 1,
    this.size = 20,
    this.totalPages = 1,
    this.errorMessage,
    this.filter = NotificationReadFilter.all,
    this.processingIds = const {},
  });

  NotificationState copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isMarkingAllRead,
    bool? isDeletingAll,
    bool? hasLoaded,
    bool? hasMore,
    int? page,
    int? size,
    int? totalPages,
    String? errorMessage,
    bool clearError = false,
    NotificationReadFilter? filter,
    Set<String>? processingIds,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
      isDeletingAll: isDeletingAll ?? this.isDeletingAll,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      size: size ?? this.size,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      filter: filter ?? this.filter,
      processingIds: processingIds ?? this.processingIds,
    );
  }

  @override
  List<Object?> get props => [
    notifications,
    unreadCount,
    isLoading,
    isRefreshing,
    isLoadingMore,
    isMarkingAllRead,
    isDeletingAll,
    hasLoaded,
    hasMore,
    page,
    size,
    totalPages,
    errorMessage,
    filter,
    processingIds,
  ];
}
