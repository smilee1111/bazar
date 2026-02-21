import 'package:bazar/core/error/failure.dart';
import 'package:bazar/features/savedShop/domain/entities/saved_shop_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ISavedShopRepository {
  Future<Either<Failure, List<SavedShopEntity>>> getSavedShops();
  Future<Either<Failure, SavedShopEntity>> saveShop(String shopId);
  Future<Either<Failure, bool>> removeSavedShop(String shopId);
}
