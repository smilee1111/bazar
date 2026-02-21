import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/category/data/repositories/category_repository.dart';
import 'package:bazar/features/category/domain/entities/category_entity.dart';
import 'package:bazar/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllCategoryUseCaseProvider = Provider<GetAllCategoryUsecase>((ref){
  return GetAllCategoryUsecase(categoryRepository: ref.read(categoryRepositoryProvider));
});

class GetAllCategoryUsecase  implements UsecaseWithoutParams<List<CategoryEntity>>{
  final IcategoryRepository _categoryRepository;

  GetAllCategoryUsecase({required IcategoryRepository categoryRepository})
  :_categoryRepository = categoryRepository;


  @override
  Future<Either<Failure, List<CategoryEntity>>> call() {
   return _categoryRepository.getAllCategorys();
  }

}