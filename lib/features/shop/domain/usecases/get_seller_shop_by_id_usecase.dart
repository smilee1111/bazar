import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shop/data/repositories/shop_repository.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:bazar/features/shop/domain/repositories/shop_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetSellerShopByIdParams extends Equatable {
  final String shopId;

  const GetSellerShopByIdParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final getSellerShopByIdUsecaseProvider = Provider<GetSellerShopByIdUsecase>((
  ref,
) {
  return GetSellerShopByIdUsecase(repository: ref.read(shopRepositoryProvider));
});

class GetSellerShopByIdUsecase
    implements UsecaseWithParams<ShopEntity, GetSellerShopByIdParams> {
  final IShopRepository _repository;

  GetSellerShopByIdUsecase({required IShopRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopEntity>> call(GetSellerShopByIdParams params) {
    return _repository.getSellerShopById(params.shopId);
  }
}
