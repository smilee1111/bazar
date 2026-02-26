import 'dart:async';

import 'package:bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:bazar/features/notification/domain/usecases/notification_usecases.dart';
import 'package:bazar/features/notification/presentation/state/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
      NotificationViewModel.new,
    );

class NotificationViewModel extends Notifier<NotificationState> {
  GetNotificationsUsecase? _getNotificationsUsecase;
  GetUnreadCountUsecase? _getUnreadCountUsecase;
  MarkNotificationAsReadUsecase? _markAsReadUsecase;
  MarkMultipleNotificationsReadUsecase? _markMultipleReadUsecase;
  MarkAllNotificationsReadUsecase? _markAllReadUsecase;
  DeleteNotificationUsecase? _deleteNotificationUsecase;
  DeleteAllNotificationsUsecase? _deleteAllNotificationsUsecase;

  Timer? _autoRefreshTimer;
  DateTime? _lastRefreshAt;

  GetNotificationsUsecase get _getNotifications =>
      (_getNotificationsUsecase ??= ref.read(getNotificationsUsecaseProvider))!;
  GetUnreadCountUsecase get _getUnreadCount =>
      (_getUnreadCountUsecase ??= ref.read(getUnreadCountUsecaseProvider))!;
  MarkNotificationAsReadUsecase get _markAsRead =>
      (_markAsReadUsecase ??= ref.read(markNotificationAsReadUsecaseProvider))!;
  MarkMultipleNotificationsReadUsecase get _markMultipleRead =>
      (_markMultipleReadUsecase ??=
          ref.read(markMultipleNotificationsReadUsecaseProvider))!;
  MarkAllNotificationsReadUsecase get _markAllRead =>
      (_markAllReadUsecase ??=
          ref.read(markAllNotificationsReadUsecaseProvider))!;
  DeleteNotificationUsecase get _deleteNotification =>
      (_deleteNotificationUsecase ??=
          ref.read(deleteNotificationUsecaseProvider))!;
  DeleteAllNotificationsUsecase get _deleteAllNotifications =>
      (_deleteAllNotificationsUsecase ??=
          ref.read(deleteAllNotificationsUsecaseProvider))!;

  @override
  NotificationState build() {
    _getNotificationsUsecase = _getNotifications;
    _getUnreadCountUsecase = _getUnreadCount;
    _markAsReadUsecase = _markAsRead;
    _markMultipleReadUsecase = _markMultipleRead;
    _markAllReadUsecase = _markAllRead;
    _deleteNotificationUsecase = _deleteNotification;
    _deleteAllNotificationsUsecase = _deleteAllNotifications;

    _startAutoRefresh();
    Future.microtask(() async {
      await loadNotifications(forceRefresh: true);
      await loadUnreadCount(forceRefresh: true);
    });

    ref.onDispose(() {
      _autoRefreshTimer?.cancel();
      _autoRefreshTimer = null;
    });

    return const NotificationState();
  }

  List<NotificationEntity> get recentNotifications {
    final sorted = [...state.notifications]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(10).toList();
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await loadUnreadCount(forceRefresh: true);
      await loadNotifications(forceRefresh: true, silent: true);
    });
  }

  bool _shouldDebounceRefresh({required bool forceRefresh}) {
    if (forceRefresh) return false;
    final last = _lastRefreshAt;
    if (last == null) return false;
    final elapsed = DateTime.now().difference(last);
    return elapsed.inSeconds < 2;
  }

  bool? _filterToReadValue(NotificationReadFilter filter) {
    switch (filter) {
      case NotificationReadFilter.unread:
        return false;
      case NotificationReadFilter.read:
        return true;
      case NotificationReadFilter.all:
        return null;
    }
  }

  Future<void> setFilter(NotificationReadFilter filter) async {
    if (state.filter == filter) return;
    state = state.copyWith(
      filter: filter,
      notifications: const [],
      page: 1,
      hasMore: true,
      hasLoaded: false,
      clearError: true,
    );
    await loadNotifications(forceRefresh: true);
  }

  Future<void> loadUnreadCount({bool forceRefresh = false}) async {
    if (_shouldDebounceRefresh(forceRefresh: forceRefresh)) return;
    final result = await _getUnreadCount();
    result.fold((_) {}, (count) {
      state = state.copyWith(unreadCount: count);
    });
  }

  Future<void> loadNotifications({
    bool forceRefresh = false,
    bool silent = false,
  }) async {
    if (state.isLoading || state.isRefreshing) return;
    if (_shouldDebounceRefresh(forceRefresh: forceRefresh)) return;
    if (!forceRefresh && state.hasLoaded) return;

    if (!silent) {
      state = state.copyWith(isLoading: true, clearError: true);
    }
    final result = await _getNotifications(
      GetNotificationsParams(
        page: 1,
        size: state.size,
        isRead: _filterToReadValue(state.filter),
      ),
    );
    _lastRefreshAt = DateTime.now();
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          hasLoaded: true,
          errorMessage: failure.message,
        );
      },
      (response) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          hasLoaded: true,
          notifications: response.items,
          page: response.pagination.page,
          totalPages: response.pagination.totalPages,
          hasMore: response.pagination.page < response.pagination.totalPages,
          unreadCount: response.unreadCount,
          clearError: true,
        );
      },
    );
  }

  Future<void> refresh() async {
    if (state.isRefreshing) return;
    state = state.copyWith(isRefreshing: true, clearError: true);
    await loadNotifications(forceRefresh: true);
    await loadUnreadCount(forceRefresh: true);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true, clearError: true);
    final nextPage = state.page + 1;
    final result = await _getNotifications(
      GetNotificationsParams(
        page: nextPage,
        size: state.size,
        isRead: _filterToReadValue(state.filter),
      ),
    );
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        );
      },
      (response) {
        final merged = [...state.notifications, ...response.items];
        state = state.copyWith(
          isLoadingMore: false,
          notifications: merged,
          page: response.pagination.page,
          totalPages: response.pagination.totalPages,
          hasMore: response.pagination.page < response.pagination.totalPages,
          unreadCount: response.unreadCount,
          clearError: true,
        );
      },
    );
  }

  Future<bool> markAsRead(String id) async {
    final found = state.notifications.where((item) => item.id == id).toList();
    if (found.isEmpty) return false;
    if (found.first.isRead) return true;

    final previous = [...state.notifications];
    final optimistic = state.notifications
        .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
        .toList();
    final processing = {...state.processingIds, id};

    state = state.copyWith(
      notifications: optimistic,
      unreadCount: (state.unreadCount - 1).clamp(0, 1 << 31),
      processingIds: processing,
      clearError: true,
    );

    final result = await _markAsRead(NotificationIdParams(id));
    return result.fold(
      (failure) {
        final updatedProcessing = {...state.processingIds}..remove(id);
        state = state.copyWith(
          notifications: previous,
          unreadCount: _computeUnreadCount(previous),
          processingIds: updatedProcessing,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        final updatedProcessing = {...state.processingIds}..remove(id);
        state = state.copyWith(processingIds: updatedProcessing, clearError: true);
        return true;
      },
    );
  }

  Future<bool> markMultipleAsRead(List<String> ids) async {
    if (ids.isEmpty) return true;
    final set = ids.toSet();
    final previous = [...state.notifications];
    final optimistic = state.notifications
        .map((item) => set.contains(item.id) ? item.copyWith(isRead: true) : item)
        .toList();

    state = state.copyWith(
      notifications: optimistic,
      unreadCount: _computeUnreadCount(optimistic),
      clearError: true,
    );

    final result = await _markMultipleRead(
      MultipleNotificationIdsParams(ids),
    );
    return result.fold(
      (failure) {
        state = state.copyWith(
          notifications: previous,
          unreadCount: _computeUnreadCount(previous),
          errorMessage: failure.message,
        );
        return false;
      },
      (_) => true,
    );
  }

  Future<bool> markAllAsRead() async {
    if (state.isMarkingAllRead) return false;
    final previous = [...state.notifications];
    final optimistic = state.notifications
        .map((item) => item.copyWith(isRead: true))
        .toList();
    state = state.copyWith(
      isMarkingAllRead: true,
      notifications: optimistic,
      unreadCount: 0,
      clearError: true,
    );
    final result = await _markAllRead();
    return result.fold(
      (failure) {
        state = state.copyWith(
          isMarkingAllRead: false,
          notifications: previous,
          unreadCount: _computeUnreadCount(previous),
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isMarkingAllRead: false, clearError: true);
        return true;
      },
    );
  }

  Future<bool> deleteNotification(String id) async {
    final previous = [...state.notifications];
    final optimistic = state.notifications.where((item) => item.id != id).toList();
    state = state.copyWith(
      notifications: optimistic,
      unreadCount: _computeUnreadCount(optimistic),
      clearError: true,
    );

    final result = await _deleteNotification(NotificationIdParams(id));
    return result.fold(
      (failure) {
        state = state.copyWith(
          notifications: previous,
          unreadCount: _computeUnreadCount(previous),
          errorMessage: failure.message,
        );
        return false;
      },
      (_) => true,
    );
  }

  Future<bool> deleteAllNotifications() async {
    if (state.isDeletingAll) return false;
    final previous = [...state.notifications];
    final previousUnread = state.unreadCount;
    state = state.copyWith(
      isDeletingAll: true,
      notifications: const [],
      unreadCount: 0,
      hasMore: false,
      page: 1,
      totalPages: 1,
      clearError: true,
    );
    final result = await _deleteAllNotifications();
    return result.fold(
      (failure) {
        state = state.copyWith(
          isDeletingAll: false,
          notifications: previous,
          unreadCount: previousUnread,
          hasMore: previous.isNotEmpty,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isDeletingAll: false, clearError: true);
        return true;
      },
    );
  }

  int _computeUnreadCount(List<NotificationEntity> items) {
    return items.where((item) => !item.isRead).length;
  }
}
