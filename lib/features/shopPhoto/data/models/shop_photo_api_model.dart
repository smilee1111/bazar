import 'package:bazar/features/shopPhoto/domain/entities/shop_photo_entity.dart';

class ShopPhotoApiModel {
  final String? photoId;
  final String photoName;
  final String shopId;
  final bool isActive;
  final String? photoUrl;

  ShopPhotoApiModel({
    this.photoId,
    required this.photoName,
    required this.shopId,
    this.isActive = true,
    this.photoUrl,
  });

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    if (value is Map<String, dynamic>) {
      final id = value['_id'] ?? value['id'];
      if (id is String) return id;
    }
    return null;
  }

  static bool _asBool(dynamic value, {bool fallback = true}) {
    if (value is bool) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    return fallback;
  }

  factory ShopPhotoApiModel.fromJson(Map<String, dynamic> json) {
    final parsedPhotoName = _asString(json['photoName']) ?? '';
    final parsedUrl =
        _asString(json['photoUrl'] ?? json['url'] ?? json['image']) ??
        ((parsedPhotoName.startsWith('/') ||
                parsedPhotoName.startsWith('uploads/'))
            ? parsedPhotoName
            : null);
    return ShopPhotoApiModel(
      photoId: _asString(json['_id'] ?? json['photoId']),
      photoName: parsedPhotoName,
      shopId: _asString(json['shopId']) ?? '',
      isActive: _asBool(json['isActive'], fallback: true),
      photoUrl: parsedUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photoName': photoName,
      'shopId': shopId,
      'isActive': isActive,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }

  ShopPhotoEntity toEntity() {
    return ShopPhotoEntity(
      photoId: photoId,
      photoName: photoName,
      shopId: shopId,
      isActive: isActive,
      photoUrl: photoUrl,
    );
  }

  factory ShopPhotoApiModel.fromEntity(ShopPhotoEntity entity) {
    return ShopPhotoApiModel(
      photoId: entity.photoId,
      photoName: entity.photoName,
      shopId: entity.shopId,
      isActive: entity.isActive,
      photoUrl: entity.photoUrl,
    );
  }
}
