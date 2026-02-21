import 'package:equatable/equatable.dart';

class ShopDetailEntity extends Equatable {
  final String? detailId;
  final String shopId;
  final String? link1;
  final String? link2;
  final String? link3;
  final String? link4;

  const ShopDetailEntity({
    this.detailId,
    required this.shopId,
    this.link1,
    this.link2,
    this.link3,
    this.link4,
  });

  @override
  List<Object?> get props => [detailId, shopId, link1, link2, link3, link4];
}
