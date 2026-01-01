import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/role/data/repositories/role_repository.dart';
import 'package:bazar/features/role/domain/entities/role_entity.dart';
import 'package:bazar/features/role/domain/repositories/role_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRoleUsecaseParams extends Equatable{
  final String roleName;

  CreateRoleUsecaseParams({required this.roleName});
  
  @override
  List<Object?> get props => [roleName];

  
}

final createRoleUseCaseProvider = Provider<CreateRoleUsecase>((ref){
  return CreateRoleUsecase(roleRepository: ref.read(roleRepositoryProvider));
});

class CreateRoleUsecase 
implements UseCaseWithParams<bool, CreateRoleUsecaseParams>{
final IroleRepository _roleRepository;

CreateRoleUsecase({required IroleRepository roleRepository}) : _roleRepository = roleRepository;
  @override
  Future<Either<Failure, bool>> call(CreateRoleUsecaseParams params) {
    //create role entity here
    RoleEntity roleEntity = RoleEntity(roleName: params.roleName);
    return _roleRepository.createRole(roleEntity  );
  }

}