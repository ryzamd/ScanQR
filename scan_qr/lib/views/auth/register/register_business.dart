// register_business.dart
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

class RegisterBusiness {
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

  static bool isStepComplete2({
    required String? department,
    required String? position,
  }) {
    return department != null && position != null;
  }

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

    developer.log('Submitted form with:');
    developer.log('Name: $name');
    developer.log('Username: $username');
    developer.log('Password: [HASHED]');
    developer.log('Image: $image');
    developer.log('Department: $department');
    developer.log('Position: $position');
    developer.log('Phone Number: $phoneNumber');
    developer.log('Gender: $gender');

    onSuccess();
  }
}
