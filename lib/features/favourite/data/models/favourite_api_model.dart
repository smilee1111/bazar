import 'package:bazar/features/favourite/domain/entities/favourite_entity.dart';

class FavouriteApiModel {
  final String? favouriteId;
  final String shopId;
  final String? userId;
  final bool isReviewed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FavouriteApiModel({
    this.favouriteId,
    required this.shopId,
    this.userId,
    this.isReviewed = false,
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

  static bool _asBool(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is String) {
      final normalized = value.toLowerCase();
      if (normalized == 'true') return true;
      if (normalized == 'false') return false;
    }
    return fallback;
  }

  static DateTime? _asDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  factory FavouriteApiModel.fromJson(Map<String, dynamic> json) {
    return FavouriteApiModel(
      favouriteId: _asString(json['_id'] ?? json['favouriteId']),
      shopId: _asString(json['shopId']) ?? '',
      userId: _asString(json['userId']),
      isReviewed: _asBool(json['isReviewed'], fallback: false),
      createdAt: _asDate(json['createdAt']),
      updatedAt: _asDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'isReviewed': isReviewed,
    };
  }

  FavouriteEntity toEntity() {
    return FavouriteEntity(
      favouriteId: favouriteId,
      shopId: shopId,
      userId: userId,
      isReviewed: isReviewed,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory FavouriteApiModel.fromEntity(FavouriteEntity entity) {
    return FavouriteApiModel(
      favouriteId: entity.favouriteId,
      shopId: entity.shopId,
      userId: entity.userId,
      isReviewed: entity.isReviewed,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
