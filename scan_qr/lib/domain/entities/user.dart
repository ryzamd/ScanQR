class User {
  final String? userID;
  final String firstName;
  final String lastName;
  final String userName;
  final String phoneNumber;
  final String gender;
  final String department;
  final String position;

  User({
    this.userID,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.phoneNumber,
    required this.gender,
    required this.department,
    required this.position,
  });

  String getFullName() {
    return '$firstName $lastName';
  }
}
