import 'package:bazar/features/role/domain/entities/role_entity.dart';
import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable{
  final String? authId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String username;
  final String? password;
  final String? profilePic;
  final String? roleId;
  final RoleEntity? role; 

  //constructor
  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.username,
    this.password,
    this.profilePic,
    this.roleId,
    this.role,
  });
  
  @override
  List<Object?> get props => [
    authId,
    fullName,
    email,
    phoneNumber,
    username,
    password,
    profilePic,
    roleId,
    role,
  ];


}