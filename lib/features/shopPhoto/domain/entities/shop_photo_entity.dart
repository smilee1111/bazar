import 'package:equatable/equatable.dart';

class ShopPhotoEntity extends Equatable {
  final String? photoId;
  final String photoName;
  final String shopId;
  final bool isActive;
  final String? photoUrl;

  const ShopPhotoEntity({
    this.photoId,
    required this.photoName,
    required this.shopId,
    this.isActive = true,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [photoId, photoName, shopId, isActive, photoUrl];
}
