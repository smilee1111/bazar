import 'dart:io';

import 'package:bazar/core/error/failure.dart';
import 'package:bazar/features/shopPhoto/domain/entities/shop_photo_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IShopPhotoRepository {
  Future<Either<Failure, List<ShopPhotoEntity>>> getPhotosByShop(String shopId);
  Future<Either<Failure, ShopPhotoEntity>> getPhotoById(
    String shopId,
    String photoId,
  );
  Future<Either<Failure, ShopPhotoEntity>> createPhoto(
    String shopId,
    File image,
  );
  Future<Either<Failure, ShopPhotoEntity>> updatePhoto(
    String shopId,
    String photoId,
    File image,
  );
  Future<Either<Failure, bool>> deletePhoto(String shopId, String photoId);
}
