import 'package:equatable/equatable.dart';
import 'package:bazar/core/models/geo_point.dart';

/// Enum representing seller application status
enum SellerApplicationStatus { pending, approved, rejected }

class SellerApplicationEntity extends Equatable {
  final String? applicationId;
  final String userId;
  final String businessName;
  final String categoryName;
  final String businessPhone;
  final String businessAddress;
  final GeoPoint? location;
  final String? description;
  final String? documentUrl;
  final SellerApplicationStatus status;
  final String? adminRemark;

  const SellerApplicationEntity({
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

  @override
  List<Object?> get props => [
    applicationId,
    userId,
    businessName,
    categoryName,
    businessPhone,
    businessAddress,
    location,
    description,
    documentUrl,
    status,
    adminRemark,
  ];
}
