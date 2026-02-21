import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/features/favourite/data/models/favourite_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class IFavouriteRemoteDataSource {
  Future<List<FavouriteApiModel>> getFavourites();
  Future<FavouriteApiModel> addFavourite({
    required String shopId,
    bool? isReviewed,
  });
  Future<bool> removeFavourite(String shopId);
}

final favouriteRemoteDataSourceProvider = Provider<IFavouriteRemoteDataSource>((
  ref,
) {
  return FavouriteRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class FavouriteRemoteDataSource implements IFavouriteRemoteDataSource {
  final ApiClient _apiClient;

  FavouriteRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  List<FavouriteApiModel> _extractList(dynamic payload) {
    dynamic data = payload;
    if (payload is Map<String, dynamic>) {
      data = payload['data'] ?? payload['favourites'] ?? payload['items'];
    }
    if (data is Map<String, dynamic>) {
      data = data['favourites'] ?? data['items'] ?? data['data'];
    }
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(FavouriteApiModel.fromJson)
          .toList();
    }
    return const [];
  }

  FavouriteApiModel _extractOne(dynamic payload) {
    dynamic data = payload;
    if (payload is Map<String, dynamic>) {
      data = payload['data'] ?? payload['favourite'] ?? payload;
    }
    if (data is Map<String, dynamic>) {
      final nested = data['favourite'];
      if (nested is Map<String, dynamic>) {
        return FavouriteApiModel.fromJson(nested);
      }
      return FavouriteApiModel.fromJson(data);
    }
    throw Exception('Invalid favourite payload');
  }

  @override
  Future<FavouriteApiModel> addFavourite({
    required String shopId,
    bool? isReviewed,
  }) async {
    final payload = {'shopId': shopId, if (isReviewed != null) 'isReviewed': isReviewed};
    final response = await _apiClient.post(
      ApiEndpoints.userFavourites,
      data: payload,
    );
    return _extractOne(response.data);
  }

  @override
  Future<List<FavouriteApiModel>> getFavourites() async {
    final response = await _apiClient.get(ApiEndpoints.userFavourites);
    return _extractList(response.data);
  }

  @override
  Future<bool> removeFavourite(String shopId) async {
    final response = await _apiClient.delete('${ApiEndpoints.userFavourites}/$shopId');
    if (response.data is Map<String, dynamic>) {
      return response.data['success'] == true;
    }
    return true;
  }
}
