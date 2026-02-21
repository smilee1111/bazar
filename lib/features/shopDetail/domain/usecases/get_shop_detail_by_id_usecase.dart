import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopDetail/data/repositories/shop_detail_repository.dart';
import 'package:bazar/features/shopDetail/domain/entities/shop_detail_entity.dart';
import 'package:bazar/features/shopDetail/domain/repositories/shop_detail_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetShopDetailByIdParams extends Equatable {
  final String shopId;
  final String detailId;
  const GetShopDetailByIdParams({required this.shopId, required this.detailId});
  @override
  List<Object?> get props => [shopId, detailId];
}

final getShopDetailByIdUsecaseProvider = Provider<GetShopDetailByIdUsecase>((
  ref,
) {
  return GetShopDetailByIdUsecase(
    repository: ref.read(shopDetailRepositoryProvider),
  );
});

class GetShopDetailByIdUsecase
    implements UsecaseWithParams<ShopDetailEntity, GetShopDetailByIdParams> {
  final IShopDetailRepository _repository;

  GetShopDetailByIdUsecase({required IShopDetailRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopDetailEntity>> call(
    GetShopDetailByIdParams params,
  ) {
    return _repository.getDetailById(params.shopId, params.detailId);
  }
}
