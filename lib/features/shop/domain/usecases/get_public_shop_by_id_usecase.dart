import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shop/data/repositories/shop_repository.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:bazar/features/shop/domain/repositories/shop_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetPublicShopByIdParams extends Equatable {
  final String shopId;

  const GetPublicShopByIdParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final getPublicShopByIdUsecaseProvider = Provider<GetPublicShopByIdUsecase>((
  ref,
) {
  return GetPublicShopByIdUsecase(repository: ref.read(shopRepositoryProvider));
});

class GetPublicShopByIdUsecase
    implements UsecaseWithParams<ShopEntity, GetPublicShopByIdParams> {
  final IShopRepository _repository;

  GetPublicShopByIdUsecase({required IShopRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopEntity>> call(GetPublicShopByIdParams params) {
    return _repository.getPublicShopById(params.shopId);
  }
}
