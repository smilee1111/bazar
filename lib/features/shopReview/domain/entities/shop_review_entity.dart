import 'package:equatable/equatable.dart';

class ShopReviewEntity extends Equatable {
  final String? reviewId;
  final String reviewName;
  final String shopId;
  final String? reviewedBy;
  final String? reviewedByName;
  final String? reviewedByRole;
  final String? reviewedByProfilePic;
  final DateTime? reviewedAt;
  final int starNum;
  final int likesCount;
  final int dislikeCount;
  final bool isActive;

  const ShopReviewEntity({
    this.reviewId,
    required this.reviewName,
    required this.shopId,
    this.reviewedBy,
    this.reviewedByName,
    this.reviewedByRole,
    this.reviewedByProfilePic,
    this.reviewedAt,
    required this.starNum,
    this.likesCount = 0,
    this.dislikeCount = 0,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    reviewId,
    reviewName,
    shopId,
    reviewedBy,
    reviewedByName,
    reviewedByRole,
    reviewedByProfilePic,
    reviewedAt,
    starNum,
    likesCount,
    dislikeCount,
    isActive,
  ];
}
