import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/features/notification/data/datasources/notification_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  late _MockApiClient apiClient;
  late NotificationApiService service;

  setUp(() {
    apiClient = _MockApiClient();
    service = NotificationApiService(apiClient: apiClient);
  });

  test('getNotifications parses paginated payload', () async {
    when(
      () => apiClient.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/v1/user/notification'),
        data: {
          'success': true,
          'data': [
            {
              '_id': 'n1',
              'userId': 'u1',
              'type': 'general',
              'title': 'Welcome',
              'message': 'Hello',
              'isRead': false,
              'metadata': {},
              'createdAt': '2026-02-21T00:00:00.000Z',
              'updatedAt': '2026-02-21T00:00:00.000Z',
            },
          ],
          'pagination': {'page': 1, 'size': 20, 'total': 1, 'totalPages': 1},
          'unreadCount': 1,
          'message': 'ok',
        },
      ),
    );

    final result = await service.getNotifications();

    expect(result.data.length, 1);
    expect(result.unreadCount, 1);
    expect(result.pagination.total, 1);
  });

  test('getUnreadCount parses unread count', () async {
    when(
      () => apiClient.get(any(), queryParameters: any(named: 'queryParameters'), options: any(named: 'options')),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/v1/user/notification/unread-count'),
        data: {
          'success': true,
          'data': {'unreadCount': 5},
          'message': 'ok',
        },
      ),
    );

    final result = await service.getUnreadCount();
    expect(result, 5);
  });

  test('markAsRead returns updated notification', () async {
    when(
      () => apiClient.patch(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/v1/user/notification/n1/read'),
        data: {
          'success': true,
          'data': {
            '_id': 'n1',
            'userId': 'u1',
            'type': 'general',
            'title': 'Welcome',
            'message': 'Hello',
            'isRead': true,
            'metadata': {},
            'createdAt': '2026-02-21T00:00:00.000Z',
            'updatedAt': '2026-02-21T00:00:00.000Z',
          },
          'message': 'ok',
        },
      ),
    );

    final result = await service.markAsRead('n1');
    expect(result.id, 'n1');
    expect(result.isRead, true);
  });
}
