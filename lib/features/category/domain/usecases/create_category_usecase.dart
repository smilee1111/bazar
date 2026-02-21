import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/category/data/repositories/category_repository.dart';
import 'package:bazar/features/category/domain/entities/category_entity.dart';
import 'package:bazar/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCategoryParams extends Equatable {
  final String categoryName;

  const CreateCategoryParams({required this.categoryName});

  @override
  List<Object?> get props => [categoryName];
}

//Usecase

// Create Provider
final createCategoryUsecaseProvider = Provider<CreateCategoryUsecase>((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return CreateCategoryUsecase(categoryRepository: categoryRepository);
});

class CreateCategoryUsecase implements UsecaseWithParams<bool, CreateCategoryParams> {
  final IcategoryRepository _categoryRepository;

  CreateCategoryUsecase({required IcategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, bool>> call(CreateCategoryParams params) {
    // object creation
    CategoryEntity categoryEntity = CategoryEntity(categoryName: params.categoryName);

    return _categoryRepository.createCategory(categoryEntity);
  }
}