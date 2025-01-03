import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';

class Helper {
  static String formatCurrency(num amount) {
    final formatter = NumberFormat('###,###,###,###');
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return formatter.format(date);
  }

  static String formatTime(DateTime date) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }

  // Hàm lấy tên các trạng thái phiếu
  static String getStatusReceipt(int status) {
    const Map<int, String> statusReceipts = {
      2: AppString.completed,
      1: AppString.temporary,
      0: AppString.canceled,
    };
    return statusReceipts[status] ?? AppString.unknown;
  }

  static List<String> paymentMethods() =>
      [AppString.cash, AppString.bankTransfer, AppString.creditCard];

  //Chuyển chuỗi sang số (do format thành chuỗi số có dấu ,)
  static num? stringToNum(String value) {
    // Loại bỏ dấu phẩy và các ký tự không phải số để xử lý
    final String numericString = value.replaceAll(',', '');

    // Chuyển đổi chuỗi thành số để định dạng lại
    return num.tryParse(numericString);
  }
//TODO: thừa, sửa trong model + bỏ hàm naày
  static String getAttribute(String value){
    switch (value) {
      //Tổng nợ NCC
      case AppString.totalImportDue:
        return AppAttribute.importDue;
        //Tổng khách nợ
      case AppString.totalSaleDue:
        return AppAttribute.saleDue;
        //Tổng tiền hàng bán
      case AppString.totalSaleValue:
        return AppAttribute.totalSaleValue;
    //Đã thanh toán
      case AppString.totalPaid:
        return AppAttribute.totalPaid;
        //tong tien hang nhập
      default:
        return AppAttribute.totalCapitalValue;
    }
  }
}
