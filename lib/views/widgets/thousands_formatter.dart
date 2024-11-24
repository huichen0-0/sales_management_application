import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,###");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Nếu giá trị rỗng, trả về như cũ
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Loại bỏ dấu phẩy và các ký tự không phải số để xử lý
    final String numericString = newValue.text.replaceAll(',', '');

    // Chuyển đổi chuỗi thành số để định dạng lại
    final int? value = int.tryParse(numericString);
    if (value == null) {
      return oldValue; // Nếu không phải số, giữ giá trị cũ
    }

    // Định dạng lại giá trị với dấu phân cách hàng nghìn
    final String formatted = _formatter.format(value);

    // Tính toán lại vị trí con trỏ
    final int newOffset =
        newValue.selection.baseOffset + (formatted.length - numericString.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}