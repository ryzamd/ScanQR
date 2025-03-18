import 'package:scan_qr/domain/entities/user.dart';

class AuthUser {
  final User user;
  final String accessToken;
  final String refreshToken;

  AuthUser({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
}
