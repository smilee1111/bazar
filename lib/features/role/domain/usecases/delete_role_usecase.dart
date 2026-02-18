import 'package:bazar/core/error/failure.dart';
import 'package:bazar/core/usecases/app_usecase.dart';
import 'package:bazar/features/role/data/repositories/role_repository.dart';
import 'package:bazar/features/role/domain/repositories/role_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteRoleParams extends Equatable {
  final String roleId;

  const DeleteRoleParams({required this.roleId});

  @override
  List<Object?> get props => [roleId];
}

final deleteRoleUseCaseProvider = Provider<DeleteRoleUsecase>((ref) {
  return DeleteRoleUsecase(roleRepository: ref.read(roleRepositoryProvider));
});

class DeleteRoleUsecase implements UsecaseWithParams<bool, DeleteRoleParams> {
  final IroleRepository _roleRepository;

  DeleteRoleUsecase({required IroleRepository roleRepository})
    : _roleRepository = roleRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteRoleParams params) {
    return _roleRepository.deleteRole(params.roleId);
  }
}
