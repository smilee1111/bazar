import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/savedShop/data/repositories/saved_shop_repository.dart';
import 'package:bazar/features/savedShop/domain/entities/saved_shop_entity.dart';
import 'package:bazar/features/savedShop/domain/repositories/saved_shop_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveShopParams extends Equatable {
  final String shopId;

  const SaveShopParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final saveShopUsecaseProvider = Provider<SaveShopUsecase>((ref) {
  return SaveShopUsecase(repository: ref.read(savedShopRepositoryProvider));
});

class SaveShopUsecase
    implements UsecaseWithParams<SavedShopEntity, SaveShopParams> {
  final ISavedShopRepository _repository;

  SaveShopUsecase({required ISavedShopRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, SavedShopEntity>> call(SaveShopParams params) {
    return _repository.saveShop(params.shopId);
  }
}
