import 'package:bazar/features/favourite/domain/usecases/add_favourite_usecase.dart';
import 'package:bazar/features/favourite/domain/usecases/get_favourites_usecase.dart';
import 'package:bazar/features/favourite/domain/usecases/remove_favourite_usecase.dart';
import 'package:bazar/features/favourite/presentation/state/favourite_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favouriteViewModelProvider =
    NotifierProvider<FavouriteViewModel, FavouriteState>(
      FavouriteViewModel.new,
    );

class FavouriteViewModel extends Notifier<FavouriteState> {
  late final GetFavouritesUsecase _getFavouritesUsecase;
  late final AddFavouriteUsecase _addFavouriteUsecase;
  late final RemoveFavouriteUsecase _removeFavouriteUsecase;

  @override
  FavouriteState build() {
    _getFavouritesUsecase = ref.read(getFavouritesUsecaseProvider);
    _addFavouriteUsecase = ref.read(addFavouriteUsecaseProvider);
    _removeFavouriteUsecase = ref.read(removeFavouriteUsecaseProvider);
    return const FavouriteState();
  }

  Future<void> loadFavourites({bool forceRefresh = false}) async {
    if (state.isLoading) return;
    if (!forceRefresh && state.favourites.isNotEmpty) return;

    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getFavouritesUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (favourites) {
        state = state.copyWith(
          isLoading: false,
          favourites: favourites,
          clearError: true,
        );
      },
    );
  }

  Future<bool> toggleFavourite({
    required String shopId,
    bool? isReviewed,
  }) async {
    final normalized = shopId.trim();
    if (normalized.isEmpty) return false;
    if (state.processingShopIds.contains(normalized)) return false;

    final processing = {...state.processingShopIds, normalized};
    state = state.copyWith(processingShopIds: processing, clearError: true);

    final isFavourite = state.favouriteShopIds.contains(normalized);
    if (isFavourite) {
      final result = await _removeFavouriteUsecase(
        RemoveFavouriteParams(shopId: normalized),
      );
      return result.fold(
        (failure) {
          final next = {...state.processingShopIds}..remove(normalized);
          state = state.copyWith(
            processingShopIds: next,
            errorMessage: failure.message,
          );
          return false;
        },
        (_) {
          final next = {...state.processingShopIds}..remove(normalized);
          final current = [...state.favourites]
            ..removeWhere((item) => item.shopId == normalized);
          state = state.copyWith(
            processingShopIds: next,
            favourites: current,
            clearError: true,
          );
          return true;
        },
      );
    }

    final result = await _addFavouriteUsecase(
      AddFavouriteParams(shopId: normalized, isReviewed: isReviewed),
    );
    return result.fold(
      (failure) {
        final next = {...state.processingShopIds}..remove(normalized);
        state = state.copyWith(
          processingShopIds: next,
          errorMessage: failure.message,
        );
        return false;
      },
      (created) {
        final normalizedCreated = (isReviewed ?? false)
            ? created.copyWith(isReviewed: true)
            : created;
        final next = {...state.processingShopIds}..remove(normalized);
        final current = [...state.favourites]
          ..removeWhere((item) => item.shopId == normalized)
          ..insert(0, normalizedCreated);
        state = state.copyWith(
          processingShopIds: next,
          favourites: current,
          clearError: true,
        );
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<bool> ensureReviewedFavourite(String shopId) async {
    final normalized = shopId.trim();
    if (normalized.isEmpty) return false;

    final existing = state.favourites
        .where((item) => item.shopId == normalized)
        .toList();
    if (existing.isNotEmpty) {
      final updated = existing.first.copyWith(isReviewed: true);
      final list = state.favourites
          .map((item) => item.shopId == normalized ? updated : item)
          .toList();
      state = state.copyWith(favourites: list, clearError: true);
      return true;
    }

    if (state.processingShopIds.contains(normalized)) return false;
    final processing = {...state.processingShopIds, normalized};
    state = state.copyWith(processingShopIds: processing, clearError: true);

    final result = await _addFavouriteUsecase(
      AddFavouriteParams(shopId: normalized, isReviewed: true),
    );

    return result.fold(
      (failure) {
        final message = failure.message.toLowerCase();
        final next = {...state.processingShopIds}..remove(normalized);
        if (message.contains('already') || message.contains('duplicate')) {
          state = state.copyWith(processingShopIds: next, clearError: true);
          loadFavourites(forceRefresh: true);
          return true;
        }
        state = state.copyWith(
          processingShopIds: next,
          errorMessage: failure.message,
        );
        return false;
      },
      (created) {
        final normalizedCreated = created.copyWith(isReviewed: true);
        final next = {...state.processingShopIds}..remove(normalized);
        final current = [...state.favourites]
          ..removeWhere((item) => item.shopId == normalized)
          ..insert(0, normalizedCreated);
        state = state.copyWith(
          processingShopIds: next,
          favourites: current,
          clearError: true,
        );
        return true;
      },
    );
  }
}
