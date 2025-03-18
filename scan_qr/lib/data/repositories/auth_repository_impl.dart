// file: lib/data/repositories/auth_repository_impl.dart
import 'dart:developer' as developer;
import 'package:scan_qr/data/models/auth_user_model.dart';
import 'package:scan_qr/data/models/user_model.dart';
import 'package:scan_qr/domain/entities/auth_user.dart';
import 'package:scan_qr/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<bool> register({
    required String name,
    required String phoneNumber,
    required String gender,
    required String username,
    required String password,
    required String image,
    required String department,
    required String position,
  }) async {
    try {
      // Original logic from RegisterBusiness
      developer.log('Submitted form with:');
      developer.log('Name: $name');
      developer.log('Username: $username');
      developer.log('Password: [HASHED]');
      developer.log('Image: $image');
      developer.log('Department: $department');
      developer.log('Position: $position');
      developer.log('Phone Number: $phoneNumber');
      developer.log('Gender: $gender');

      // In a real app, would make API call here
      return true;
    } catch (e) {
      developer.log('Registration error: $e');
      return false;
    }
  }

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    // Mock implementation - in a real app, would make API call
    // and handle authentication

    final userModel = UserModel(
      userID: '1',
      firstName: 'John',
      lastName: 'Doe',
      userName: username,
      passWord: password, // In a real app, would never store plain password
      phoneNumber: '0123456789',
      gender: 'Male',
      department: 'IT',
      position: 'Developer',
    );

    final authUserModel = AuthUserModel(
      user: userModel,
      accessToken: 'mock_access_token',
      refreshToken: 'mock_refresh_token',
    );

    return authUserModel.toEntity();
  }
}
