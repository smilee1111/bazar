import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/core/models/route_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routeServiceProvider = Provider<RouteService>((ref) {
  return RouteService(apiClient: ref.read(apiClientProvider));
});

class RouteService {
  final ApiClient _apiClient;

  RouteService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<RouteResult?> getRouteToShop({
    required String shopId,
    required double fromLat,
    required double fromLng,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.publicShopRouteById(shopId),
      queryParameters: {
        'fromLat': fromLat.toString(),
        'fromLng': fromLng.toString(),
      },
    );

    final payload = response.data;
    if (payload is! Map<String, dynamic>) return null;
    if (payload['success'] != true) return null;

    final data = payload['data'];
    if (data is! Map<String, dynamic>) return null;
    final dynamic routeCandidate = data['route'];
    final Map<String, dynamic>? route = routeCandidate is Map<String, dynamic>
        ? routeCandidate
        : (data['geometry'] is Map<String, dynamic> ? data : null);
    if (route == null) return null;

    return RouteResult.fromJson(route);
  }
}
