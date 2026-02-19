import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopPhoto/data/repositories/shop_photo_repository.dart';
import 'package:bazar/features/shopPhoto/domain/entities/shop_photo_entity.dart';
import 'package:bazar/features/shopPhoto/domain/repositories/shop_photo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetShopPhotoByIdParams extends Equatable {
  final String shopId;
  final String photoId;
  const GetShopPhotoByIdParams({required this.shopId, required this.photoId});
  @override
  List<Object?> get props => [shopId, photoId];
}

final getShopPhotoByIdUsecaseProvider = Provider<GetShopPhotoByIdUsecase>((
  ref,
) {
  return GetShopPhotoByIdUsecase(
    repository: ref.read(shopPhotoRepositoryProvider),
  );
});

class GetShopPhotoByIdUsecase
    implements UsecaseWithParams<ShopPhotoEntity, GetShopPhotoByIdParams> {
  final IShopPhotoRepository _repository;

  GetShopPhotoByIdUsecase({required IShopPhotoRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopPhotoEntity>> call(GetShopPhotoByIdParams params) {
    return _repository.getPhotoById(params.shopId, params.photoId);
  }
}
