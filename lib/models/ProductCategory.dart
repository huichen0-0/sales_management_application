class ProductCategory { // Danh mục hàng hóa
  String id;
  String name; // Tên
  String description; // Mô tả
  String typeId; // Mã loại
  int stockLimit; // Mức tồn kho
  double sellingPrice; // Giá bán
  double costPrice; // Giá mua
  int expirationDate; // Ngày hết hạn
  String unit; // Đơn vị tính
  String uid;

  ProductCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.typeId,
    required this.stockLimit,
    required this.sellingPrice,
    required this.costPrice,
    required this.expirationDate,
    required this.unit,
    required this.uid
  });

  factory ProductCategory.fromJson(Map<dynamic, dynamic> json) => ProductCategory(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    typeId: json['typeId'],
    stockLimit: json['stockLimit'],
    sellingPrice: json['sellingPrice'].toDouble(),
    costPrice: json['costPrice'].toDouble(),
    expirationDate: json['expirationDate'],
    unit: json['unit'],
    uid: json['uid']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'typeId': typeId,
    'stockLimit': stockLimit,
    'sellingPrice': sellingPrice,
    'costPrice': costPrice,
    'expirationDate': expirationDate,
    'unit': unit,
    'uid': uid
  };
}