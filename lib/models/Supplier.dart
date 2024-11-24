class Supplier { // Nhà cung cấp
  int id;
  num amount;
  String name; // Tên nhà cung cấp
  String address; // Địa chỉ
  bool isActive; // Mã trạng thái
  String phone;
  String email;
  String note;


  Supplier.name(this.id, this.amount, this.name, this.address, this.isActive,
      this.phone, this.email, this.note);

  Supplier({
    required this.id,
    required this.name,
    required this.address,
    required this.isActive,
    required this.amount,
    required this.phone,
    required this.email,
    required this.note
  });

  factory Supplier.fromJson(Map<dynamic, dynamic> json) => Supplier(
    id: json['id'],
    name: json['name'],
    address: json['address'],
    isActive: json['isActive'],
    phone: json['phone'],
    amount: json['amount'],
    email: json['email'],
    note: json['note']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'phone': phone,
    'amount': amount,
    'isActive': isActive,
    'email': email,
    'note': note
  };
}