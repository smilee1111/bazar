// create provider
import 'package:bazar/core/services/hive/category_hive_service.dart';
import 'package:bazar/core/services/hive/hive_service.dart';
import 'package:bazar/features/category/data/datasources/category_datasource.dart';
import 'package:bazar/features/category/data/models/category_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryLocalDatasourceProvider = Provider<CategoryLocalDatasource>((ref) {
  final categoryHiveService = ref.read(categoryHiveServiceProvider);
  return CategoryLocalDatasource(categoryHiveService: categoryHiveService);
});

class CategoryLocalDatasource implements ICategoryLocalDataSource{

  final CategoryHiveService _categoryHiveService;

    CategoryLocalDatasource({required CategoryHiveService categoryHiveService})
    : _categoryHiveService = categoryHiveService;
  
  @override
  Future<bool> createCategory(CategoryHiveModel category) async {
    try {
      await _categoryHiveService.createCategory(category);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCategory(String categoryId) async {
      try {
      await _categoryHiveService.deleteCategory(categoryId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<CategoryHiveModel>> getAllCategories() async{
        try {
      return _categoryHiveService.getAllCategories();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<CategoryHiveModel?> getCategoryById(String categoryId) async{
       try {
      return _categoryHiveService.getCategoryById(categoryId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateCategory(CategoryHiveModel category) async {
    try {
      await _categoryHiveService.updateCategory(category);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  }