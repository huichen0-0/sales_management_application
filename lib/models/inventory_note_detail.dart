import 'package:sales_management_application/models/product.dart';

class InventoryNoteDetail {
  Product _product; // Tham chiếu đến sản phẩm
  num _matchedQuantity; // Số lượng thực tế đã kiểm

  // Constructor
  InventoryNoteDetail({
    required Product product,
    int matchedQuantity = 0,
  })  : _product = product,
        _matchedQuantity = matchedQuantity;

  // Getter và Setter
  Product get product => _product;
  set product(Product value) => _product = value;

  num get matchedQuantity => _matchedQuantity;
  set matchedQuantity(num value) => _matchedQuantity = value;

  // Getter để lấy stockQuantity từ Product
  num get stockQuantity => _product.quantity;

  // Getter tính toán quantityDifference
  num get quantityDifference {
    return _matchedQuantity - stockQuantity;
  }
  // lấy giá trị kho
  num get stockValue {
    return _product.quantity * _product.capitalPrice;
  }

  //giá trị thực
  num get matchedValue {
    return _matchedQuantity * _product.capitalPrice;
  }
  //giá trị lệch
  num get differenceValue {
    return matchedValue - stockValue;
  }
  // Hàm toJSON
  Map<String, dynamic> toJSON() {
    return {
      'product': _product.toJSON(), // Giả sử Product có toJSON
      'matchedQuantity': _matchedQuantity,
    };
  }
  factory InventoryNoteDetail.fromJSON(Map<String, dynamic> json) {
    print(json);
    return InventoryNoteDetail(

      product: Product.fromJSON(json['product']),  // Chuyển 'product' từ JSON thành đối tượng Product
      matchedQuantity: json['matchedQuantity'] ?? 0, // Mặc định là 0 nếu không có giá trị
    );
  }
}