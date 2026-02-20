import 'package:equatable/equatable.dart';

class FavouriteEntity extends Equatable {
  final String? favouriteId;
  final String shopId;
  final String? userId;
  final bool isReviewed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FavouriteEntity({
    this.favouriteId,
    required this.shopId,
    this.userId,
    this.isReviewed = false,
    this.createdAt,
    this.updatedAt,
  });

  FavouriteEntity copyWith({
    String? favouriteId,
    String? shopId,
    String? userId,
    bool? isReviewed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FavouriteEntity(
      favouriteId: favouriteId ?? this.favouriteId,
      shopId: shopId ?? this.shopId,
      userId: userId ?? this.userId,
      isReviewed: isReviewed ?? this.isReviewed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    favouriteId,
    shopId,
    userId,
    isReviewed,
    createdAt,
    updatedAt,
  ];
}
