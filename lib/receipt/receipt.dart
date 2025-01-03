import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/receipt/receipt_detail.dart';

import '../payment/payment.dart';

abstract class Receipt {
  // Hóa đơn
  String id;
  String partnerId; // Mã đối tác
  List<ReceiptDetail> details; //Danh sách chi tiết phiếu
  List<Payment> payments; //lịch sử thanh toán
  DateTime createdAt; // Ngày tạo
  int status; // trạng thái
  String uid;

  Receipt({
    required this.id,
    required this.partnerId,
    required this.payments,
    required this.status,
    required this.createdAt,
    required this.details,
    required this.uid
  });

  /// Các phương thức chung
  // Tổng số lượng
  num get totalQuantity {
    return details.fold(0, (sum, detail) => sum + detail.quantity);
  }

  //tổng giá trị nhập
  num get totalImportValue {
    return details.fold(0, (sum, detail) => sum + detail.capitalValue);
  }

  //tổng giá trị bán
  num get totalSaleValue {
    return details.fold(0, (sum, detail) => sum + detail.saleValue);
  }

  //tổng đã trả
  num get amountPaid {
    return payments.fold(0, (sum, payment) => sum + payment.amount);
  }

  //tổng còn nợ ncc
  num get importDue {
    return totalImportValue - amountPaid;
  }

  //tổng kh còn nợ
  num get saleDue {
    return totalSaleValue - amountPaid;
  }

  num getAttributeValue(String attribute) {
    switch (attribute) {
      //Tổng tiền hàng nhập
      case AppAttribute.totalCapitalValue:
        return totalImportValue;
      //Tổng tiền hàng bán
      case AppAttribute.totalSaleValue:
        return totalSaleValue;
      //khách nợ
      case AppAttribute.saleDue:
        return saleDue;
      // nợ NCC
      case AppAttribute.importDue:
        return importDue;
      //Đã thanh toán
      case AppAttribute.totalPaid:
        return amountPaid;
      default:
        throw ArgumentError('Unknown attribute: $attribute');
    }
  }
}
