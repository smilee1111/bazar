import 'package:bazar/core/error/failure.dart';
import 'package:bazar/features/category/domain/entities/category_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IcategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getAllCategorys();
  Future<Either<Failure, CategoryEntity>> getCategoryById(String roleId);
  Future<Either<Failure, bool>> createCategory(CategoryEntity role);
  Future<Either<Failure, bool>> updateCategory(CategoryEntity role);
  Future<Either<Failure, bool>> deleteCategory(String categoryId);


}