import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopReview/data/repositories/shop_review_repository.dart';
import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';
import 'package:bazar/features/shopReview/domain/repositories/shop_review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetShopReviewsByShopParams extends Equatable {
  final String shopId;
  const GetShopReviewsByShopParams({required this.shopId});
  @override
  List<Object?> get props => [shopId];
}

final getShopReviewsByShopUsecaseProvider =
    Provider<GetShopReviewsByShopUsecase>((ref) {
      return GetShopReviewsByShopUsecase(
        repository: ref.read(shopReviewRepositoryProvider),
      );
    });

class GetShopReviewsByShopUsecase
    implements
        UsecaseWithParams<List<ShopReviewEntity>, GetShopReviewsByShopParams> {
  final IShopReviewRepository _repository;

  GetShopReviewsByShopUsecase({required IShopReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ShopReviewEntity>>> call(
    GetShopReviewsByShopParams params,
  ) {
    return _repository.getReviewsByShop(params.shopId);
  }
}
