import 'package:scan_qr/data/models/user_model.dart';
import 'package:scan_qr/domain/entities/auth_user.dart';

class AuthUserModel {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthUserModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      user: UserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  AuthUser toEntity() {
    return AuthUser(
      user: user.toEntity(),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
