import 'package:scan_qr/modules/user.dart';

class AuthnicationUser {
  final User user;
  final String accessToken;
  final String refreshToken;
  
  AuthnicationUser({
    required this.user,
    required this.accessToken,
    required this.refreshToken
  });

  factory AuthnicationUser.fromJson(Map<String, dynamic> json){

    return AuthnicationUser(
      user: User.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken']
    );
  }
}