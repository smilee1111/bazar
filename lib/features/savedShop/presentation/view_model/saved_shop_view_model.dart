import 'package:bazar/features/savedShop/domain/usecases/get_saved_shops_usecase.dart';
import 'package:bazar/features/savedShop/domain/usecases/remove_saved_shop_usecase.dart';
import 'package:bazar/features/savedShop/domain/usecases/save_shop_usecase.dart';
import 'package:bazar/features/savedShop/presentation/state/saved_shop_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedShopViewModelProvider =
    NotifierProvider<SavedShopViewModel, SavedShopState>(SavedShopViewModel.new);

class SavedShopViewModel extends Notifier<SavedShopState> {
  late final GetSavedShopsUsecase _getSavedShopsUsecase;
  late final SaveShopUsecase _saveShopUsecase;
  late final RemoveSavedShopUsecase _removeSavedShopUsecase;

  @override
  SavedShopState build() {
    _getSavedShopsUsecase = ref.read(getSavedShopsUsecaseProvider);
    _saveShopUsecase = ref.read(saveShopUsecaseProvider);
    _removeSavedShopUsecase = ref.read(removeSavedShopUsecaseProvider);
    return const SavedShopState();
  }

  Future<void> loadSavedShops({bool forceRefresh = false}) async {
    if (state.isLoading) return;
    if (!forceRefresh && state.savedShops.isNotEmpty) return;

    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getSavedShopsUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (savedShops) {
        state = state.copyWith(
          isLoading: false,
          savedShops: savedShops,
          clearError: true,
        );
      },
    );
  }

  Future<bool> toggleSaved(String shopId) async {
    final normalized = shopId.trim();
    if (normalized.isEmpty) return false;
    if (state.processingShopIds.contains(normalized)) return false;

    final processing = {...state.processingShopIds, normalized};
    state = state.copyWith(processingShopIds: processing, clearError: true);

    final isSaved = state.savedShopIds.contains(normalized);
    if (isSaved) {
      final result = await _removeSavedShopUsecase(
        RemoveSavedShopParams(shopId: normalized),
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
          final current = [...state.savedShops]
            ..removeWhere((item) => item.shopId == normalized);
          state = state.copyWith(
            processingShopIds: next,
            savedShops: current,
            clearError: true,
          );
          return true;
        },
      );
    }

    final result = await _saveShopUsecase(SaveShopParams(shopId: normalized));
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
        final next = {...state.processingShopIds}..remove(normalized);
        final current = [...state.savedShops]
          ..removeWhere((item) => item.shopId == normalized)
          ..insert(0, created);
        state = state.copyWith(
          processingShopIds: next,
          savedShops: current,
          clearError: true,
        );
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
