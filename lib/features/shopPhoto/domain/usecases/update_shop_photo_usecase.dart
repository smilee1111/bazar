import 'dart:io';

import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopPhoto/data/repositories/shop_photo_repository.dart';
import 'package:bazar/features/shopPhoto/domain/entities/shop_photo_entity.dart';
import 'package:bazar/features/shopPhoto/domain/repositories/shop_photo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateShopPhotoParams extends Equatable {
  final String shopId;
  final String photoId;
  final File image;
  const UpdateShopPhotoParams({
    required this.shopId,
    required this.photoId,
    required this.image,
  });
  @override
  List<Object?> get props => [shopId, photoId, image.path];
}

final updateShopPhotoUsecaseProvider = Provider<UpdateShopPhotoUsecase>((ref) {
  return UpdateShopPhotoUsecase(
    repository: ref.read(shopPhotoRepositoryProvider),
  );
});

class UpdateShopPhotoUsecase
    implements UsecaseWithParams<ShopPhotoEntity, UpdateShopPhotoParams> {
  final IShopPhotoRepository _repository;

  UpdateShopPhotoUsecase({required IShopPhotoRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopPhotoEntity>> call(UpdateShopPhotoParams params) {
    return _repository.updatePhoto(params.shopId, params.photoId, params.image);
  }
}
