import 'package:sales_management_application/products/product.dart';

class InventoryCheckReceiptDetail {
  String productId;
  Product? product; // Tham chiếu đến sản phẩm
  int matchedQuantity; // Số lượng thực tế đã kiểm

  // Constructor
  InventoryCheckReceiptDetail({
    required this.product,
    required this.matchedQuantity,
    required this.productId
  });

  InventoryCheckReceiptDetail.empty()
      : product = Product.empty(),
        productId = '',
        matchedQuantity = 0;

  num get stockQuantity => product!.quantity;

  // Getter tính toán quantityDifference
  num get quantityDifference {
    return matchedQuantity - stockQuantity;
  }
 // lấy giá trị kho
  num get stockValue {
    return product!.quantity * product!.capitalPrice;
  }

  //giá trị thực
  num get matchedValue {
    return matchedQuantity * product!.capitalPrice;
  }

  //giá trị lệch
  num get differenceValue {
    return matchedValue - stockValue;
  }

  // Hàm toJSON
  Map<String, dynamic> toJSON1() {
    return {
      'productId': productId,
      'product': product == null ? Product.empty().toJSON() : product?.toJSON(),
      // Giả sử Product có toJSON
      'matchedQuantity': matchedQuantity,
    };
  }
  // Hàm toJSON ddeer insert vao db
  Map<String, dynamic> toJSON2() {
    return {
      'productId': productId,
      'matchedQuantity': matchedQuantity,
    };
  }

  factory InventoryCheckReceiptDetail.fromJSON(Map<dynamic, dynamic> json) {
    return InventoryCheckReceiptDetail(
      productId: json['productId'],
      product: json['product'] != null ? Product.fromJSON(json['product']) : null, // Chuyển 'product' từ JSON thành đối tượng Product
      matchedQuantity: json['matchedQuantity'], // Mặc định là 0 nếu không có giá trị
    );
  }
}
