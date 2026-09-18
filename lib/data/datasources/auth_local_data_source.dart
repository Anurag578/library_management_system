// DATA LAYER - a "local" data source standing in for a real backend.
// Admin-only now, since student self-service login has been removed.

import '../../domain/entities/user.dart';

class AuthLocalDataSource {
  final Map<String, ({String password, User user})> _accounts = {
    'admin@library.com': (
      password: 'admin123',
      user: const User(id: 1, name: 'Alex Morgan', email: 'admin@library.com'),
    ),
  };

  Future<User> login(String email, String password) async {
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw Exception('Invalid email or password');
    }
    return account.user;
  }
}
