import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/category/data/repositories/category_repository.dart';
import 'package:bazar/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteCategoryParams extends Equatable {
  final String categoryId;

  const DeleteCategoryParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

final deleteCategoryUseCaseProvider = Provider<DeleteCategoryUsecase>((ref) {
  return DeleteCategoryUsecase(
    categoryRepository: ref.read(categoryRepositoryProvider),
  );
});

class DeleteCategoryUsecase
    implements UsecaseWithParams<bool, DeleteCategoryParams> {
  final IcategoryRepository _categoryRepository;

  DeleteCategoryUsecase({required IcategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteCategoryParams params) {
    return _categoryRepository.deleteCategory(params.categoryId);
  }
}
