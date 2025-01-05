import 'view/export_receipt_detail.dart';

/// Phiếu xuất hủy
class ExportCancellationReceipt {
  String id; // Mã phiếu
  int status; // Trạng thái phiếu
  DateTime createdAt; // Ngày tạo phiếu
  List<ExportCancellationReceiptDetail> details; // Danh sách sản phẩm trong phiếu
  String? uid;

  // Constructor
  ExportCancellationReceipt({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.details,
    required this.uid,
  });

  ExportCancellationReceipt.empty()
      : id = '',
        status = 1,
        createdAt = DateTime.now(),
        details = [],
        uid = '';

// lấy tổng số lượng hủy
  num get totalCancelledQuantity {
    return details.fold(0, (sum, detail) => sum + (detail.cancelledQuantity));
  }

// lấy tổng giá trị hủy
  num get totalCancelledValue {
    return details.fold(
        0,
            (sum, detail) =>
        sum + (detail.product!.capitalPrice * detail.cancelledQuantity));
  }

  // Hàm toJSON full
  Map<String, dynamic> toJSON1() {
    return {
      'id': id,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'details': details.map((product) => product.toJSON1()).toList(),
      'uid': uid
    };
  }

  // Hàm toJSON insert db
  Map<String, dynamic> toJSON2() {
    return {
      'id': id,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'details': details.map((product) => product.toJSON2()).toList(),
      'uid': uid
    };
  }

  // Hàm fromJSON
  factory ExportCancellationReceipt.fromJSON(Map<dynamic, dynamic> json) {
    return ExportCancellationReceipt(
      id: json['id'] ?? '',
      status: json['status'],
      details: (json['details'] as List<dynamic>)
            .map((detail) => ExportCancellationReceiptDetail.fromJSON(detail))
            .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      uid: json['uid']
    );
  }
}
