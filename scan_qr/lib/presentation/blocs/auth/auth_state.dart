import 'package:scan_qr/domain/entities/auth_user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final AuthUser user;

  LoginSuccess(this.user);
}

class RegisterSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}