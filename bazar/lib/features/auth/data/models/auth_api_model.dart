import 'package:bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:bazar/features/role/data/models/role_api_model.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String username;
  final String? password;
  final String? roleId;
  final RoleApiModel? role;

  AuthApiModel({
    this.id, 
    required this.fullName, 
    required this.email, 
    required this.username, 
    this.password, 
    this.roleId,
    this.role,
    });

    //toJson
    Map<String, dynamic> toJson(){
      return{
      "name" : fullName,
      "email" :email,
      "username": username,
      "password": password,
      "roleId" : roleId,
      };
    }

    //fromJson
    factory AuthApiModel.fromJson(Map<String, dynamic> json){
      return AuthApiModel(
        id: json['_id'] as String,
        fullName: json['name'] as String,
        email: json['email'] as String,
        username: json['username'] as String,
        roleId: json['roleId'] as String?,
        role: json['role'] != null
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
        username: username,
        roleId: roleId,
        role: role?.toEntity(),
      );
    }

    //From Entity
    factory AuthApiModel.fromEnity(AuthEntity entity){
      return AuthApiModel(
        id: entity.authId,
        fullName: entity.fullName,
        email: entity.email,
        username: entity.username,
        password: entity.password,
        roleId: entity.roleId,
        role: entity.role != null
          ? RoleApiModel.fromEntity(entity.role!)
          : null,
      );
    }
}