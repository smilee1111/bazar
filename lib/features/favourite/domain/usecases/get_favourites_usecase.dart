import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/favourite/data/repositories/favourite_repository.dart';
import 'package:bazar/features/favourite/domain/entities/favourite_entity.dart';
import 'package:bazar/features/favourite/domain/repositories/favourite_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getFavouritesUsecaseProvider = Provider<GetFavouritesUsecase>((ref) {
  return GetFavouritesUsecase(repository: ref.read(favouriteRepositoryProvider));
});

class GetFavouritesUsecase
    implements UsecaseWithoutParams<List<FavouriteEntity>> {
  final IFavouriteRepository _repository;

  GetFavouritesUsecase({required IFavouriteRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<FavouriteEntity>>> call() {
    return _repository.getFavourites();
  }
}
