import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/role/data/repositories/role_repository.dart';
import 'package:bazar/features/role/domain/entities/role_entity.dart';
import 'package:bazar/features/role/domain/repositories/role_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetRoleByIdParams extends Equatable {
  final String roleId;

  const GetRoleByIdParams({required this.roleId});

  @override
  List<Object?> get props => [roleId];
}

final getRoleByIdUseCaseProvider = Provider<GetRoleByIdUsecase>((ref) {
  return GetRoleByIdUsecase(roleRepository: ref.read(roleRepositoryProvider));
});

class GetRoleByIdUsecase
    implements UsecaseWithParams<RoleEntity, GetRoleByIdParams> {
  final IroleRepository _roleRepository;

  GetRoleByIdUsecase({required IroleRepository roleRepository})
    : _roleRepository = roleRepository;

  @override
  Future<Either<Failure, RoleEntity>> call(GetRoleByIdParams params) {
    return _roleRepository.getRoleById(params.roleId);
  }
}
