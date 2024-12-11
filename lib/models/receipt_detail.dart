import '/models/product.dart';

class ReceiptDetail {
  // Chi tiết phiếu nhập
  String productId;
  Product? product; // hàng hóa
  num quantity; // Số lượng

  ReceiptDetail({
    required this.productId,
    this.product,
    required this.quantity,
  });

  ReceiptDetail.empty()
      : productId = '',
        product = Product.empty(),
        quantity = 0;

  //giá trị nhập
  num get value {
    return product!.capitalPrice * quantity;
  }

  factory ReceiptDetail.fromJson(Map<dynamic, dynamic> json) =>
      ReceiptDetail(
        productId: json['productId'],
        product: json['product'] != null
            ? Product.fromJSON(json['product'])
            : null, // Chỉ ánh xạ nếu `product` không null
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson1() => {
    'productId': productId,
    if (product != null) 'product': product!.toJSON(),
    // Chỉ thêm nếu `product` không null
    'quantity': quantity,
  };

  Map<String, dynamic> toJson2() => {
    'productId': productId,
    'quantity': quantity,
  };
}
