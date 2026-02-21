import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopReview/data/repositories/shop_review_repository.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:bazar/features/shopReview/domain/repositories/shop_review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateShopReviewParams extends Equatable {
  final String shopId;
  final String reviewId;
  final ShopReviewEntity review;
  const UpdateShopReviewParams({
    required this.shopId,
    required this.reviewId,
    required this.review,
  });
  @override
  List<Object?> get props => [shopId, reviewId, review];
}

final updateShopReviewUsecaseProvider = Provider<UpdateShopReviewUsecase>((
  ref,
) {
  return UpdateShopReviewUsecase(
    repository: ref.read(shopReviewRepositoryProvider),
  );
});

class UpdateShopReviewUsecase
    implements UsecaseWithParams<ShopReviewEntity, UpdateShopReviewParams> {
  final IShopReviewRepository _repository;

  UpdateShopReviewUsecase({required IShopReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopReviewEntity>> call(
    UpdateShopReviewParams params,
  ) {
    return _repository.updateReview(
      params.shopId,
      params.reviewId,
      params.review,
    );
  }
}
