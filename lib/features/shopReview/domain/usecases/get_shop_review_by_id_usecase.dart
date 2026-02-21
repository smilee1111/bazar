import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopReview/data/repositories/shop_review_repository.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:bazar/features/shopReview/domain/repositories/shop_review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetShopReviewByIdParams extends Equatable {
  final String shopId;
  final String reviewId;
  const GetShopReviewByIdParams({required this.shopId, required this.reviewId});
  @override
  List<Object?> get props => [shopId, reviewId];
}

final getShopReviewByIdUsecaseProvider = Provider<GetShopReviewByIdUsecase>((
  ref,
) {
  return GetShopReviewByIdUsecase(
    repository: ref.read(shopReviewRepositoryProvider),
  );
});

class GetShopReviewByIdUsecase
    implements UsecaseWithParams<ShopReviewEntity, GetShopReviewByIdParams> {
  final IShopReviewRepository _repository;

  GetShopReviewByIdUsecase({required IShopReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopReviewEntity>> call(
    GetShopReviewByIdParams params,
  ) {
    return _repository.getReviewById(params.shopId, params.reviewId);
  }
}
