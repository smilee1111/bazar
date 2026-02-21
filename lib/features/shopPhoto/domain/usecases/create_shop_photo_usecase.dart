import 'dart:io';

import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopPhoto/data/repositories/shop_photo_repository.dart';
import 'package:bazar/features/shopPhoto/domain/entities/shop_photo_entity.dart';
import 'package:bazar/features/shopPhoto/domain/repositories/shop_photo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateShopPhotoParams extends Equatable {
  final String shopId;
  final File image;
  const CreateShopPhotoParams({required this.shopId, required this.image});
  @override
  List<Object?> get props => [shopId, image.path];
}

final createShopPhotoUsecaseProvider = Provider<CreateShopPhotoUsecase>((ref) {
  return CreateShopPhotoUsecase(
    repository: ref.read(shopPhotoRepositoryProvider),
  );
});

class CreateShopPhotoUsecase
    implements UsecaseWithParams<ShopPhotoEntity, CreateShopPhotoParams> {
  final IShopPhotoRepository _repository;

  CreateShopPhotoUsecase({required IShopPhotoRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopPhotoEntity>> call(CreateShopPhotoParams params) {
    return _repository.createPhoto(params.shopId, params.image);
  }
}
