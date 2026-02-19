import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shop/data/repositories/shop_repository.dart';
import 'package:bazar/features/shop/domain/repositories/shop_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteShopParams extends Equatable {
  final String shopId;

  const DeleteShopParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final deleteShopUsecaseProvider = Provider<DeleteShopUsecase>((ref) {
  return DeleteShopUsecase(repository: ref.read(shopRepositoryProvider));
});

class DeleteShopUsecase implements UsecaseWithParams<bool, DeleteShopParams> {
  final IShopRepository _repository;

  DeleteShopUsecase({required IShopRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(DeleteShopParams params) {
    return _repository.deleteShop(params.shopId);
  }
}
