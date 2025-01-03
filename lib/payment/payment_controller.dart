import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/payment/payment.dart';
import '../helper/helper.dart';
import '../receipt/receipt.dart';

class PaymentController {
  Receipt receipt;
  String paymentMethod;
  num amountPaid;
  Payment payment;

  PaymentController({required this.receipt})
      : paymentMethod = AppString.cash,
        amountPaid = AppNum.zero,
        payment = Payment.empty();

  /// Cập nhật phương thức thanh toán
  void updatePaymentMethod(String newMethod) {
    paymentMethod = newMethod;
  }

  /// Cập nhật số tiền người dùng nhập vào
  void updateAmountPaid(String value) {
    final amount = Helper.stringToNum(value) ?? 0;
    if (amount < AppNum.zero) {
      amountPaid = AppNum.zero;
    } else {
      amountPaid = amount;
    }
  }

  /// Xử lý logic Lưu tạm
  bool saveTemporary() {
    receipt.status = AppNum.one; // trạng thái Lưu tạm
    return true;
  }

  /// Xử lý logic Hoàn thành
  bool completePayment() {
    if (amountPaid <= 0) return false;
    payment = _createPayment();
    receipt.status = AppNum.two;  // trạng thái Hoàn thành
    receipt.payments.add(payment);
    return true;
  }

  /// Tạo Payment từ dữ liệu hiện tại
  Payment _createPayment() {
    Payment result = Payment.empty();
    result.createdAt = DateTime.now();
    result.method = paymentMethod;
    result.amount = amountPaid;
    return result;
  }
}
