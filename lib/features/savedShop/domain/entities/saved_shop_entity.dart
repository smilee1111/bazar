import 'package:equatable/equatable.dart';

class SavedShopEntity extends Equatable {
  final String? savedShopId;
  final String shopId;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SavedShopEntity({
    this.savedShopId,
    required this.shopId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [savedShopId, shopId, userId, createdAt, updatedAt];
}
