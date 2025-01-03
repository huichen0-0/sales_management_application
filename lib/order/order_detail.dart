import '../products/product.dart';

class OrderDetail {
  String productId;
  Product? product;
  int quantity;

  OrderDetail({
    required this.productId,
    this.product,
    required this.quantity,
  });

  OrderDetail.empty()
      : productId = '',
        quantity = 0;

  num get amount {
    return product!.sellingPrice * quantity;
  }

  factory OrderDetail.fromJson(Map<dynamic, dynamic> json) {
    return OrderDetail(
      product:
          json['product'] != null ? Product.fromJSON(json['product']) : null,
      quantity: json['quantity'] ?? 0,
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson1() {
    return {
      'productId': productId,
      if (product != null) 'product': product!.toJSON(),
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toJson2() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}
