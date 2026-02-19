import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopReview/data/repositories/shop_review_repository.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:bazar/features/shopReview/domain/repositories/shop_review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ShopReviewReaction { like, dislike }

class ReactShopReviewParams extends Equatable {
  final String reviewId;
  final ShopReviewReaction reaction;
  const ReactShopReviewParams({required this.reviewId, required this.reaction});
  @override
  List<Object?> get props => [reviewId, reaction];
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
        return _repository.likeReview(params.reviewId);
      case ShopReviewReaction.dislike:
        return _repository.dislikeReview(params.reviewId);
    }
  }
}
