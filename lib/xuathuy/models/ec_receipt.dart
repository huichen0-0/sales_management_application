import 'package:sales_management_application/xuathuy/models/ec_receipt_detail.dart';

/// Phiếu xuất hủy
class ExportCancellationReceipt {
  String id; // Mã phiếu
  int status; // Trạng thái phiếu
  DateTime createdAt; // Ngày tạo phiếu
  List<ExportCancellationReceiptDetail>
      products; // Danh sách sản phẩm trong phiếu

  // Constructor
  ExportCancellationReceipt({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.products,
  });

  ExportCancellationReceipt.empty()
      : id = '',
        status = 1,
        createdAt = DateTime.now(),
        products = [];

// lấy tổng số lượng hủy
  num get totalCancelledQuantity {
    return products.fold(0, (sum, detail) => sum + (detail.cancelledQuantity));
  }

// lấy tổng giá trị hủy
  num get totalCancelledValue {
    return products.fold(
        0,
        (sum, detail) =>
            sum + (detail.product!.capitalPrice * detail.cancelledQuantity));
  }

  // Hàm toJSON full
  Map<String, dynamic> toJSON1() {
    return {
      'id': id,
      'status': status,
      'createdAt': createdAt,
      'products': products.map((product) => product.toJSON1()).toList(),
    };
  }

  // Hàm toJSON insert db
  Map<String, dynamic> toJSON2() {
    return {
      'id': id,
      'status': status,
      'createdAt': createdAt,
      'products': products.map((product) => product.toJSON2()).toList(),
    };
  }

  // Hàm fromJSON
  factory ExportCancellationReceipt.fromJSON(Map<String, dynamic> json) {
    return ExportCancellationReceipt(
      id: json['id'],
      status: json['status'],
      createdAt: json['createdAt'],
      products: (json['products'] as List<dynamic>)
          .map((product) => ExportCancellationReceiptDetail.fromJSON(product))
          .toList(),
    );
  }
}
