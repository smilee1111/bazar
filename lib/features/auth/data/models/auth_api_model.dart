import 'package:bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:bazar/features/role/data/models/role_api_model.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String username;
  final String? password;
  final String? profilePic;
  final String? roleId;
  final RoleApiModel? role;

  AuthApiModel({
    this.id, 
    required this.fullName, 
    required this.email, 
    this.phoneNumber,
    required this.username, 
    this.password, 
    this.profilePic,
    this.roleId,
    this.role,
    });

    //toJson - for registration
    Map<String, dynamic> toJson({String? roleName, String? confirmPassword}){
      final Map<String, dynamic> data = {
        "fullName": fullName,
        "email": email,
        "username": username,
        "password": password,
        "profilePic": profilePic,
        "phoneNumber": phoneNumber != null && phoneNumber!.isNotEmpty 
            ? int.tryParse(phoneNumber!) ?? 0 
            : 0,
      };
      
      // Add role name if provided (for registration)
      if (roleName != null) {
        data["role"] = roleName;
      }
      
      // Add confirmPassword if provided (for registration)
      if (confirmPassword != null) {
        data["confirmPassword"] = confirmPassword;
      }
      
      // Add roleId if present (for internal use)
      if (roleId != null) {
        data["roleId"] = roleId;
      }
      
      return data;
    }

    //fromJson
    factory AuthApiModel.fromJson(Map<String, dynamic> json){
      // Handle roleId - can be either a String or a populated object
      String? extractRoleId(dynamic roleIdValue) {
        if (roleIdValue == null) return null;
        if (roleIdValue is String) return roleIdValue;
        if (roleIdValue is Map) {
          // Backend populated roleId, extract the actual ID
          final roleMap = Map<String, dynamic>.from(roleIdValue);
          return roleMap['_id'] as String? ?? roleMap['roleId'] as String?;
        }
        return roleIdValue.toString();
      }

      return AuthApiModel(
        id: json['_id'] as String?,
        fullName: json['fullName'] as String? ?? json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phoneNumber: json['phoneNumber'] != null 
            ? json['phoneNumber'].toString() 
            : null,
        username: json['username'] as String? ?? '',
        profilePic: json['profilePic'] as String?,
        roleId: extractRoleId(json['roleId']),
        role: json['role'] != null && json['role'] is Map
          ? RoleApiModel.fromJson(json['role'] as Map<String, dynamic>)
          : null,
          );
    }

    //toEntity
    AuthEntity toEntity(){
      return AuthEntity(
        authId: id,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        username: username,
        profilePic: profilePic,
        roleId: roleId,
        role: role?.toEntity(),
      );
    }

    //From Entity
    factory AuthApiModel.fromEntity(AuthEntity entity){
      return AuthApiModel(
        id: entity.authId,
        fullName: entity.fullName,
        email: entity.email,
        phoneNumber: entity.phoneNumber,
        username: entity.username,
        password: entity.password,
        profilePic: entity.profilePic,
        roleId: entity.roleId,
        role: entity.role != null
          ? RoleApiModel.fromEntity(entity.role!)
          : null,
      );
    }
}