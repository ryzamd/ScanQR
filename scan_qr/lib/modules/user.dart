class User {
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

  User({
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

  factory User.fromJson(Map<String, dynamic> json){
    
    return User(
      userID: json['userID'],
      userImage: json['userImage'],
      firstName: json['firstname'],
      lastName: json['lastName'],
      userName: json['userName'],
      passWord: json['passWord'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      department: json['department'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson(){

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

  User copyWith({
    String? userID,
    String? userImage,
    String? firstName,
    String? lastName,
    String? userName,
    String? passWord,
    String? phoneNumber,
    String? gender,
    String? department,
    String? position,
  }){
    return User(
      userID: userID ?? this.userID,
      userImage: userImage ?? this.userImage,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      passWord: passWord ?? this.passWord,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      department: department ?? this.department,
      position: position ?? this.position,
    );
  }
}
