import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/savedShop/data/repositories/saved_shop_repository.dart';
import 'package:bazar/features/savedShop/domain/repositories/saved_shop_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoveSavedShopParams extends Equatable {
  final String shopId;

  const RemoveSavedShopParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final removeSavedShopUsecaseProvider = Provider<RemoveSavedShopUsecase>((ref) {
  return RemoveSavedShopUsecase(
    repository: ref.read(savedShopRepositoryProvider),
  );
});

class RemoveSavedShopUsecase
    implements UsecaseWithParams<bool, RemoveSavedShopParams> {
  final ISavedShopRepository _repository;

  RemoveSavedShopUsecase({required ISavedShopRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(RemoveSavedShopParams params) {
    return _repository.removeSavedShop(params.shopId);
  }
}
