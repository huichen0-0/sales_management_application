import '../customers/model/customer.dart';
import 'order_detail.dart';

class Order {
  String id;
  String customerId; // Mã kH
  Customer? customer;
  List<OrderDetail> details; //Danh sách chi tiết phiếu
  DateTime createdAt; // Ngày tạo
  int status; // trạng thái
  String uid;

  Order({
    required this.id,
    required this.customerId,
    this.customer,
    required this.status,
    required this.createdAt,
    required this.details,
    required this.uid
  });

  Order.empty()
      : id = '',
        customerId = '',
        details = [],
        status = 1,
        createdAt = DateTime.now(),
        uid = ''
  ;

  // Tổng số lượng
  num get totalQuantity {
    return details.fold(0, (sum, detail) => sum + detail.quantity);
  }

  //tổng giá trị nhập
  num get totalAmount {
    return details.fold(0, (sum, detail) => sum + detail.amount);
  }

  factory Order.fromJson(Map<dynamic, dynamic> json) => Order(
        id: json['id'] ?? '',
        customerId: json['customerId'],
        customer: json['customer'] != null
            ? Customer.fromJson(json['customer'])
            : null,
        details: (json['details'] as List<dynamic>)
            .map((detail) => OrderDetail.fromJson(detail))
            .toList(),
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
        status: json['status'],
        uid: json['uid']
      );

  // chuyển sang json (đầy đủ)
  Map<String, dynamic> toJson1() => {
        'id': id,
        'customerId': customerId,
        if (customer != null) 'customer': customer!.toJson(),
        'details': details.map((detail) => detail.toJson1()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'status': status,

        ///(dùng cho sắp xếp)
        'totalAmount': totalAmount, //tổng tiền
        'uid': uid
      };

  // chuyển sang json (đầy đủ)
  Map<String, dynamic> toJson2() => {
        'id': id,
        'customerId': customerId,
        'details': details.map((detail) => detail.toJson2()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'status': status,
        'uid': uid
      };
}
