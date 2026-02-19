import 'dart:io';

import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/features/shopPhoto/data/models/shop_photo_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class IShopPhotoRemoteDataSource {
  Future<List<ShopPhotoApiModel>> getPhotosByShop(String shopId);
  Future<ShopPhotoApiModel> getPhotoById(String shopId, String photoId);
  Future<ShopPhotoApiModel> createPhoto(String shopId, File image);
  Future<ShopPhotoApiModel> updatePhoto(
    String shopId,
    String photoId,
    File image,
  );
  Future<bool> deletePhoto(String shopId, String photoId);
}

final shopPhotoRemoteDataSourceProvider = Provider<IShopPhotoRemoteDataSource>((
  ref,
) {
  return ShopPhotoRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class ShopPhotoRemoteDataSource implements IShopPhotoRemoteDataSource {
  final ApiClient _apiClient;

  ShopPhotoRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  List<ShopPhotoApiModel> _extractList(dynamic payload) {
    dynamic data = payload;
    if (payload is Map<String, dynamic>) {
      data = payload['data'] ?? payload['photos'] ?? payload['items'];
    }
    if (data is Map<String, dynamic>) {
      data = data['photos'] ?? data['items'] ?? data['data'];
    }
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(ShopPhotoApiModel.fromJson)
          .toList();
    }
    return const [];
  }

  ShopPhotoApiModel _extractOne(dynamic payload) {
    dynamic data = payload;
    if (payload is Map<String, dynamic>) {
      data = payload['data'] ?? payload['photo'] ?? payload;
    }
    if (data is Map<String, dynamic>) {
      final nested = data['photo'];
      if (nested is Map<String, dynamic>) {
        return ShopPhotoApiModel.fromJson(nested);
      }
      return ShopPhotoApiModel.fromJson(data);
    }
    throw Exception('Invalid shop photo payload');
  }

  @override
  Future<ShopPhotoApiModel> createPhoto(String shopId, File image) async {
    final fileName = image.path.split('/').last;
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: fileName),
    });
    final response = await _apiClient.post(
      ApiEndpoints.shopPhotosByShop(shopId),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return _extractOne(response.data);
  }

  @override
  Future<bool> deletePhoto(String shopId, String photoId) async {
    final response = await _apiClient.delete(
      ApiEndpoints.shopPhotoById(shopId, photoId),
    );
    if (response.data is Map<String, dynamic>) {
      return response.data['success'] == true;
    }
    return true;
  }

  @override
  Future<ShopPhotoApiModel> getPhotoById(String shopId, String photoId) async {
    final response = await _apiClient.get(
      ApiEndpoints.shopPhotoById(shopId, photoId),
    );
    return _extractOne(response.data);
  }

  @override
  Future<List<ShopPhotoApiModel>> getPhotosByShop(String shopId) async {
    final response = await _apiClient.get(
      ApiEndpoints.shopPhotosByShop(shopId),
    );
    return _extractList(response.data);
  }

  @override
  Future<ShopPhotoApiModel> updatePhoto(
    String shopId,
    String photoId,
    File image,
  ) async {
    final fileName = image.path.split('/').last;
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: fileName),
    });
    final response = await _apiClient.put(
      ApiEndpoints.shopPhotoById(shopId, photoId),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return _extractOne(response.data);
  }
}
