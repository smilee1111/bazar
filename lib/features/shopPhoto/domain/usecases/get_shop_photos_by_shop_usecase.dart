import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopPhoto/data/repositories/shop_photo_repository.dart';
import 'package:bazar/features/shopPhoto/domain/entities/shop_photo_entity.dart';
import 'package:bazar/features/shopPhoto/domain/repositories/shop_photo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetShopPhotosByShopParams extends Equatable {
  final String shopId;
  const GetShopPhotosByShopParams({required this.shopId});
  @override
  List<Object?> get props => [shopId];
}

final getShopPhotosByShopUsecaseProvider = Provider<GetShopPhotosByShopUsecase>(
  (ref) {
    return GetShopPhotosByShopUsecase(
      repository: ref.read(shopPhotoRepositoryProvider),
    );
  },
);

class GetShopPhotosByShopUsecase
    implements
        UsecaseWithParams<List<ShopPhotoEntity>, GetShopPhotosByShopParams> {
  final IShopPhotoRepository _repository;

  GetShopPhotosByShopUsecase({required IShopPhotoRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ShopPhotoEntity>>> call(
    GetShopPhotosByShopParams params,
  ) {
    return _repository.getPhotosByShop(params.shopId);
  }
}
