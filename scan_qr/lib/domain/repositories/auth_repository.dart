import 'package:scan_qr/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<bool> register({
    required String name,
    required String phoneNumber,
    required String gender,
    required String username,
    required String password,
    required String image,
    required String department,
    required String position,
  });

  Future<AuthUser> login({required String username, required String password});
}
