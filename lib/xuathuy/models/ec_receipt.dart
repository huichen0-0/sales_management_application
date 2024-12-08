import 'package:sales_management_application/xuathuy/models/ec_receipt_detail.dart';

/// Phiếu xuất hủy
class ExportCancellationReceipt {
  int? _id; // Mã phiếu
  int? _status; // Trạng thái phiếu
  DateTime? _createdAt; // Ngày tạo phiếu
  List<ExportCancellationReceiptDetail> _products; // Danh sách sản phẩm trong phiếu

  // Constructor
  ExportCancellationReceipt({
    int? id,
    int? status,
    DateTime? createdAt,
    List<ExportCancellationReceiptDetail>? products,
  })  : _id = id,
        _status = status,
        _createdAt = createdAt,
        _products = products ?? [];

  // Getter và Setter
  int? get id => _id;

  set id(int? value) => _id = value;

  int? get status => _status;

  set status(int? value) => _status = value;

  DateTime? get createdAt => _createdAt;

  set createdAt(DateTime? value) => _createdAt = value;

  List<ExportCancellationReceiptDetail> get products => _products;

  set products(List<ExportCancellationReceiptDetail> value) => _products = value;
// lấy tổng số lượng hủy
  num get totalCancelledQuantity {
    return _products.fold(0, (sum, detail) => sum + (detail.cancelledQuantity));
  }
// lấy tổng giá trị hủy
  num get totalCancelledValue {
    return _products.fold(0, (sum, detail) => sum + (detail.product.capitalPrice! * detail.cancelledQuantity));
  }

  // Hàm toJSON
  Map<String, dynamic> toJSON() {
    return {
      'id': _id,
      'status': _status,
      'createdAt': _createdAt,
      'products': _products.map((product) => product.toJSON()).toList(),
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
