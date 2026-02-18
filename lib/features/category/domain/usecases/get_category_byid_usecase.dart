import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/category/data/repositories/category_repository.dart';
import 'package:bazar/features/category/domain/entities/category_entity.dart';
import 'package:bazar/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetCategoryByIdParams extends Equatable {
  final String categoryId;

  const GetCategoryByIdParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

final getCategoryByIdUseCaseProvider = Provider<GetCategoryByIdUsecase>((ref) {
  return GetCategoryByIdUsecase(
    categoryRepository: ref.read(categoryRepositoryProvider),
  );
});

class GetCategoryByIdUsecase
    implements UsecaseWithParams<CategoryEntity, GetCategoryByIdParams> {
  final IcategoryRepository _categoryRepository;

  GetCategoryByIdUsecase({required IcategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, CategoryEntity>> call(GetCategoryByIdParams params) {
    return _categoryRepository.getCategoryById(params.categoryId);
  }
}
