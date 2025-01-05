import '../customers/model/customer.dart';
import '../receipt/receipt.dart';
import '../receipt/receipt_detail.dart';
import '../payment/payment.dart';

class InvoiceReceipt extends Receipt {
  Customer? customer; //nhà cung cấp
  //TODO:khi tạo phiếu trả hàng ở trạng thái hoàn thành, cập nhật returned=true
  bool returned; //đã trả hàng?

  InvoiceReceipt({
    required super.id,
    required super.partnerId,
    required super.payments,
    required super.status,
    required super.createdAt,
    required super.uid,
    this.customer,
    required super.details,
    required this.returned,
  });

  InvoiceReceipt.empty()
      : returned = false,
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

  factory InvoiceReceipt.fromJson(Map<dynamic, dynamic> json) => InvoiceReceipt(
    id: json['id'],
    partnerId: json['partnerId'],
    customer: json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : Customer.empty(),
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
    if (customer != null) 'customer': customer!.toJson(),
    'details': details.map((detail) => detail.toJson1()).toList(),
    'payments': payments.map((payments) => payments.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'status': status,
    'returned': returned,
    ///(dùng cho sắp xếp)
    'totalSaleValue': totalSaleValue, //tổng tiền
    'totalPaid': amountPaid, //đã trả
    'saleDue': saleDue, //còn nợ
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
