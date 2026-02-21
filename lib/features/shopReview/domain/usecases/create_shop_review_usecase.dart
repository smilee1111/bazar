import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopReview/data/repositories/shop_review_repository.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:bazar/features/shopReview/domain/repositories/shop_review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateShopReviewParams extends Equatable {
  final String shopId;
  final ShopReviewEntity review;
  const CreateShopReviewParams({required this.shopId, required this.review});
  @override
  List<Object?> get props => [shopId, review];
}

final createShopReviewUsecaseProvider = Provider<CreateShopReviewUsecase>((
  ref,
) {
  return CreateShopReviewUsecase(
    repository: ref.read(shopReviewRepositoryProvider),
  );
});

class CreateShopReviewUsecase
    implements UsecaseWithParams<ShopReviewEntity, CreateShopReviewParams> {
  final IShopReviewRepository _repository;

  CreateShopReviewUsecase({required IShopReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopReviewEntity>> call(
    CreateShopReviewParams params,
  ) {
    return _repository.createReview(params.shopId, params.review);
  }
}
