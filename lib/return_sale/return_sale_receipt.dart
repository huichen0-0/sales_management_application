import '../customers/model/customer.dart';
import '../payment/payment.dart';
import '../receipt/receipt.dart';
import '../receipt/receipt_detail.dart';

class ReturnInvoiceReceipt extends Receipt {
  String invoiceReceiptId;
  Customer? customer;

  ReturnInvoiceReceipt({
    required super.id,
    required this.invoiceReceiptId,
    required super.partnerId,
    this.customer,
    required super.uid,
    required super.payments,
    required super.status,
    required super.createdAt,
    required super.details,
  });

  ReturnInvoiceReceipt.empty()
      : invoiceReceiptId = '',
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


  factory ReturnInvoiceReceipt.fromJson(Map<dynamic, dynamic> json) => ReturnInvoiceReceipt(
    id: json['id'] ?? '',
    partnerId: json['partnerId'],
    invoiceReceiptId: json['invoiceReceiptId'],
    customer: json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null,
    details: (json['details'] as List<dynamic>)
        .map((detail) => ReceiptDetail.fromJson(detail))
        .toList(),
    payments: json['payments'] == null ? [] : (json['payments'] as List<dynamic>)
        .map((payment) => Payment.fromJson(payment))
        .toList(),
    createdAt: DateTime.parse(json['createdAt']),
    status: json['status'],
    uid: json['uid']
  );

  // chuyển sang json (đầy đủ)
  Map<String, dynamic> toJson1() => {
    'id': id,
    'partnerId': partnerId,
    if (customer != null) 'customer': customer!.toJson(),
    'invoiceReceiptId': invoiceReceiptId,
    'details': details.map((detail) => detail.toJson1()).toList(),
    'payments': payments.map((payments) => payments.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'status': status,
    ///(dùng cho sắp xếp)
    'totalSaleValue': totalSaleValue, //tổng tiền
    'totalPaid': amountPaid, //đã trả
    'uid': uid
  };

  //chuyển sang json (chỉ tham chiếu id) => lưu vào db
  Map<String, dynamic> toJson2() => {
    'id': id,
    'invoiceReceiptId': invoiceReceiptId,
    'partnerId': partnerId,
    'details': details.map((detail) => detail.toJson2()).toList(),
    'payments': payments.map((payments) => payments.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'status': status,
    'uid': uid
  };
}
