class Customer { // Khách hàng
  String id = ''; // ID khách hàng
  String name; // Tên
  String phoneNumber; // Số điện thoại
  int? gender; // Giới tính Nam 1 Nữ 2 Khác 3 Không nhập là 4
  String? address; // Địa chỉ
  String? email; //email
  String? note; //Ghi chú
  int status;  // Trạng thái 0 là đã xóa, 1 là chưa xóa
  String? uid; //id chủ cửa hàng
  DateTime createdAt; // Ngày tạo khách hàng
  num amountSell = 0; // Tổng bán
  num amountReturn = 0; // Tổng trả

  Customer.empty() :
      name = '',
      phoneNumber = '',
      amountReturn = 0,
      amountSell = 0,
      id = '',
      status = 1,
      createdAt = DateTime.now()
  ;

  Customer({
    required this.name,
    required this.phoneNumber,
    this.gender,
    this.address,
    this.email,
    this.note,
    required this.status,
    this.uid,
    required this.createdAt,
    required this.amountSell,
    required this.amountReturn,
    required this.id
  });

  factory Customer.fromJson(Map<dynamic, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      address: json['address'],
      email: json['email'],
      note: json['note'],
      status: json['status'],
      uid: json['uid'],
      createdAt: DateTime.parse(json['createdAt']) ,
      amountSell: json['amountSell'],
      amountReturn: json['amountReturn']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phoneNumber': phoneNumber,
    'gender': gender,
    'address': address,
    'email': email,
    'note': note,
    'status': status,
    'uid': uid,
    'createdAt': createdAt?.toIso8601String(),
    'amountSell': amountSell,
    'amountReturn': amountReturn
  };
}