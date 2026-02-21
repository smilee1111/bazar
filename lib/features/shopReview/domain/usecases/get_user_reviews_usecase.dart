import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopReview/data/repositories/shop_review_repository.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:bazar/features/shopReview/domain/repositories/shop_review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserReviewsUsecaseProvider = Provider<GetUserReviewsUsecase>((ref) {
  return GetUserReviewsUsecase(
    repository: ref.read(shopReviewRepositoryProvider),
  );
});

class GetUserReviewsUsecase
    implements UsecaseWithoutParams<List<ShopReviewEntity>> {
  final IShopReviewRepository _repository;

  GetUserReviewsUsecase({required IShopReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ShopReviewEntity>>> call() {
    return _repository.getUserReviews();
  }
}
