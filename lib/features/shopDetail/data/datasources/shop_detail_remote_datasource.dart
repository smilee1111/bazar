import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/features/shopDetail/data/models/shop_detail_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class IShopDetailRemoteDataSource {
  Future<ShopDetailApiModel?> getDetailByShop(String shopId);
  Future<ShopDetailApiModel> getDetailById(String shopId, String detailId);
  Future<ShopDetailApiModel> createDetail(
    String shopId,
    ShopDetailApiModel detail,
  );
  Future<ShopDetailApiModel> updateDetail(
    String shopId,
    String detailId,
    ShopDetailApiModel detail,
  );
  Future<bool> deleteDetail(String shopId, String detailId);
}

final shopDetailRemoteDataSourceProvider =
    Provider<IShopDetailRemoteDataSource>((ref) {
      return ShopDetailRemoteDataSource(apiClient: ref.read(apiClientProvider));
    });

class ShopDetailRemoteDataSource implements IShopDetailRemoteDataSource {
  final ApiClient _apiClient;

  ShopDetailRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  ShopDetailApiModel _extract(dynamic payload) {
    dynamic data = payload;
    if (payload is Map<String, dynamic>) {
      data = payload['data'] ?? payload['detail'] ?? payload;
    }
    if (data is Map<String, dynamic>) {
      final nested = data['detail'];
      if (nested is Map<String, dynamic>) {
        return ShopDetailApiModel.fromJson(nested);
      }
      return ShopDetailApiModel.fromJson(data);
    }
    throw Exception('Invalid shop detail payload');
  }

  @override
  Future<ShopDetailApiModel> createDetail(
    String shopId,
    ShopDetailApiModel detail,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.shopDetailsByShop(shopId),
      data: detail.toJson(),
    );
    return _extract(response.data);
  }

  @override
  Future<bool> deleteDetail(String shopId, String detailId) async {
    final response = await _apiClient.delete(
      ApiEndpoints.shopDetailById(shopId, detailId),
    );
    if (response.data is Map<String, dynamic>) {
      return response.data['success'] == true;
    }
    return true;
  }

  @override
  Future<ShopDetailApiModel> getDetailById(
    String shopId,
    String detailId,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.shopDetailById(shopId, detailId),
    );
    return _extract(response.data);
  }

  @override
  Future<ShopDetailApiModel?> getDetailByShop(String shopId) async {
    final response = await _apiClient.get(
      ApiEndpoints.shopDetailsByShop(shopId),
    );
    final payload = response.data;
    if (payload is Map<String, dynamic> && payload['data'] == null) return null;
    return _extract(payload);
  }

  @override
  Future<ShopDetailApiModel> updateDetail(
    String shopId,
    String detailId,
    ShopDetailApiModel detail,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.shopDetailById(shopId, detailId),
      data: detail.toJson(),
    );
    return _extract(response.data);
  }
}
