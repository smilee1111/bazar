import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/features/category/data/datasources/category_datasource.dart';
import 'package:bazar/features/category/data/models/category_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRemoteProvider = Provider<ICategoryRemoteDataSource>((ref) {
  return CategoryRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class CategoryRemoteDatasource implements ICategoryRemoteDataSource {
  final ApiClient _apiClient;

  CategoryRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<bool> createCategory(CategoryApiModel category) async {
    final response = await _apiClient.get(ApiEndpoints.categories);
    return response.data['success'] == true;
  }

  @override
  Future<List<CategoryApiModel>> getAllCategories() async {
    Response response;
    try {
      response = await _apiClient.get(ApiEndpoints.userCategories);
    } on DioException catch (e) {
      if (e.response?.statusCode != 404) rethrow;
      response = await _apiClient.get(ApiEndpoints.categories);
    }

    final payload = response.data;
    List<dynamic> list = const [];

    if (payload is List) {
      list = payload;
    } else if (payload is Map<String, dynamic>) {
      final data = payload['data'];
      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic>) {
        final nested = data['categories'] ?? data['items'];
        if (nested is List) {
          list = nested;
        }
      } else {
        final nested = payload['categories'] ?? payload['items'];
        if (nested is List) {
          list = nested;
        }
      }
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map(CategoryApiModel.fromJson)
        .toList();
  }

  @override
  Future<CategoryApiModel?> getCategoryById(String categoryId) async {
    final response = await _apiClient.get(
      ApiEndpoints.categoryById(categoryId),
    );
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return CategoryApiModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<bool> updateCategory(CategoryApiModel category) async {
    if (category.id == null) {
      throw ArgumentError('Category id is required for update');
    }
    final response = await _apiClient.put(
      ApiEndpoints.categoryById(category.id!),
      data: category.toJson(),
    );
    return response.data['success'] == true;
  }

  @override
  Future<bool> deleteCategory(String categoryId) async {
    final response = await _apiClient.delete(
      ApiEndpoints.categoryById(categoryId),
    );
    return response.data['success'] == true;
  }
}
