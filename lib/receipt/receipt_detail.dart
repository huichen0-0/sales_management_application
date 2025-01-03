
import '../products/product.dart';

class ReceiptDetail {
  // Chi tiết phiếu nhập
  String productId;
  Product? product; // hàng hóa
  num quantity; // Số lượng
  num? maxQuantity; //số lượng tối đa (cho phiếu trả)

  ReceiptDetail({
    required this.productId,
    this.product,
    required this.quantity,
    this.maxQuantity,
  });

  ReceiptDetail.empty()
      : productId = '',
        quantity = 0;

  //giá trị nhập
  num get capitalValue {
    return product!.capitalPrice * quantity;
  }
  //giá trị bán
  num get saleValue {
    return product!.sellingPrice * quantity;
  }

  factory ReceiptDetail.fromJson(Map<dynamic, dynamic> json) =>
      ReceiptDetail(
        productId: json['productId'],
        product: json['product'] != null
            ? Product.fromJSON(json['product'])
            : null, // Chỉ ánh xạ nếu `product` không null
        quantity: json['quantity'],
        maxQuantity: json['maxQuantity']
      );

  Map<String, dynamic> toJson1() => {
    'productId': productId,
    if (product != null) 'product': product!.toJSON(),
    // Chỉ thêm nếu `product` không null
    'quantity': quantity,
    if (maxQuantity != null) 'maxQuantity': maxQuantity,
  };

  Map<String, dynamic> toJson2() => {
    'productId': productId,
    'quantity': quantity,
    if (maxQuantity != null) 'maxQuantity': maxQuantity,
  };
}
