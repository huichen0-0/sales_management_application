import 'package:flutter/material.dart';
import 'package:sales_management_application/config/constants.dart';

class ConfirmationDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text(AppString.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                onConfirm(); // Gọi hàm xử lý khi xác nhận
              },
              child: const Text(AppString.confirm),
            ),
          ],
        );
      },
    );
  }
}
