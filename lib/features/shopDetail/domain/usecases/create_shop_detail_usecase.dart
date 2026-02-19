import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopDetail/data/repositories/shop_detail_repository.dart';
import 'package:bazar/features/shopDetail/domain/entities/shop_detail_entity.dart';
import 'package:bazar/features/shopDetail/domain/repositories/shop_detail_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateShopDetailParams extends Equatable {
  final String shopId;
  final ShopDetailEntity detail;
  const CreateShopDetailParams({required this.shopId, required this.detail});
  @override
  List<Object?> get props => [shopId, detail];
}

final createShopDetailUsecaseProvider = Provider<CreateShopDetailUsecase>((
  ref,
) {
  return CreateShopDetailUsecase(
    repository: ref.read(shopDetailRepositoryProvider),
  );
});

class CreateShopDetailUsecase
    implements UsecaseWithParams<ShopDetailEntity, CreateShopDetailParams> {
  final IShopDetailRepository _repository;

  CreateShopDetailUsecase({required IShopDetailRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopDetailEntity>> call(
    CreateShopDetailParams params,
  ) {
    return _repository.createDetail(params.shopId, params.detail);
  }
}
