import 'package:bazar/features/favourite/domain/entities/favourite_entity.dart';
import 'package:equatable/equatable.dart';

class FavouriteState extends Equatable {
  final bool isLoading;
  final List<FavouriteEntity> favourites;
  final Set<String> processingShopIds;
  final String? errorMessage;

  const FavouriteState({
    this.isLoading = false,
    this.favourites = const [],
    this.processingShopIds = const {},
    this.errorMessage,
  });

  Set<String> get favouriteShopIds =>
      favourites.map((item) => item.shopId).where((id) => id.isNotEmpty).toSet();

  Set<String> get reviewedShopIds => favourites
      .where((item) => item.isReviewed)
      .map((item) => item.shopId)
      .where((id) => id.isNotEmpty)
      .toSet();

  FavouriteState copyWith({
    bool? isLoading,
    List<FavouriteEntity>? favourites,
    Set<String>? processingShopIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavouriteState(
      isLoading: isLoading ?? this.isLoading,
      favourites: favourites ?? this.favourites,
      processingShopIds: processingShopIds ?? this.processingShopIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, favourites, processingShopIds, errorMessage];
}
