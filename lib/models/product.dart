class Product {
  // Thuộc tính của sản phẩm
  int? id; // ID sản phẩm
  String name; // Tên sản phẩm
  String? barcode; // Mã vạch
  String? imageUrl; // URL hình ảnh sản phẩm
  num capitalPrice; // Giá vốn
  num sellingPrice; // Giá bán
  num quantity; // Tồn kho
  num? minLimit; // Tồn ít nhất
  num? maxLimit; // Tồn nhiều nhất
  String? unit; // Đơn vị
  String? description; // Mô tả sản phẩm
  String? notes; // Ghi chú
  bool? isActived; // Trạng thái hoạt động
  DateTime? createdAt; // Ngày tạo sản phẩm

  // Constructor
  Product({
    this.id,
    required this.name,
    this.barcode,
    this.imageUrl,
    required this.capitalPrice,
    required this.sellingPrice,
    required this.quantity,
    this.minLimit,
    this.maxLimit,
    this.unit,
    this.description,
    this.notes,
    this.isActived = true,
    this.createdAt,
  });

  // Kiểm tra xem sản phẩm có tồn kho dưới mức tối thiểu không
  bool isBelowMinLimit() {
    return quantity < minLimit!;
  }

  // Kiểm tra xem sản phẩm có tồn kho vượt mức tối đa không
  bool isAboveMaxLimit() {
    return quantity > maxLimit!;
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
      'isActived': isActived,
      'createdAt': createdAt, // Định dạng ngày tháng
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
      isActived: json['isActived'],
      createdAt: json['createdAt'],
    );
  }
}
