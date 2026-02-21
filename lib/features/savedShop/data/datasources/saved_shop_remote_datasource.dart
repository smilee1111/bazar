import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/features/savedShop/data/models/saved_shop_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class ISavedShopRemoteDataSource {
  Future<List<SavedShopApiModel>> getSavedShops();
  Future<SavedShopApiModel> saveShop(String shopId);
  Future<bool> removeSavedShop(String shopId);
}

final savedShopRemoteDataSourceProvider = Provider<ISavedShopRemoteDataSource>((
  ref,
) {
  return SavedShopRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class SavedShopRemoteDataSource implements ISavedShopRemoteDataSource {
  final ApiClient _apiClient;

  SavedShopRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  List<SavedShopApiModel> _extractList(dynamic payload) {
    dynamic data = payload;
    if (payload is Map<String, dynamic>) {
      data = payload['data'] ?? payload['savedShops'] ?? payload['items'];
    }
    if (data is Map<String, dynamic>) {
      data = data['savedShops'] ?? data['items'] ?? data['data'];
    }
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(SavedShopApiModel.fromJson)
          .toList();
    }
    return const [];
  }

  SavedShopApiModel _extractOne(dynamic payload) {
    dynamic data = payload;
    if (payload is Map<String, dynamic>) {
      data = payload['data'] ?? payload['savedShop'] ?? payload;
    }
    if (data is Map<String, dynamic>) {
      final nested = data['savedShop'];
      if (nested is Map<String, dynamic>) {
        return SavedShopApiModel.fromJson(nested);
      }
      return SavedShopApiModel.fromJson(data);
    }
    throw Exception('Invalid saved shop payload');
  }

  @override
  Future<List<SavedShopApiModel>> getSavedShops() async {
    final response = await _apiClient.get(ApiEndpoints.userSavedShops);
    return _extractList(response.data);
  }

  @override
  Future<bool> removeSavedShop(String shopId) async {
    final response = await _apiClient.delete(
      '${ApiEndpoints.userSavedShops}/$shopId',
    );
    if (response.data is Map<String, dynamic>) {
      return response.data['success'] == true;
    }
    return true;
  }

  @override
  Future<SavedShopApiModel> saveShop(String shopId) async {
    final response = await _apiClient.post(
      ApiEndpoints.userSavedShops,
      data: {'shopId': shopId},
    );
    return _extractOne(response.data);
  }
}
