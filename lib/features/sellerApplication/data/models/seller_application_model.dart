import 'package:bazar/features/sellerApplication/domain/entities/seller_application_entity.dart';

/// API Model to handle JSON <-> Entity conversion
class SellerApplicationApiModel {
  final String? applicationId;
  final String userId;
  final String businessName;
  final String categoryName;
  final String businessPhone;
  final String businessAddress;
  final String? description;
  final String? documentUrl;
  final String status;
  final String? adminRemark;

  SellerApplicationApiModel({
    this.applicationId,
    required this.userId,
    required this.businessName,
    required this.categoryName,
    required this.businessPhone,
    required this.businessAddress,
    this.description,
    this.documentUrl,
    required this.status,
    this.adminRemark,
  });

  // from JSON
  factory SellerApplicationApiModel.fromJson(Map<String, dynamic> json) {
    return SellerApplicationApiModel(
      applicationId: json['_id'] as String?,
      userId: json['userId'] as String,
      businessName: json['businessName'] as String,
      categoryName: json['categoryName'] as String,
      businessPhone: json['businessPhone'] as String,
      businessAddress: json['businessAddress'] as String,
      description: json['description'] as String?,
      documentUrl: json['documentUrl'] as String?,
      status: json['status'] as String,
      adminRemark: json['adminRemark'] as String?,
    );
  }

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "businessName": businessName,
      "categoryName": categoryName,
      "businessPhone": businessPhone,
      "businessAddress": businessAddress,
      if (description != null) "description": description,
      if (documentUrl != null) "documentUrl": documentUrl,
    };
  }

  // Convert to Entity
  SellerApplicationEntity toEntity() {
    SellerApplicationStatus _status;
    switch (status) {
      case 'approved':
        _status = SellerApplicationStatus.approved;
        break;
      case 'rejected':
        _status = SellerApplicationStatus.rejected;
        break;
      default:
        _status = SellerApplicationStatus.pending;
    }

    return SellerApplicationEntity(
      applicationId: applicationId,
      userId: userId,
      businessName: businessName,
      categoryName: categoryName,
      businessPhone: businessPhone,
      businessAddress: businessAddress,
      description: description,
      documentUrl: documentUrl,
      status: _status,
      adminRemark: adminRemark,
    );
  }

  // Create API Model from Entity
  factory SellerApplicationApiModel.fromEntity(SellerApplicationEntity entity) {
    String _status;
    switch (entity.status) {
      case SellerApplicationStatus.approved:
        _status = 'approved';
        break;
      case SellerApplicationStatus.rejected:
        _status = 'rejected';
        break;
      default:
        _status = 'pending';
    }

    return SellerApplicationApiModel(
      userId: entity.userId,
      businessName: entity.businessName,
      categoryName: entity.categoryName,
      businessPhone: entity.businessPhone,
      businessAddress: entity.businessAddress,
      description: entity.description,
      documentUrl: entity.documentUrl,
      status: _status,
      adminRemark: entity.adminRemark,
    );
  }
}
