import 'package:sales_management_application/config/constants.dart';

import '/models/receipt_detail.dart';
import '../payment/model/payment.dart';

abstract class Receipt {
  // Hóa đơn
  String id;
  String partnerId; // Mã đối tác
  List<ReceiptDetail> details;
  List<Payment> payments; //lịch sử thanh toán
  DateTime createdAt; // Ngày tạo
  int status; // trạng thái

  Receipt({
    required this.id,
    required this.partnerId,
    required this.payments,
    required this.status,
    required this.createdAt,
    required this.details,
  });

  /// Các phương thức chung
  // Tổng số lượng
  num get totalQuantity {
    return details.fold(0, (sum, detail) => sum + detail.quantity);
  }

  //tổng giá trị nhập
  num get totalValue {
    return details.fold(0, (sum, detail) => sum + detail.value);
  }

  //tổng đã trả
  num get amountPaid {
    return payments.fold(0, (sum, payment) => sum + payment.amount);
  }

  //tổng còn nợ
  num get amountDue {
    return totalValue - amountPaid;
  }

  num getAttributeValue(String attribute) {
    switch (attribute) {
      case AppAttribute.totalValue:
        return totalValue;
      case AppAttribute.totalDue:
        return amountDue;
      case AppAttribute.totalPaid:
        return amountPaid;
      default:
        throw ArgumentError('Unknown attribute: $attribute');
    }
  }
}
