import 'package:sales_management_application/products/product.dart';

class ExportCancellationReceiptDetail {
  Product? product; // Tham chiếu đến sản phẩm
  String productId;
  int cancelledQuantity; // số luơng huủy

  // Constructor
  ExportCancellationReceiptDetail({
    required this.product,
    required this.cancelledQuantity,
    required this.productId
  });

  ExportCancellationReceiptDetail.empty()
      : product = Product.empty(),
        productId = '',
        cancelledQuantity = 0;

// giá trị hủy
  num get cancelledValue {
    return product!.capitalPrice * cancelledQuantity;
  }

  // Hàm toJSON full
  Map<String, dynamic> toJSON1() {
    return {
      'productId': productId,
      'product': product == null ? Product.empty().toJSON() : product?.toJSON(),
      // Giả sử Product có toJSON
      'cancelledQuantity': cancelledQuantity,
    };
  }
  // Hàm toJSON ddeer insert vao db
  Map<String, dynamic> toJSON2() {
    return {
      'productId': productId,
      'cancelledQuantity': cancelledQuantity,
    };
  }

  factory ExportCancellationReceiptDetail.fromJSON(Map<dynamic, dynamic> json) {
    return ExportCancellationReceiptDetail(
      productId: json['productId'],
      product: json['product'] != null ? Product.fromJSON(json['product']) : null, // Chuyển 'product' từ JSON thành đối tượng Product
      cancelledQuantity: json['cancelledQuantity'], // Mặc định là 0 nếu không có giá trị
    );
  }
}
