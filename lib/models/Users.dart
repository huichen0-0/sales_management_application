// import 'dart:ffi';

class Users { // Người dùng
  String? uid;
  DateTime? accountCreationDate; // Ngày tạo tài khoản
  int? age; // Ngày sinh
  String? fullName; // Họ tên
  String? email;

  Users({
    this.uid,
    this.accountCreationDate,
    this.age,
    this.fullName,
    this.email,
  });

  factory Users.fromJson(Map<dynamic, dynamic> json) => Users(
    uid: json['password'],
    accountCreationDate: json['accountCreationDate'] != null ? DateTime.parse(json['accountCreationDate']) : null,
    age: json['age'],
    fullName: json['fullName'],
    email: json['email'],
  );

  Map<String, dynamic> toJson() => {
    'password': uid,
    'accountCreationDate': accountCreationDate?.toIso8601String(),
    'birthDate': age,
    'fullName': fullName,
    'email': email,
  };
}