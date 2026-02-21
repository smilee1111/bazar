import 'package:bazar/features/shopDetail/domain/entities/shop_detail_entity.dart';

class ShopDetailApiModel {
  final String? detailId;
  final String shopId;
  final String? link1;
  final String? link2;
  final String? link3;
  final String? link4;

  ShopDetailApiModel({
    this.detailId,
    required this.shopId,
    this.link1,
    this.link2,
    this.link3,
    this.link4,
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

  factory ShopDetailApiModel.fromJson(Map<String, dynamic> json) {
    return ShopDetailApiModel(
      detailId: _asString(json['_id'] ?? json['detailId']),
      shopId: _asString(json['shopId']) ?? '',
      link1: _asString(json['link1']),
      link2: _asString(json['link2']),
      link3: _asString(json['link3']),
      link4: _asString(json['link4']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      if (link1 != null) 'link1': link1,
      if (link2 != null) 'link2': link2,
      if (link3 != null) 'link3': link3,
      if (link4 != null) 'link4': link4,
    };
  }

  ShopDetailEntity toEntity() {
    return ShopDetailEntity(
      detailId: detailId,
      shopId: shopId,
      link1: link1,
      link2: link2,
      link3: link3,
      link4: link4,
    );
  }

  factory ShopDetailApiModel.fromEntity(ShopDetailEntity entity) {
    return ShopDetailApiModel(
      detailId: entity.detailId,
      shopId: entity.shopId,
      link1: entity.link1,
      link2: entity.link2,
      link3: entity.link3,
      link4: entity.link4,
    );
  }
}
