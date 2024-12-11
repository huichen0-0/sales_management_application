import 'package:sales_management_application/models/product.dart';

class ExportCancellationReceiptDetail {
  String productId;
  Product? product; // Tham chiếu đến sản phẩm
  num cancelledQuantity; // số luơng huủy

  // Constructor
  ExportCancellationReceiptDetail({
    this.product,
    required this.cancelledQuantity,
    required this.productId,
  });

  ExportCancellationReceiptDetail.empty()
      : productId = '',
        cancelledQuantity = 0;

// giá trị hủy
  num get cancelledValue {
    return product!.capitalPrice * cancelledQuantity;
  }

  // Hàm toJSON full
  Map<String, dynamic> toJSON1() {
    return {
      'productId': productId,
      if (product != null) 'product': product!.toJSON(),
      // Giả sử Product có toJSON
      'cancelledQuantity': cancelledQuantity,
    };
  }
  // Hàm toJSON ddeer insert vao db
  Map<String, dynamic> toJSON2() {
    return {
      'productId': productId,
      // Giả sử Product có toJSON
      'cancelledQuantity': cancelledQuantity,
    };
  }

  factory ExportCancellationReceiptDetail.fromJSON(Map<String, dynamic> json) {
    return ExportCancellationReceiptDetail(
      productId: json['productId'],
      product: Product.fromJSON(json['product']),
      // Chuyển 'product' từ JSON thành đối tượng Product
      cancelledQuantity:
          json['cancelledQuantity'] ?? 1, // Mặc định là 0 nếu không có giá trị
    );
  }
}
