import 'package:bazar/core/error/failure.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IShopReviewRepository {
  Future<Either<Failure, List<ShopReviewEntity>>> getReviewsByShop(
    String shopId,
  );
  Future<Either<Failure, ShopReviewEntity>> getReviewById(
    String shopId,
    String reviewId,
  );
  Future<Either<Failure, ShopReviewEntity>> createReview(
    String shopId,
    ShopReviewEntity review,
  );
  Future<Either<Failure, ShopReviewEntity>> updateReview(
    String shopId,
    String reviewId,
    ShopReviewEntity review,
  );
  Future<Either<Failure, bool>> deleteReview(String shopId, String reviewId);
  Future<Either<Failure, ShopReviewEntity>> likeReview(
    String shopId,
    String reviewId,
  );
  Future<Either<Failure, ShopReviewEntity>> unlikeReview(
    String shopId,
    String reviewId,
  );
  Future<Either<Failure, bool>> isReviewLiked(String shopId, String reviewId);
  Future<Either<Failure, ShopReviewEntity>> dislikeReview(
    String shopId,
    String reviewId,
  );
  Future<Either<Failure, ShopReviewEntity>> undislikeReview(
    String shopId,
    String reviewId,
  );
  Future<Either<Failure, bool>> isReviewDisliked(
    String shopId,
    String reviewId,
  );
  Future<Either<Failure, List<ShopReviewEntity>>> getUserReviews();
}
