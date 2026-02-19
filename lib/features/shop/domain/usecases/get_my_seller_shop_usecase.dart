import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shop/data/repositories/shop_repository.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:bazar/features/shop/domain/repositories/shop_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMySellerShopUsecaseProvider = Provider<GetMySellerShopUsecase>((ref) {
  return GetMySellerShopUsecase(repository: ref.read(shopRepositoryProvider));
});

class GetMySellerShopUsecase implements UsecaseWithoutParams<ShopEntity?> {
  final IShopRepository _repository;

  GetMySellerShopUsecase({required IShopRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShopEntity?>> call() {
    return _repository.getMySellerShop();
  }
}
