import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/features/shopReview/data/models/shop_review_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class IShopReviewRemoteDataSource {
  Future<List<ShopReviewApiModel>> getReviewsByShop(String shopId);
  Future<ShopReviewApiModel> getReviewById(String shopId, String reviewId);
  Future<ShopReviewApiModel> createReview(
    String shopId,
    ShopReviewApiModel review,
  );
  Future<ShopReviewApiModel> updateReview(
    String shopId,
    String reviewId,
    ShopReviewApiModel review,
  );
  Future<bool> deleteReview(String shopId, String reviewId);
  Future<ShopReviewApiModel> likeReview(String reviewId);
  Future<ShopReviewApiModel> dislikeReview(String reviewId);
  Future<List<ShopReviewApiModel>> getUserReviews();
}

final shopReviewRemoteDataSourceProvider =
    Provider<IShopReviewRemoteDataSource>((ref) {
      return ShopReviewRemoteDataSource(apiClient: ref.read(apiClientProvider));
    });

class ShopReviewRemoteDataSource implements IShopReviewRemoteDataSource {
  final ApiClient _apiClient;

  ShopReviewRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  List<ShopReviewApiModel> _extractList(dynamic payload) {
    dynamic data = payload;
    if (payload is Map<String, dynamic>) {
      data = payload['data'] ?? payload['reviews'] ?? payload['items'];
    }
    if (data is Map<String, dynamic>) {
      data = data['reviews'] ?? data['items'] ?? data['data'];
    }
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(ShopReviewApiModel.fromJson)
          .toList();
    }
    return const [];
  }

  ShopReviewApiModel _extractOne(dynamic payload) {
    dynamic data = payload;
    if (payload is Map<String, dynamic>) {
      data = payload['data'] ?? payload['review'] ?? payload;
    }
    if (data is Map<String, dynamic>) {
      final nested = data['review'];
      if (nested is Map<String, dynamic>) {
        return ShopReviewApiModel.fromJson(nested);
      }
      return ShopReviewApiModel.fromJson(data);
    }
    throw Exception('Invalid shop review payload');
  }

  @override
  Future<ShopReviewApiModel> createReview(
    String shopId,
    ShopReviewApiModel review,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.shopReviewsByShop(shopId),
      data: review.toJson(),
    );
    return _extractOne(response.data);
  }

  @override
  Future<bool> deleteReview(String shopId, String reviewId) async {
    final response = await _apiClient.delete(
      ApiEndpoints.shopReviewById(shopId, reviewId),
    );
    if (response.data is Map<String, dynamic>) {
      return response.data['success'] == true;
    }
    return true;
  }

  @override
  Future<ShopReviewApiModel> dislikeReview(String reviewId) async {
    final response = await _apiClient.post(
      ApiEndpoints.dislikeShopReview(reviewId),
    );
    return _extractOne(response.data);
  }

  @override
  Future<ShopReviewApiModel> getReviewById(
    String shopId,
    String reviewId,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.shopReviewById(shopId, reviewId),
    );
    return _extractOne(response.data);
  }

  @override
  Future<List<ShopReviewApiModel>> getReviewsByShop(String shopId) async {
    final response = await _apiClient.get(
      ApiEndpoints.shopReviewsByShop(shopId),
    );
    return _extractList(response.data);
  }

  @override
  Future<List<ShopReviewApiModel>> getUserReviews() async {
    final response = await _apiClient.get(ApiEndpoints.userReviews);
    return _extractList(response.data);
  }

  @override
  Future<ShopReviewApiModel> likeReview(String reviewId) async {
    final response = await _apiClient.post(
      ApiEndpoints.likeShopReview(reviewId),
    );
    return _extractOne(response.data);
  }

  @override
  Future<ShopReviewApiModel> updateReview(
    String shopId,
    String reviewId,
    ShopReviewApiModel review,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.shopReviewById(shopId, reviewId),
      data: review.toJson(),
    );
    return _extractOne(response.data);
  }
}
