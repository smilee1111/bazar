import 'package:bazar/features/savedShop/domain/entities/saved_shop_entity.dart';

class SavedShopApiModel {
  final String? savedShopId;
  final String shopId;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SavedShopApiModel({
    this.savedShopId,
    required this.shopId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    if (value is Map<String, dynamic>) {
      final id = value['_id'] ?? value['id'] ?? value['userId'];
      if (id is String) return id;
    }
    return null;
  }

  static DateTime? _asDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  factory SavedShopApiModel.fromJson(Map<String, dynamic> json) {
    return SavedShopApiModel(
      savedShopId: _asString(json['_id'] ?? json['savedShopId']),
      shopId: _asString(json['shopId']) ?? '',
      userId: _asString(json['userId']),
      createdAt: _asDate(json['createdAt']),
      updatedAt: _asDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'shopId': shopId};
  }

  SavedShopEntity toEntity() {
    return SavedShopEntity(
      savedShopId: savedShopId,
      shopId: shopId,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory SavedShopApiModel.fromEntity(SavedShopEntity entity) {
    return SavedShopApiModel(
      savedShopId: entity.savedShopId,
      shopId: entity.shopId,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
