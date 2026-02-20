import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/favourite/data/repositories/favourite_repository.dart';
import 'package:bazar/features/favourite/domain/repositories/favourite_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoveFavouriteParams extends Equatable {
  final String shopId;

  const RemoveFavouriteParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final removeFavouriteUsecaseProvider = Provider<RemoveFavouriteUsecase>((ref) {
  return RemoveFavouriteUsecase(
    repository: ref.read(favouriteRepositoryProvider),
  );
});

class RemoveFavouriteUsecase
    implements UsecaseWithParams<bool, RemoveFavouriteParams> {
  final IFavouriteRepository _repository;

  RemoveFavouriteUsecase({required IFavouriteRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(RemoveFavouriteParams params) {
    return _repository.removeFavourite(params.shopId);
  }
}
