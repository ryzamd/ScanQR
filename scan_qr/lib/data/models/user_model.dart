// file: lib/data/models/user_model.dart
import 'package:scan_qr/domain/entities/user.dart';

class UserModel {
  final String? userID;
  final String firstName;
  final String lastName;
  final String userName;
  final String passWord;
  final String? userImage;
  final String phoneNumber;
  final String gender;
  final String department;
  final String position;

  UserModel({
    this.userID,
    this.userImage,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.passWord,
    required this.phoneNumber,
    required this.gender,
    required this.department,
    required this.position,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userID: json['userID'],
      userImage: json['userImage'],
      firstName: json['firstname'] ?? json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      passWord: json['passWord'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      department: json['department'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
    data['userImage'] = userImage;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userName'] = userName;
    data['passWord'] = passWord;
    data['phoneNumber'] = phoneNumber;
    data['gender'] = gender;
    data['department'] = department;
    data['position'] = position;
    return data;
  }

  User toEntity() {
    return User(
      userID: userID,
      firstName: firstName,
      lastName: lastName,
      userName: userName,
      phoneNumber: phoneNumber,
      gender: gender,
      department: department,
      position: position,
    );
  }

  factory UserModel.fromEntity(
    User user, {
    required String passWord,
    String? userImage,
  }) {
    return UserModel(
      userID: user.userID,
      firstName: user.firstName,
      lastName: user.lastName,
      userName: user.userName,
      passWord: passWord,
      userImage: userImage,
      phoneNumber: user.phoneNumber,
      gender: user.gender,
      department: user.department,
      position: user.position,
    );
  }
}
