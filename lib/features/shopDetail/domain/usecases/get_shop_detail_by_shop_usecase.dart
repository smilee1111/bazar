import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopDetail/data/repositories/shop_detail_repository.dart';
import 'package:bazar/features/shopDetail/domain/entities/shop_detail_entity.dart';
import 'package:bazar/features/shopDetail/domain/repositories/shop_detail_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetShopDetailByShopParams extends Equatable {
  final String shopId;
  const GetShopDetailByShopParams({required this.shopId});
  @override
  List<Object?> get props => [shopId];
}

final getShopDetailByShopUsecaseProvider = Provider<GetShopDetailByShopUsecase>(
  (ref) {
    return GetShopDetailByShopUsecase(
      repository: ref.read(shopDetailRepositoryProvider),
    );
  },
);

class GetShopDetailByShopUsecase
    implements UsecaseWithParams<ShopDetailEntity?, GetShopDetailByShopParams> {
  final IShopDetailRepository _repository;

  GetShopDetailByShopUsecase({required IShopDetailRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopDetailEntity?>> call(
    GetShopDetailByShopParams params,
  ) {
    return _repository.getDetailByShop(params.shopId);
  }
}
