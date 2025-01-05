import '../payment/payment.dart';
import '../receipt/receipt.dart';
import '../receipt/receipt_detail.dart';
import '../suppliers/supplier.dart';

class ImportReceipt extends Receipt {
  Supplier? supplier; //nhà cung cấp
  //TODO:khi tạo phiếu trả hàng ở trạng thái hoàn thành, cập nhật returned=true
  bool returned; //đã trả hàng?

  ImportReceipt({
    required super.id,
    required super.partnerId,
    required super.payments,
    required super.status,
    required super.createdAt,
    this.supplier,
    required super.uid,
    required super.details,
    required this.returned,
  });

  ImportReceipt.empty()
      : returned = false,
        super(
          id: '',
          partnerId: '',
          status: 0,
          details: [],
          payments: [],
          createdAt: DateTime.now(),
          uid: ''
      );

  //tổng so luong nhập

  factory ImportReceipt.fromJson(Map<dynamic, dynamic> json) => ImportReceipt(
    id: json['id'] ?? '',
    partnerId: json['partnerId'],
    supplier: json['supplier'] != null
        ? Supplier.fromJson(json['supplier'])
        : null,
    details: (json['details'] as List<dynamic>)
        .map((detail) => ReceiptDetail.fromJson(detail))
        .toList(),
    payments: json['payments'] == null ? [] : (json['payments'] as List<dynamic>)
        .map((payment) => Payment.fromJson(payment))
        .toList(),
    createdAt: DateTime.parse(json['createdAt']),
    status: json['status'],
    returned: json['returned'],
    uid: json['uid']
  );

  // chuyển sang json (đầy đủ)
  Map<String, dynamic> toJson1() => {
    'id': id,
    'partnerId': partnerId,
    if (supplier != null) 'supplier': supplier!.toJson(),
    'details': details.map((detail) => detail.toJson1()).toList(),
    'payments': payments.map((payments) => payments.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'status': status,
    'returned': returned,
    'uid': uid
  };

  //chuyển sang json (chỉ tham chiếu id) => lưu vào db
  Map<String, dynamic> toJson2() => {
    'id': id,
    'partnerId': partnerId,
    'details': details.map((detail) => detail.toJson2()).toList(),
    'payments': payments.map((payments) => payments.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'status': status,
    'returned': returned,
    'uid': uid
  };
}
