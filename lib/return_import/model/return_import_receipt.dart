import '../../payment/payment.dart';
import '../../receipt/receipt.dart';
import '../../receipt/receipt_detail.dart';
import '../../suppliers/supplier.dart';

class ReturnImportReceipt extends Receipt {
  String importReceiptId;
  Supplier? supplier;

  ReturnImportReceipt({
    required super.id,
    required this.importReceiptId,
    required super.partnerId,
    required super.uid,
    this.supplier,
    required super.payments,
    required super.status,
    required super.createdAt,
    required super.details,
  });

  ReturnImportReceipt.empty()
      :importReceiptId = '',
        supplier = Supplier.empty(),
        super(
          id: '',
          partnerId: '',
          status: 1,
          details: [],
          payments: [],
          createdAt: DateTime.now(),
          uid: ''
      );

  //tổng so luong nhập


  factory ReturnImportReceipt.fromJson(Map<dynamic, dynamic> json) => ReturnImportReceipt(
    id: json['id'],
    partnerId: json['partnerId'],
    importReceiptId: json['importReceiptId'],
    supplier: json['supplier'] != null
        ? Supplier.fromJson(json['supplier'])
        : null,
    details: (json['details'] as List<dynamic>)
        .map((detail) {
          return ReceiptDetail.fromJson(detail);})
        .toList(),
    payments: json['payments'] == null ? [] : (json['payments'] as List<dynamic>)
        .map((payment) {
          return Payment.fromJson(payment);
        })
        .toList(),
    createdAt: DateTime.parse(json['createdAt']),
    status: json['status'],
    uid: json['uid']
  );

  // chuyển sang json (đầy đủ)
  Map<String, dynamic> toJson1() => {
    'id': id,
    'partnerId': partnerId,
    if (supplier != null) 'supplier': supplier!.toJson(),
    'importReceiptId': importReceiptId,
    'details': details.map((detail) => detail.toJson1()).toList(),
    'payments': payments.map((payments) => payments.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'status': status,
    'uid': uid
  };

  //chuyển sang json (chỉ tham chiếu id) => lưu vào db
  Map<String, dynamic> toJson2() => {
    'id': id,
    'importReceiptId': importReceiptId,
    'partnerId': partnerId,
    'details': details.map((detail) => detail.toJson2()).toList(),
    'payments': payments.map((payments) => payments.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'status': status,
    'uid': uid
  };
}
