// file: lib/presentation/blocs/auth/auth_event.dart
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({
    required this.username,
    required this.password,
  });
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String phoneNumber;
  final String gender;
  final String username;
  final String password;
  final String image;
  final String department;
  final String position;

  RegisterRequested({
    required this.name,
    required this.phoneNumber,
    required this.gender,
    required this.username,
    required this.password,
    required this.image,
    required this.department,
    required this.position,
  });
}