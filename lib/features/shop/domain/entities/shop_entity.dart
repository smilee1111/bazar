import 'package:equatable/equatable.dart';

class ShopEntity extends Equatable {
  final String? shopId;
  final String? ownerId;
  final String shopName;
  final String? slug;
  final String? description;
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
    shopAddress,
    shopContact,
    contactNumber,
    email,
  ];
}
