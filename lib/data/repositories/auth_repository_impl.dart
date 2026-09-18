import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource dataSource;
  AuthRepositoryImpl(this.dataSource);

  @override
  Future<User> login(String email, String password) => dataSource.login(email, password);
}
