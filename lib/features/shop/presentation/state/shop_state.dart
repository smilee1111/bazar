import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:equatable/equatable.dart';

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
  ];
}
