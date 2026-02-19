import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopReview/data/repositories/shop_review_repository.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:bazar/features/shopReview/domain/repositories/shop_review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ShopReviewReaction { like, unlike, dislike, undislike }

class ReactShopReviewParams extends Equatable {
  final String shopId;
  final String reviewId;
  final ShopReviewReaction reaction;
  const ReactShopReviewParams({
    required this.shopId,
    required this.reviewId,
    required this.reaction,
  });
  @override
  List<Object?> get props => [shopId, reviewId, reaction];
}

final reactShopReviewUsecaseProvider = Provider<ReactShopReviewUsecase>((ref) {
  return ReactShopReviewUsecase(
    repository: ref.read(shopReviewRepositoryProvider),
  );
});

class ReactShopReviewUsecase
    implements UsecaseWithParams<ShopReviewEntity, ReactShopReviewParams> {
  final IShopReviewRepository _repository;

  ReactShopReviewUsecase({required IShopReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopReviewEntity>> call(ReactShopReviewParams params) {
    switch (params.reaction) {
      case ShopReviewReaction.like:
        return _repository.likeReview(params.shopId, params.reviewId);
      case ShopReviewReaction.unlike:
        return _repository.unlikeReview(params.shopId, params.reviewId);
      case ShopReviewReaction.dislike:
        return _repository.dislikeReview(params.shopId, params.reviewId);
      case ShopReviewReaction.undislike:
        return _repository.undislikeReview(params.shopId, params.reviewId);
    }
  }
}
