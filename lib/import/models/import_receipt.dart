import 'package:sales_management_application/models/receipt.dart';

import '../../models/receipt_detail.dart';
import '../../models/supplier.dart';
import '/payment/model/payment.dart';

class ImportReceipt extends Receipt {
  Supplier? supplier; //nhà cung cấp
  bool returned; //đã trả hàng?

  ImportReceipt({
    required super.id,
    required super.partnerId,
    required super.payments,
    required super.status,
    required super.createdAt,
    required this.supplier,
    required super.details,
    required this.returned,
  });

  ImportReceipt.empty()
      : supplier = Supplier.empty(),
        returned = false,
        super(
            id: '',
            partnerId: '',
            status: 1,
            details: [],
            payments: [],
            createdAt: DateTime.now());

  //tổng so luong nhập


  factory ImportReceipt.fromJson(Map<dynamic, dynamic> json) => ImportReceipt(
        id: json['id'],
        partnerId: json['partnerId'],
        supplier: json['supplier'] != null
            ? Supplier.fromJson(json['supplier'])
            : null,
        details: (json['details'] as List<dynamic>)
            .map((detail) => ReceiptDetail.fromJson(detail))
            .toList(),
        payments: (json['payments'] as List<dynamic>)
            .map((payment) => Payment.fromJson(payment))
            .toList(),
        createdAt: json['createdAt'],
        status: json['status'],
        returned: json['returned'],
      );

  // chuyển sang json (đầy đủ)
  Map<String, dynamic> toJson1() => {
        'id': id,
        'partnerId': partnerId,
        if (supplier != null) 'supplier': supplier!.toJson(),
        'details': details.map((detail) => detail.toJson1()).toList(),
        'payments': payments.map((payments) => payments.toJson()).toList(),
        'createdAt': createdAt,
        'status': status,
        'returned': returned,
      };

  //chuyển sang json (chỉ tham chiếu id) => lưu vào db
  Map<String, dynamic> toJson2() => {
        'id': id,
        'partnerId': partnerId,
        'details': details.map((detail) => detail.toJson2()).toList(),
        'payments': payments.map((payments) => payments.toJson()).toList(),
        'createdAt': createdAt,
        'status': status,
        'returned': returned,
      };
}
