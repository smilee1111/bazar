import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/services/connectivity/network_info.dart';
import 'package:bazar/features/category/data/datasources/category_datasource.dart';
import 'package:bazar/features/category/data/datasources/local/category_local_datasource.dart';
import 'package:bazar/features/category/data/datasources/remote/category_remote_datasource.dart';
import 'package:bazar/features/category/data/models/category_api_model.dart';
import 'package:bazar/features/category/data/models/category_hive_model.dart';
import 'package:bazar/features/category/domain/entities/category_entity.dart';
import 'package:bazar/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepositoryProvider = Provider<IcategoryRepository>((ref) {
  final categoryLocalDatasource = ref.read(categoryLocalDatasourceProvider);
  final categoryRemoteDatasource = ref.read(categoryRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return CategoryRepository(
    categoryLocalDatasource: categoryLocalDatasource,
    categoryRemoteDatasource: categoryRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class CategoryRepository implements IcategoryRepository {
  final ICategoryLocalDataSource _categoryLocalDataSource;
  final ICategoryRemoteDataSource _categoryRemoteDataSource;
  final NetworkInfo _networkInfo;

  CategoryRepository({
    required ICategoryLocalDataSource categoryLocalDatasource,
    required ICategoryRemoteDataSource categoryRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _categoryLocalDataSource = categoryLocalDatasource,
       _categoryRemoteDataSource = categoryRemoteDatasource,
       _networkInfo = networkInfo;

  String _extractErrorMessage(Object? data, String fallback) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    if (data is String && data.isNotEmpty) {
      return data;
    }
    return fallback;
  }

  @override
  Future<Either<Failure, bool>> createCategory(CategoryEntity category) async {
    try {
      // conversion
      // entity lai model ma convert gara
      final categoryModel = CategoryHiveModel.fromEntity(category);
      final result = await _categoryLocalDataSource.createCategory(
        categoryModel,
      );
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to create a category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory(String categoryId) async {
    try {
      final result = await _categoryLocalDataSource.deleteCategory(categoryId);
      if (result) {
        return Right(true);
      }

      return Left(LocalDatabaseFailure(message: ' Failed to delete category'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategorys() async {
    //check for internet first
    if (await _networkInfo.isConnected) {
      try {
        //api model capture
        final apiModels = await _categoryRemoteDataSource.getAllCategories();
        //convert to entity
        final result = CategoryApiModel.toEntityList(apiModels);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: _extractErrorMessage(
              e.response?.data,
              'Failed to fetch categories',
            ),
          ),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _categoryLocalDataSource.getAllCategories();
        final entities = CategoryHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
    String categoryId,
  ) async {
    try {
      final model = await _categoryLocalDataSource.getCategoryById(categoryId);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message: 'Category not found'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateCategory(CategoryEntity category) async {
    try {
      final categoryModel = CategoryHiveModel.fromEntity(category);
      final result = await _categoryLocalDataSource.updateCategory(
        categoryModel,
      );
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to update category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
