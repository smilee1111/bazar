import 'package:bazar/features/shopReview/domain/entities/shop_review_entity.dart';

class ShopReviewApiModel {
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

  ShopReviewApiModel({
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

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    if (value is Map<String, dynamic>) {
      final id = value['_id'] ?? value['id'] ?? value['shopId'] ?? value['reviewId'];
      if (id is String) return id;
    }
    return null;
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static bool _asBool(dynamic value, {bool fallback = true}) {
    if (value is bool) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    return fallback;
  }

  static String? _extractUserName(dynamic value) {
    if (value is String) return null;
    if (value is Map<String, dynamic>) {
      final fullName = value['fullName'];
      if (fullName is String && fullName.trim().isNotEmpty) {
        return fullName.trim();
      }
      final username = value['username'];
      if (username is String && username.trim().isNotEmpty) {
        return username.trim();
      }
      final name = value['name'];
      if (name is String && name.trim().isNotEmpty) {
        return name.trim();
      }
    }
    return null;
  }

  static String? _extractUserRole(dynamic value) {
    if (value is! Map<String, dynamic>) return null;

    final directRole = value['roleName'];
    if (directRole is String && directRole.trim().isNotEmpty) {
      return directRole.trim();
    }

    final roleId = value['roleId'];
    if (roleId is Map<String, dynamic>) {
      final nestedRole = roleId['roleName'] ?? roleId['name'];
      if (nestedRole is String && nestedRole.trim().isNotEmpty) {
        return nestedRole.trim();
      }
    }
    return null;
  }

  static String? _extractUserProfilePic(dynamic value) {
    if (value is! Map<String, dynamic>) return null;
    final pic = value['profilePic'] ?? value['avatar'] ?? value['photo'];
    if (pic is String && pic.trim().isNotEmpty) {
      return pic.trim();
    }
    return null;
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }

  factory ShopReviewApiModel.fromJson(Map<String, dynamic> json) {
    final reviewedByRaw = json['reviewedBy'];
    return ShopReviewApiModel(
      reviewId: _asString(json['_id'] ?? json['reviewId']),
      reviewName: _asString(json['reviewName']) ?? '',
      shopId: _asString(json['shopId']) ?? '',
      reviewedBy: _asString(reviewedByRaw),
      reviewedByName:
          _extractUserName(reviewedByRaw) ??
          _asString(json['reviewedByName']) ??
          _asString(json['reviewerName']),
      reviewedByRole:
          _extractUserRole(reviewedByRaw) ??
          _asString(json['reviewedByRole']) ??
          _asString(json['reviewerRole']),
      reviewedByProfilePic:
          _extractUserProfilePic(reviewedByRaw) ??
          _asString(json['reviewedByProfilePic']) ??
          _asString(json['profilePic']),
      reviewedAt: _asDateTime(json['createdAt'] ?? json['reviewedAt']),
      starNum: _asInt(json['starNum'], fallback: 1).clamp(1, 5),
      likesCount: _asInt(json['likesCount']),
      dislikeCount: _asInt(json['dislikeCount']),
      isActive: _asBool(json['isActive'], fallback: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewName': reviewName,
      'shopId': shopId,
      'starNum': starNum,
      if (reviewedBy != null && reviewedBy!.isNotEmpty)
        'reviewedBy': reviewedBy,
      if (reviewedByName != null && reviewedByName!.isNotEmpty)
        'reviewedByName': reviewedByName,
      if (reviewedByRole != null && reviewedByRole!.isNotEmpty)
        'reviewedByRole': reviewedByRole,
      'likesCount': likesCount,
      'dislikeCount': dislikeCount,
      'isActive': isActive,
    };
  }

  ShopReviewEntity toEntity() {
    return ShopReviewEntity(
      reviewId: reviewId,
      reviewName: reviewName,
      shopId: shopId,
      reviewedBy: reviewedBy,
      reviewedByName: reviewedByName,
      reviewedByRole: reviewedByRole,
      reviewedByProfilePic: reviewedByProfilePic,
      reviewedAt: reviewedAt,
      starNum: starNum,
      likesCount: likesCount,
      dislikeCount: dislikeCount,
      isActive: isActive,
    );
  }

  factory ShopReviewApiModel.fromEntity(ShopReviewEntity entity) {
    return ShopReviewApiModel(
      reviewId: entity.reviewId,
      reviewName: entity.reviewName,
      shopId: entity.shopId,
      reviewedBy: entity.reviewedBy,
      reviewedByName: entity.reviewedByName,
      reviewedByRole: entity.reviewedByRole,
      reviewedByProfilePic: entity.reviewedByProfilePic,
      reviewedAt: entity.reviewedAt,
      starNum: entity.starNum,
      likesCount: entity.likesCount,
      dislikeCount: entity.dislikeCount,
      isActive: entity.isActive,
    );
  }
}
