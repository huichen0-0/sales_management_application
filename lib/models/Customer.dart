class Customer { // Khách hàng
  String _id = ''; // ID khách hàng
  String name; // Tên
  String phoneNumber; // Số điện thoại
  int? gender; // Giới tính Nam 1 Nữ 2 Khác 3 Không nhập là 4
  String? address; // Địa chỉ
  String? email; //email
  String? note; //Ghi chú
  int? status;  // Trạng thái 0 là đã xóa, 1 là chưa xóa
  String? shopOwnerId; //id chủ cửa hàng
  int? isActivated; // trạng thái kích hoạt
  DateTime? created_at; // Ngày tạo khách hàng
  num amountSell = 0; // Tổng bán
  num amountReturn = 0; // Tổng trả

  Customer({
    required this.name,
    required this.phoneNumber,
    this.gender,
    this.address,
    this.email,
    this.note,
    this.status,
    this.shopOwnerId,
    this.isActivated,
    this.created_at,
    required this.amountSell,
    required this.amountReturn,
  });

  // Getter cho id
  String get id => _id;

  // Setter cho id
  set id(String value) {
    _id = value;
  }

  factory Customer.fromJson(Map<dynamic, dynamic> json) => Customer(
    name: json['name'],
    phoneNumber: json['phoneNumber'],
    gender: json['gender'],
    address: json['address'],
    email: json['email'],
    note: json['note'],
    status: json['status'],
    shopOwnerId: json['shopOwnerId'],
    isActivated: json['isActivated'],
    created_at: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    amountSell: json['amountSell'],
    amountReturn: json['amountReturn']
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'gender': gender,
    'address': address,
    'email': email,
    'note': note,
    'status': status,
    'shopOwnerId': shopOwnerId,
    'isActivated': isActivated,
    'created_at': created_at?.toIso8601String(),
    'amountSell': amountSell,
    'amountReturn': amountReturn
  };
}