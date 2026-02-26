import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shop/data/repositories/shop_repository.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:bazar/features/shop/domain/repositories/shop_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getPublicFeedUsecaseProvider = Provider<GetPublicFeedUsecase>((ref) {
  return GetPublicFeedUsecase(repository: ref.read(shopRepositoryProvider));
});

class GetPublicFeedUsecase
    implements UsecaseWithParams<List<ShopEntity>, PaginationParams> {
  final IShopRepository _repository;

  GetPublicFeedUsecase({required IShopRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ShopEntity>>> call(PaginationParams params) {
    return _repository.getPublicFeed(
      page: params.page,
      limit: params.limit,
    );
  }
}
