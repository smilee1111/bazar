import 'package:equatable/equatable.dart';

class ShopEntity extends Equatable {
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

  const ShopEntity({
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

  @override
  List<Object?> get props => [
    shopId,
    ownerId,
    shopName,
    slug,
    description,
    categoryNames,
    priceRange,
    shopAddress,
    shopContact,
    contactNumber,
    email,
  ];
}
