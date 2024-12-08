import 'package:intl/intl.dart';

class Helper{
  static String formatCurrency(num amount) {
    final formatter = NumberFormat('#,###');
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
      3: 'Đã hoàn thành',
      2: 'Đã cân bằng',
      1: 'Phiếu tạm',
      0: 'Đã hủy',
    };
    return statusReceipts[status] ?? 'Không xác định';
  }
}
