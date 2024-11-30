import 'package:intl/intl.dart';

class Supplier { // Nhà cung cấp
  String id = "";
  num amount = 0;
  String name = "";
  String address = "";
  bool isActive = true;
  bool isDeleted = false;
  String phone = "";
  String email = "";
  String note = "";
  String uid = "";

  // Supplier({required name, required address, required isActive, required phone, required amount, required email, required note, required isDeleted, required uid}) {
  //   DateTime now = DateTime.now();
  //   this.id = DateFormat('yyMMddHHmmss').format(now);
  //   this.amount = 0;
  //   this.name = " ";
  //   this.address = " ";
  //   this.isActive = true;
  //   this.isDeleted = false;
  //   this.phone = " ";
  //   this.email = " ";
  //   this.note = " ";
  //   this.uid = " ";
  // }


  Supplier({required this.amount, required this.name, required this.address, required this.isActive,
      required this.isDeleted, required this.phone, required this.email, required this.note, required this.uid});

  factory Supplier.fromJson(Map<dynamic, dynamic> json) => Supplier(
    // id: json['id'],
    name: json['name'],
    address: json['address'],
    isActive: json['isActive'],
    phone: json['phone'],
    amount: json['amount'],
    email: json['email'],
    note: json['note'],
    isDeleted: json['isDeleted'],
    uid: json['uid']
  );

  Map<String, dynamic> toJson() => {
    // 'id': id,
    'name': name,
    'address': address,
    'phone': phone,
    'amount': amount,
    'isActive': isActive,
    'email': email,
    'note': note,
    'isDeleted': isDeleted,
    'uid': uid
  };
}