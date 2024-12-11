class Product {
  // Thuộc tính của sản phẩm
  String? id=''; // ID sản phẩm
  String name=''; // Tên sản phẩm
  String barcode=''; // Mã vạch
  String? imageUrl=''; // URL hình ảnh sản phẩm
  num capitalPrice=0; // Giá vốn
  num sellingPrice=0; // Giá bán
  num quantity=0; // Tồn kho
  num minLimit=0; // Tồn ít nhất
  num maxLimit=0; // Tồn nhiều nhất
  String? unit=''; // Đơn vị
  String? description=''; // Mô tả sản phẩm
  String notes=''; // Ghi chú
  bool isActive = true; // Trạng thái hoạt động
  DateTime? createdAt; // Ngày tạo sản phẩm
  String? uid='';

  Product.empty();

  // Constructor
  Product({
    this.id,
    required this.name,
    required this.barcode,
    this.imageUrl,
    required this.capitalPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.minLimit,
    required this.maxLimit,
    this.unit,
    this.description,
    required this.notes,
    this.isActive = true,
    this.createdAt,
    this.uid
  });

  // Kiểm tra xem sản phẩm có tồn kho dưới mức tối thiểu không
  bool isBelowMinLimit() {
    return quantity < minLimit;
  }

  // Kiểm tra xem sản phẩm có tồn kho vượt mức tối đa không
  bool isAboveMaxLimit() {
    return quantity > maxLimit;
  }
  // Hàm toJSON
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'imageUrl': imageUrl,
      'capitalPrice': capitalPrice,
      'sellingPrice': sellingPrice,
      'quantity': quantity,
      'minLimit': minLimit,
      'maxLimit': maxLimit,
      'unit': unit,
      'description': description,
      'notes': notes,
      'isActive': isActive,
      'created_at': createdAt, // Định dạng ngày tháng
      'uid': uid
    };
  }
  factory Product.fromJSON(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        barcode: json['barcode'],
        imageUrl: json['imageUrl'],
        capitalPrice: json['capitalPrice'],
        sellingPrice: json['sellingPrice'],
        quantity: json['quantity'],
        minLimit: json['minLimit'],
        maxLimit: json['maxLimit'],
        unit: json['unit'],
        description: json['description'],
        notes: json['notes'],
        isActive: json['isActive'],
        createdAt: json['createdAt'],
        uid: json['uid']
    );
  }
}