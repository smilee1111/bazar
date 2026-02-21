import 'package:bazar/features/savedShop/domain/entities/saved_shop_entity.dart';
import 'package:equatable/equatable.dart';

class SavedShopState extends Equatable {
  final bool isLoading;
  final List<SavedShopEntity> savedShops;
  final Set<String> processingShopIds;
  final String? errorMessage;

  const SavedShopState({
    this.isLoading = false,
    this.savedShops = const [],
    this.processingShopIds = const {},
    this.errorMessage,
  });

  Set<String> get savedShopIds =>
      savedShops.map((item) => item.shopId).where((id) => id.isNotEmpty).toSet();

  SavedShopState copyWith({
    bool? isLoading,
    List<SavedShopEntity>? savedShops,
    Set<String>? processingShopIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SavedShopState(
      isLoading: isLoading ?? this.isLoading,
      savedShops: savedShops ?? this.savedShops,
      processingShopIds: processingShopIds ?? this.processingShopIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, savedShops, processingShopIds, errorMessage];
}
