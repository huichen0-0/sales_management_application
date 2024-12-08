import 'package:sales_management_application/models/product.dart';

class ExportCancellationReceiptDetail {
  Product _product; // Tham chiếu đến sản phẩm
  num _cancelledQuantity; // số luơng huủy
  

  // Constructor
  ExportCancellationReceiptDetail({
    required Product product,
    required num cancelledQuantity,
    
  })  : _product = product,
        _cancelledQuantity = cancelledQuantity;
       

  // Getter và Setter
  Product get product => _product;
  set product(Product value) => _product = value;

  num get cancelledQuantity => _cancelledQuantity;
  set cancelledQuantity(num value) => _cancelledQuantity = value;

// giá trị hủy
  num get cancelledValue {
    return _product.capitalPrice! * _cancelledQuantity;
  }

  // Hàm toJSON
  Map<String, dynamic> toJSON() {
    return {
      'product': _product.toJSON(), // Giả sử Product có toJSON
      'cancelledQuantity': _cancelledQuantity,
    };
  }
  factory ExportCancellationReceiptDetail.fromJSON(Map<String, dynamic> json) {
    return ExportCancellationReceiptDetail(
      product: Product.fromJSON(json['product']),  // Chuyển 'product' từ JSON thành đối tượng Product
      cancelledQuantity: json['cancelledQuantity'] ?? 1, // Mặc định là 0 nếu không có giá trị
    );
  }
}