import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/category/data/repositories/category_repository.dart';
import 'package:bazar/features/category/domain/entities/category_entity.dart';
import 'package:bazar/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCategoryParams extends Equatable{
  final String categoryId;
  final String categoryName;
  final String? status;

  const UpdateCategoryParams({
    required this.categoryId,
    required this.categoryName,
    this.status,
  });
  
  @override
  List<Object?> get props => [categoryId,categoryName,status];
}


final updateCategoryUseCaseProvider = Provider<UpdateCategoryUsecase>((ref){
  return UpdateCategoryUsecase(categoryRepository: ref.read(categoryRepositoryProvider));
});

class UpdateCategoryUsecase 
implements UsecaseWithParams<bool, UpdateCategoryParams>{
  final IcategoryRepository _categoryRepository;

  UpdateCategoryUsecase({required IcategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;
  
  @override
  Future<Either<Failure, bool>> call(UpdateCategoryParams params) {
   CategoryEntity categoryEntity = CategoryEntity(
    categoryId: params.categoryId,
    categoryName: params.categoryName
    );

    return _categoryRepository.updateCategory(categoryEntity);
  }
  
}