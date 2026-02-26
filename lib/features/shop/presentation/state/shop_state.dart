import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:equatable/equatable.dart';

const _kPageSize = 15;

class ShopState extends Equatable {
  final bool isLoadingPublic;
  final bool isLoadingSeller;
  final bool isSaving;
  final bool isDeleting;
  final bool hasLoadedPublic;
  final bool hasLoadedSeller;
  final List<ShopEntity> publicShops;
  final List<ShopEntity> sellerShops;
  final ShopEntity? myShop;
  final String? errorMessage;

  // Pagination
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const ShopState({
    this.isLoadingPublic = false,
    this.isLoadingSeller = false,
    this.isSaving = false,
    this.isDeleting = false,
    this.hasLoadedPublic = false,
    this.hasLoadedSeller = false,
    this.publicShops = const [],
    this.sellerShops = const [],
    this.myShop,
    this.errorMessage,
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  ShopState copyWith({
    bool? isLoadingPublic,
    bool? isLoadingSeller,
    bool? isSaving,
    bool? isDeleting,
    bool? hasLoadedPublic,
    bool? hasLoadedSeller,
    List<ShopEntity>? publicShops,
    List<ShopEntity>? sellerShops,
    ShopEntity? myShop,
    bool clearMyShop = false,
    String? errorMessage,
    bool clearError = false,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ShopState(
      isLoadingPublic: isLoadingPublic ?? this.isLoadingPublic,
      isLoadingSeller: isLoadingSeller ?? this.isLoadingSeller,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      hasLoadedPublic: hasLoadedPublic ?? this.hasLoadedPublic,
      hasLoadedSeller: hasLoadedSeller ?? this.hasLoadedSeller,
      publicShops: publicShops ?? this.publicShops,
      sellerShops: sellerShops ?? this.sellerShops,
      myShop: clearMyShop ? null : (myShop ?? this.myShop),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingPublic,
    isLoadingSeller,
    isSaving,
    isDeleting,
    hasLoadedPublic,
    hasLoadedSeller,
    publicShops,
    sellerShops,
    myShop,
    errorMessage,
    currentPage,
    hasMore,
    isLoadingMore,
  ];
}

// ignore: constant_identifier_names
const kShopPageSize = _kPageSize;
