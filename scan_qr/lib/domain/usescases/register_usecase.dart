import 'package:scan_qr/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<bool> execute({
    required String name,
    required String phoneNumber,
    required String gender,
    required String username,
    required String password,
    required String image,
    required String department,
    required String position,
  }) {
    return repository.register(
      name: name,
      phoneNumber: phoneNumber,
      gender: gender,
      username: username,
      password: password,
      image: image,
      department: department,
      position: position,
    );
  }

  bool isStepComplete0({
    required String name,
    required String phoneNumber,
    required String? gender,
  }) {
    return name.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$').hasMatch(phoneNumber) &&
        gender != null;
  }

  bool isStepComplete1({
    required String username,
    required String password,
    required String confirmPassword,
    required String image,
  }) {
    return username.isNotEmpty &&
        username.length >= 4 &&
        password.isNotEmpty &&
        password.length >= 6 &&
        confirmPassword == password &&
        image.isNotEmpty;
  }

  bool isStepComplete2({
    required String? department,
    required String? position,
  }) {
    return department != null && position != null;
  }
}
