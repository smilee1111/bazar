import 'package:bazar/features/shop/domain/entities/shop_entity.dart';

class ShopApiModel {
  final String? shopId;
  final String? ownerId;
  final String shopName;
  final String? slug;
  final String? description;
  final List<String> categoryNames;
  final String? priceRange;
  final String shopAddress;
  final String shopContact;
  final String? contactNumber;
  final String? email;

  ShopApiModel({
    this.shopId,
    this.ownerId,
    required this.shopName,
    this.slug,
    this.description,
    this.categoryNames = const [],
    this.priceRange,
    required this.shopAddress,
    required this.shopContact,
    this.contactNumber,
    this.email,
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

  static List<String> _asStringList(dynamic value) {
    if (value == null) return const [];
    if (value is String) {
      final text = value.trim();
      return text.isEmpty ? const [] : [text];
    }
    if (value is List) {
      return value
          .map((item) {
            if (item is String) return item.trim();
            if (item is Map<String, dynamic>) {
              return _asString(
                    item['categoryName'] ??
                        item['name'] ??
                        item['title'] ??
                        item['_id'],
                  ) ??
                  '';
            }
            return _asString(item) ?? '';
          })
          .where((item) => item.isNotEmpty)
          .toSet()
          .toList();
    }
    if (value is Map<String, dynamic>) {
      final single =
          _asString(value['categoryName'] ?? value['name'] ?? value['title']);
      return single == null || single.isEmpty ? const [] : [single];
    }
    return const [];
  }

  factory ShopApiModel.fromJson(Map<String, dynamic> json) {
    String requiredString(dynamic value) => _asString(value) ?? '';
    final parsedCategories = _asStringList(
      json['categoryNames'] ??
          json['categories'] ??
          json['category'] ??
          json['categoryName'] ??
          json['categoryId'] ??
          json['categoryIds'] ??
          json['selectedCategory'] ??
          json['selectedCategories'] ??
          json['businessCategory'] ??
          json['shopCategory'] ??
          json['shopCategories'] ??
          json['tags'],
    );

    return ShopApiModel(
      shopId: _asString(json['_id'] ?? json['shopId']),
      ownerId: _asString(json['ownerId']),
      shopName: requiredString(json['shopName']),
      slug: _asString(json['slug']),
      description: _asString(json['description']),
      categoryNames: parsedCategories,
      priceRange: _asString(json['priceRange'] ?? json['priceTag'] ?? json['price']),
      shopAddress: requiredString(json['shopAddress']),
      shopContact: requiredString(json['shopContact']),
      contactNumber: _asString(json['contactNumber']),
      email: _asString(json['email']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (shopId != null) 'shopId': shopId,
      'ownerId': ownerId,
      'shopName': shopName,
      if (slug != null && slug!.isNotEmpty) 'slug': slug,
      if (description != null && description!.isNotEmpty)
        'description': description,
      if (categoryNames.isNotEmpty) 'categoryNames': categoryNames,
      if (priceRange != null && priceRange!.isNotEmpty) 'priceRange': priceRange,
      'shopAddress': shopAddress,
      'shopContact': shopContact,
      if (contactNumber != null && contactNumber!.isNotEmpty)
        'contactNumber': contactNumber,
      if (email != null && email!.isNotEmpty) 'email': email,
    };
  }

  ShopEntity toEntity() {
    return ShopEntity(
      shopId: shopId,
      ownerId: ownerId,
      shopName: shopName,
      slug: slug,
      description: description,
      categoryNames: categoryNames,
      priceRange: priceRange,
      shopAddress: shopAddress,
      shopContact: shopContact,
      contactNumber: contactNumber,
      email: email,
    );
  }

  factory ShopApiModel.fromEntity(ShopEntity entity) {
    return ShopApiModel(
      shopId: entity.shopId,
      ownerId: entity.ownerId,
      shopName: entity.shopName,
      slug: entity.slug,
      description: entity.description,
      categoryNames: entity.categoryNames,
      priceRange: entity.priceRange,
      shopAddress: entity.shopAddress,
      shopContact: entity.shopContact,
      contactNumber: entity.contactNumber,
      email: entity.email,
    );
  }

  static List<ShopEntity> toEntityList(List<ShopApiModel> models) {
    return models.map((item) => item.toEntity()).toList();
  }
}
