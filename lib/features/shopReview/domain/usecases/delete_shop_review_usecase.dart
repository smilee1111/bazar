import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopReview/data/repositories/shop_review_repository.dart';
import 'package:bazar/features/shopReview/domain/repositories/shop_review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteShopReviewParams extends Equatable {
  final String shopId;
  final String reviewId;
  const DeleteShopReviewParams({required this.shopId, required this.reviewId});
  @override
  List<Object?> get props => [shopId, reviewId];
}

final deleteShopReviewUsecaseProvider = Provider<DeleteShopReviewUsecase>((
  ref,
) {
  return DeleteShopReviewUsecase(
    repository: ref.read(shopReviewRepositoryProvider),
  );
});

class DeleteShopReviewUsecase
    implements UsecaseWithParams<bool, DeleteShopReviewParams> {
  final IShopReviewRepository _repository;

  DeleteShopReviewUsecase({required IShopReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(DeleteShopReviewParams params) {
    return _repository.deleteReview(params.shopId, params.reviewId);
  }
}
