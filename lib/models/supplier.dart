class Supplier {
  // Nhà cung cấp
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

  Supplier(
      {required this.id,
        required this.amount,
      required this.name,
      required this.address,
      required this.isActive,
      required this.isDeleted,
      required this.phone,
      required this.email,
      required this.note,
      required this.uid, });

  Supplier.empty();

  factory Supplier.fromJson(Map<dynamic, dynamic> json) => Supplier(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      isActive: json['isActive'],
      phone: json['phone'],
      amount: json['amount'],
      email: json['email'],
      note: json['note'],
      isDeleted: json['isDeleted'],
      uid: json['uid']);

  Map<String, dynamic> toJson() => {
        'id': id,
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
