import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:bazar/features/shop/domain/usecases/create_shop_usecase.dart';
import 'package:bazar/features/shop/domain/usecases/delete_shop_usecase.dart';
import 'package:bazar/features/shop/domain/usecases/get_my_seller_shop_usecase.dart';
import 'package:bazar/features/shop/domain/usecases/get_public_feed_usecase.dart';
import 'package:bazar/features/shop/domain/usecases/update_shop_usecase.dart';
import 'package:bazar/features/shop/presentation/state/shop_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopViewModelProvider = NotifierProvider<ShopViewModel, ShopState>(
  ShopViewModel.new,
);

class ShopViewModel extends Notifier<ShopState> {
  late final GetPublicFeedUsecase _getPublicFeedUsecase;
  late final GetMySellerShopUsecase _getMySellerShopUsecase;
  late final CreateShopUsecase _createShopUsecase;
  late final UpdateShopUsecase _updateShopUsecase;
  late final DeleteShopUsecase _deleteShopUsecase;

  @override
  ShopState build() {
    _getPublicFeedUsecase = ref.read(getPublicFeedUsecaseProvider);
    _getMySellerShopUsecase = ref.read(getMySellerShopUsecaseProvider);
    _createShopUsecase = ref.read(createShopUsecaseProvider);
    _updateShopUsecase = ref.read(updateShopUsecaseProvider);
    _deleteShopUsecase = ref.read(deleteShopUsecaseProvider);
    return const ShopState();
  }

  Future<void> loadPublicShops({bool forceRefresh = false}) async {
    if (state.isLoadingPublic) return;
    if (!forceRefresh && state.hasLoadedPublic) return;

    state = state.copyWith(isLoadingPublic: true, clearError: true);
    final result = await _getPublicFeedUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingPublic: false,
          hasLoadedPublic: true,
          errorMessage: failure.message,
        );
      },
      (shops) {
        state = state.copyWith(
          isLoadingPublic: false,
          hasLoadedPublic: true,
          publicShops: shops,
          clearError: true,
        );
      },
    );
  }

  Future<void> loadSellerShops({bool forceRefresh = false}) async {
    if (state.isLoadingSeller) return;
    if (!forceRefresh && state.hasLoadedSeller) return;

    state = state.copyWith(isLoadingSeller: true, clearError: true);

    final myShopResult = await _getMySellerShopUsecase();
    final myShop = myShopResult.fold<ShopEntity?>((_) => null, (shop) => shop);
    final error = myShopResult.fold<String?>((f) => f.message, (_) => null);
    final sellerShops = myShop == null
        ? const <ShopEntity>[]
        : <ShopEntity>[myShop];

    state = state.copyWith(
      isLoadingSeller: false,
      hasLoadedSeller: true,
      myShop: myShop,
      sellerShops: sellerShops,
      errorMessage: error,
      clearError: error == null,
    );
  }

  Future<bool> createShop(ShopEntity shop) async {
    if (state.isSaving) return false;
    state = state.copyWith(isSaving: true, clearError: true);

    final result = await _createShopUsecase(CreateShopParams(shop: shop));
    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, errorMessage: failure.message);
        return false;
      },
      (_) async {
        state = state.copyWith(isSaving: false, clearError: true);
        await loadSellerShops(forceRefresh: true);
        await loadPublicShops(forceRefresh: true);
        return true;
      },
    );
  }

  Future<bool> updateShop(ShopEntity shop) async {
    if (state.isSaving) return false;
    state = state.copyWith(isSaving: true, clearError: true);

    final result = await _updateShopUsecase(UpdateShopParams(shop: shop));
    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, errorMessage: failure.message);
        return false;
      },
      (_) async {
        state = state.copyWith(isSaving: false, clearError: true);
        await loadSellerShops(forceRefresh: true);
        await loadPublicShops(forceRefresh: true);
        return true;
      },
    );
  }

  Future<bool> deleteShop(String shopId) async {
    if (state.isDeleting) return false;
    state = state.copyWith(isDeleting: true, clearError: true);

    final result = await _deleteShopUsecase(DeleteShopParams(shopId: shopId));
    return result.fold(
      (failure) {
        state = state.copyWith(
          isDeleting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) async {
        state = state.copyWith(isDeleting: false, clearError: true);
        await loadSellerShops(forceRefresh: true);
        await loadPublicShops(forceRefresh: true);
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
