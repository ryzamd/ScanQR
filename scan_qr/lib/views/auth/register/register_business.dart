// register_business.dart
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

class RegisterBusiness {
  /// Kiểm tra step 0: Thông tin cá nhân
  static bool isStepComplete0({
    required String name,
    required String phoneNumber,
    required String? gender,
  }) {
    return name.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$').hasMatch(phoneNumber) &&
        gender != null;
  }

  /// Kiểm tra step 1: Thông tin tài khoản
  static bool isStepComplete1({
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

  /// Kiểm tra step 2: Thông tin công việc
  static bool isStepComplete2({
    required String? department,
    required String? position,
  }) {
    return department != null && position != null;
  }

  /// Kiểm tra form global + dropdowns
  static bool checkFormValid({
    required GlobalKey<FormState> formKey,
    required String? department,
    required String? position,
    required String? gender,
  }) {
    bool isValid = formKey.currentState?.validate() ?? false;
    isValid = isValid && department != null && position != null && gender != null;
    return isValid;
  }

  /// Xử lý submitForm (in log, hiển thị dialog, ...)
  static void submitForm({
    required BuildContext context,
    required bool isFormValid,
    required String name,
    required String username,
    required String password,
    required String image,
    required String? department,
    required String? position,
    required String phoneNumber,
    required String? gender,
    required VoidCallback onSuccess,
  }) {
    if (!isFormValid) return;

    // Log ra màn hình console
    developer.log('Submitted form with:');
    developer.log('Name: $name');
    developer.log('Username: $username');
    developer.log('Password: [HASHED]');
    developer.log('Image: $image');
    developer.log('Department: $department');
    developer.log('Position: $position');
    developer.log('Phone Number: $phoneNumber');
    developer.log('Gender: $gender');

    // Gọi callback khi thành công (VD: hiển thị dialog, pop màn hình, ...)
    onSuccess();
  }
}
