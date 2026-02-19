import 'package:bazar/core/error/failure.dart';
import 'package:bazar/features/shopDetail/domain/entities/shop_detail_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IShopDetailRepository {
  Future<Either<Failure, ShopDetailEntity?>> getDetailByShop(String shopId);
  Future<Either<Failure, ShopDetailEntity>> getDetailById(
    String shopId,
    String detailId,
  );
  Future<Either<Failure, ShopDetailEntity>> createDetail(
    String shopId,
    ShopDetailEntity detail,
  );
  Future<Either<Failure, ShopDetailEntity>> updateDetail(
    String shopId,
    String detailId,
    ShopDetailEntity detail,
  );
  Future<Either<Failure, bool>> deleteDetail(String shopId, String detailId);
}
