import 'package:bazar/core/error/failure.dart';
import 'package:bazar/features/auth/data/datasources/auth_datasource.dart';
import 'package:bazar/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:bazar/features/auth/data/models/auth_hive_model.dart';
import 'package:bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:bazar/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



//Provider
final authRepositoryProvider = Provider<IAuthRepository>((ref){
  final authDatasource = ref.read(authLocalDatasourceProvider);
  return AuthRepository(authDatasource: authDatasource);
});

class AuthRepository implements IAuthRepository{

  final IAuthDataSource _authDataSource;
  AuthRepository({required IAuthDataSource authDatasource})
    : _authDataSource = authDatasource;


  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) async{
    try {
      final model = await _authDataSource.login(email, password);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(
        LocalDatabaseFailure(message: "Invalid email or password"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async{
      try {
      // Check if email already exists
      final existingUser = await _authDataSource.getUserByEmail(user.email);
      if (existingUser != null) {
        return const Left(
          LocalDatabaseFailure(message: "Email already registered"),
        );
      }
      final authModel = AuthHiveModel(
        fullName: user.fullName,
        email: user.email,
        username: user.username,
        password: user.password,
        roleId: user.roleId,
      );
      await _authDataSource.register(authModel);
      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }


}