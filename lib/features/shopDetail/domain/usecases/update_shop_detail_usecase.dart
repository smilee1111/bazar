import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopDetail/data/repositories/shop_detail_repository.dart';
import 'package:bazar/features/shopDetail/domain/entities/shop_detail_entity.dart';
import 'package:bazar/features/shopDetail/domain/repositories/shop_detail_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateShopDetailParams extends Equatable {
  final String shopId;
  final String detailId;
  final ShopDetailEntity detail;
  const UpdateShopDetailParams({
    required this.shopId,
    required this.detailId,
    required this.detail,
  });
  @override
  List<Object?> get props => [shopId, detailId, detail];
}

final updateShopDetailUsecaseProvider = Provider<UpdateShopDetailUsecase>((
  ref,
) {
  return UpdateShopDetailUsecase(
    repository: ref.read(shopDetailRepositoryProvider),
  );
});

class UpdateShopDetailUsecase
    implements UsecaseWithParams<ShopDetailEntity, UpdateShopDetailParams> {
  final IShopDetailRepository _repository;

  UpdateShopDetailUsecase({required IShopDetailRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopDetailEntity>> call(
    UpdateShopDetailParams params,
  ) {
    return _repository.updateDetail(
      params.shopId,
      params.detailId,
      params.detail,
    );
  }
}
