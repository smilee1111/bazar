import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopDetail/data/repositories/shop_detail_repository.dart';
import 'package:bazar/features/shopDetail/domain/repositories/shop_detail_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteShopDetailParams extends Equatable {
  final String shopId;
  final String detailId;
  const DeleteShopDetailParams({required this.shopId, required this.detailId});
  @override
  List<Object?> get props => [shopId, detailId];
}

final deleteShopDetailUsecaseProvider = Provider<DeleteShopDetailUsecase>((
  ref,
) {
  return DeleteShopDetailUsecase(
    repository: ref.read(shopDetailRepositoryProvider),
  );
});

class DeleteShopDetailUsecase
    implements UsecaseWithParams<bool, DeleteShopDetailParams> {
  final IShopDetailRepository _repository;

  DeleteShopDetailUsecase({required IShopDetailRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(DeleteShopDetailParams params) {
    return _repository.deleteDetail(params.shopId, params.detailId);
  }
}
