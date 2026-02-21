import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/favourite/data/repositories/favourite_repository.dart';
import 'package:bazar/features/favourite/domain/entities/favourite_entity.dart';
import 'package:bazar/features/favourite/domain/repositories/favourite_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFavouriteParams extends Equatable {
  final String shopId;
  final bool? isReviewed;

  const AddFavouriteParams({required this.shopId, this.isReviewed});

  @override
  List<Object?> get props => [shopId, isReviewed];
}

final addFavouriteUsecaseProvider = Provider<AddFavouriteUsecase>((ref) {
  return AddFavouriteUsecase(repository: ref.read(favouriteRepositoryProvider));
});

class AddFavouriteUsecase
    implements UsecaseWithParams<FavouriteEntity, AddFavouriteParams> {
  final IFavouriteRepository _repository;

  AddFavouriteUsecase({required IFavouriteRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, FavouriteEntity>> call(AddFavouriteParams params) {
    return _repository.addFavourite(
      shopId: params.shopId,
      isReviewed: params.isReviewed,
    );
  }
}
