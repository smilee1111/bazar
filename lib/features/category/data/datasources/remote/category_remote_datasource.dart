
import 'package:bazar/core/api/api_client.dart';
import 'package:bazar/core/api/api_endpoints.dart';
import 'package:bazar/features/category/data/datasources/category_datasource.dart';
import 'package:bazar/features/category/data/models/category_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRemoteProvider = Provider<ICategoryRemoteDataSource>((ref){
  return CategoryRemoteDatasource(apiClient: ref.read(apiClientProvider));
});
class CategoryRemoteDatasource implements ICategoryRemoteDataSource{

  
  final ApiClient _apiClient;

  CategoryRemoteDatasource({
    required ApiClient apiClient
  }): _apiClient = apiClient;
  
  @override
  Future<bool> createCategory(CategoryApiModel category) async{
    final response = await _apiClient.get(ApiEndpoints.categories);
    return response.data['success'] == true;
  }

  @override
  Future<List<CategoryApiModel>> getAllCategories() async{
    final response = await _apiClient.get(ApiEndpoints.categories);
    final data = response.data['data'] as  List;
    return data.map((json) => CategoryApiModel.fromJson(json)).toList();
  }

  @override
  Future<CategoryApiModel?> getCategoryById(String categoryId) async{
    final response = await _apiClient.get(ApiEndpoints.categoryById(categoryId));
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return CategoryApiModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<bool> updateCategory(CategoryApiModel category) async{
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
  Future<bool> deleteCategory(String categoryId) async{
    final response = await _apiClient.delete(ApiEndpoints.categoryById(categoryId));
    return response.data['success'] == true;
  }

}
