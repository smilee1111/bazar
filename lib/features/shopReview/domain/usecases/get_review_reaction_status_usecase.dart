import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopReview/data/repositories/shop_review_repository.dart';
import 'package:bazar/features/shopReview/domain/repositories/shop_review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetReviewReactionStatusParams extends Equatable {
  final String shopId;
  final String reviewId;

  const GetReviewReactionStatusParams({
    required this.shopId,
    required this.reviewId,
  });

  @override
  List<Object?> get props => [shopId, reviewId];
}

final getReviewLikedStatusUsecaseProvider = Provider<GetReviewLikedStatusUsecase>(
  (ref) => GetReviewLikedStatusUsecase(
    repository: ref.read(shopReviewRepositoryProvider),
  ),
);

final getReviewDislikedStatusUsecaseProvider =
    Provider<GetReviewDislikedStatusUsecase>(
      (ref) => GetReviewDislikedStatusUsecase(
        repository: ref.read(shopReviewRepositoryProvider),
      ),
    );

class GetReviewLikedStatusUsecase
    implements UsecaseWithParams<bool, GetReviewReactionStatusParams> {
  final IShopReviewRepository _repository;

  GetReviewLikedStatusUsecase({required IShopReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(GetReviewReactionStatusParams params) {
    return _repository.isReviewLiked(params.shopId, params.reviewId);
  }
}

class GetReviewDislikedStatusUsecase
    implements UsecaseWithParams<bool, GetReviewReactionStatusParams> {
  final IShopReviewRepository _repository;

  GetReviewDislikedStatusUsecase({required IShopReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(GetReviewReactionStatusParams params) {
    return _repository.isReviewDisliked(params.shopId, params.reviewId);
  }
}
