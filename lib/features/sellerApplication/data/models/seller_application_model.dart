import 'package:bazar/features/sellerApplication/domain/entities/seller_application_entity.dart';
import 'package:bazar/core/models/geo_point.dart';

/// API Model to handle JSON <-> Entity conversion
class SellerApplicationApiModel {
  final String? applicationId;
  final String userId;
  final String businessName;
  final String categoryName;
  final String businessPhone;
  final String businessAddress;
  final GeoPoint? location;
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
    this.location,
    this.description,
    this.documentUrl,
    required this.status,
    this.adminRemark,
  });

  // from JSON
  factory SellerApplicationApiModel.fromJson(Map<String, dynamic> json) {
    String? asString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is num || value is bool) return value.toString();
      if (value is Map<String, dynamic>) {
        final id = value['_id'] ?? value['id'];
        if (id is String) return id;
        return null;
      }
      return null;
    }

    String requiredString(dynamic value, {String fallback = ''}) {
      return asString(value) ?? fallback;
    }

    final resolvedStatus = requiredString(
      json['status'],
      fallback: 'pending',
    ).toLowerCase();

    return SellerApplicationApiModel(
      applicationId: asString(json['_id']),
      userId: requiredString(json['userId']),
      businessName: requiredString(json['businessName']),
      categoryName: requiredString(json['categoryName']),
      businessPhone: requiredString(json['businessPhone']),
      businessAddress: requiredString(json['businessAddress']),
      location: _parseLocation(json['location']),
      description: asString(json['description']),
      documentUrl: asString(json['documentUrl']),
      status: resolvedStatus.isEmpty ? 'pending' : resolvedStatus,
      adminRemark: asString(json['adminRemark']),
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
      if (location != null) "location": location!.toGeoJson(),
      if (description != null) "description": description,
      if (documentUrl != null) "documentUrl": documentUrl,
    };
  }

  static GeoPoint? _parseLocation(dynamic value) {
    if (value is! Map<String, dynamic>) return null;
    try {
      return GeoPoint.fromGeoJson(value);
    } catch (_) {
      return null;
    }
  }

  // Convert to Entity
  SellerApplicationEntity toEntity() {
    SellerApplicationStatus parsedStatus;
    switch (status) {
      case 'approved':
        parsedStatus = SellerApplicationStatus.approved;
        break;
      case 'rejected':
        parsedStatus = SellerApplicationStatus.rejected;
        break;
      default:
        parsedStatus = SellerApplicationStatus.pending;
    }

    return SellerApplicationEntity(
      applicationId: applicationId,
      userId: userId,
      businessName: businessName,
      categoryName: categoryName,
      businessPhone: businessPhone,
      businessAddress: businessAddress,
      location: location,
      description: description,
      documentUrl: documentUrl,
      status: parsedStatus,
      adminRemark: adminRemark,
    );
  }

  // Create API Model from Entity
  factory SellerApplicationApiModel.fromEntity(SellerApplicationEntity entity) {
    String statusValue;
    switch (entity.status) {
      case SellerApplicationStatus.approved:
        statusValue = 'approved';
        break;
      case SellerApplicationStatus.rejected:
        statusValue = 'rejected';
        break;
      default:
        statusValue = 'pending';
    }

    return SellerApplicationApiModel(
      userId: entity.userId,
      businessName: entity.businessName,
      categoryName: entity.categoryName,
      businessPhone: entity.businessPhone,
      businessAddress: entity.businessAddress,
      location: entity.location,
      description: entity.description,
      documentUrl: entity.documentUrl,
      status: statusValue,
      adminRemark: entity.adminRemark,
    );
  }
}
