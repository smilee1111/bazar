import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shop/data/repositories/shop_repository.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:bazar/features/shop/domain/repositories/shop_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateShopParams extends Equatable {
  final ShopEntity shop;

  const CreateShopParams({required this.shop});

  @override
  List<Object?> get props => [shop];
}

final createShopUsecaseProvider = Provider<CreateShopUsecase>((ref) {
  return CreateShopUsecase(repository: ref.read(shopRepositoryProvider));
});

class CreateShopUsecase
    implements UsecaseWithParams<ShopEntity, CreateShopParams> {
  final IShopRepository _repository;

  CreateShopUsecase({required IShopRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopEntity>> call(CreateShopParams params) {
    return _repository.createShop(params.shop);
  }
}
