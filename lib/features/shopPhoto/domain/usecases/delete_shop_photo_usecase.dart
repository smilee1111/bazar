import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/shopPhoto/data/repositories/shop_photo_repository.dart';
import 'package:bazar/features/shopPhoto/domain/repositories/shop_photo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteShopPhotoParams extends Equatable {
  final String shopId;
  final String photoId;
  const DeleteShopPhotoParams({required this.shopId, required this.photoId});
  @override
  List<Object?> get props => [shopId, photoId];
}

final deleteShopPhotoUsecaseProvider = Provider<DeleteShopPhotoUsecase>((ref) {
  return DeleteShopPhotoUsecase(
    repository: ref.read(shopPhotoRepositoryProvider),
  );
});

class DeleteShopPhotoUsecase
    implements UsecaseWithParams<bool, DeleteShopPhotoParams> {
  final IShopPhotoRepository _repository;

  DeleteShopPhotoUsecase({required IShopPhotoRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(DeleteShopPhotoParams params) {
    return _repository.deletePhoto(params.shopId, params.photoId);
  }
}
