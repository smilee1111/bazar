import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/savedShop/data/repositories/saved_shop_repository.dart';
import 'package:bazar/features/savedShop/domain/entities/saved_shop_entity.dart';
import 'package:bazar/features/savedShop/domain/repositories/saved_shop_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getSavedShopsUsecaseProvider = Provider<GetSavedShopsUsecase>((ref) {
  return GetSavedShopsUsecase(repository: ref.read(savedShopRepositoryProvider));
});

class GetSavedShopsUsecase
    implements UsecaseWithoutParams<List<SavedShopEntity>> {
  final ISavedShopRepository _repository;

  GetSavedShopsUsecase({required ISavedShopRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<SavedShopEntity>>> call() {
    return _repository.getSavedShops();
  }
}
