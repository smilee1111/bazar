import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shop/data/repositories/shop_repository.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:bazar/features/shop/domain/repositories/shop_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateShopParams extends Equatable {
  final ShopEntity shop;

  const UpdateShopParams({required this.shop});

  @override
  List<Object?> get props => [shop];
}

final updateShopUsecaseProvider = Provider<UpdateShopUsecase>((ref) {
  return UpdateShopUsecase(repository: ref.read(shopRepositoryProvider));
});

class UpdateShopUsecase
    implements UsecaseWithParams<ShopEntity, UpdateShopParams> {
  final IShopRepository _repository;

  UpdateShopUsecase({required IShopRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopEntity>> call(UpdateShopParams params) {
    return _repository.updateShop(params.shop);
  }
}
