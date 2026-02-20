import 'package:bazar/core/error/failure.dart';
import 'package:bazar/features/favourite/domain/entities/favourite_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IFavouriteRepository {
  Future<Either<Failure, List<FavouriteEntity>>> getFavourites();
  Future<Either<Failure, FavouriteEntity>> addFavourite({
    required String shopId,
    bool? isReviewed,
  });
  Future<Either<Failure, bool>> removeFavourite(String shopId);
}
