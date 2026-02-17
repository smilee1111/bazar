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
    Map<String, dynamic> toJson({String? confirmPassword}){
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
      String? parsedRoleId;
      RoleApiModel? parsedRole;

      final dynamic roleField = json['roleId'];
      if (roleField != null) {
        if (roleField is String) {
          parsedRoleId = roleField;
        } else if (roleField is Map) {
          final Map<String, dynamic> roleMap = Map<String, dynamic>.from(roleField);
          parsedRoleId = (roleMap['roleId'] ?? roleMap['_id'])?.toString();
          try {
            parsedRole = RoleApiModel.fromJson(roleMap);
          } catch (_) {
            parsedRole = null;
          }
        }
      }

      // If there's a separate `role` field, prefer that for role details if not already parsed
      if (parsedRole == null && json['role'] != null && json['role'] is Map) {
        try {
          parsedRole = RoleApiModel.fromJson(Map<String, dynamic>.from(json['role'] as Map));
          parsedRoleId ??= (json['role']['roleId'] ?? json['role']['_id'])?.toString();
        } catch (_) {
          // ignore parse errors
        }
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
        roleId: parsedRoleId,
        role: parsedRole,
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