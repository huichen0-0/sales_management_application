import 'package:flutter/material.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';

import '../../../helper/helper.dart';
import '../../../invoice/invoice_receipt.dart';

class InvoiceReceiptCard extends StatelessWidget {
  final InvoiceReceipt receipt;
  final String displayValue;
  final Function(String id) onTap;
  TimeFilterService timeFilterService = TimeFilterService();
  DateTime? fromDate;
  DateTime? toDate;

  InvoiceReceiptCard(
      {super.key,
      required this.receipt,
      required this.onTap,
      required this.displayValue,
      required this.fromDate,
      required this.toDate,}
  );

  @override
  Widget build(BuildContext context) {
    final details = receipt.details;
    final totalQuantity = receipt.totalQuantity;
    final createdAt = Helper.formatTime(receipt.createdAt);
    final status = Helper.getStatusReceipt(receipt.status);
    final totalDisplayValue = Helper.formatCurrency(getTotalValue());

    // Lấy chi tiết sản phẩm đầu tiên và số lượng sản phẩm còn lại
    final firstDetail = details.isNotEmpty ? details.first : null;
    final additionalItems =
        details.length > AppNum.one ? details.length - AppNum.one : AppNum.zero;

    return Card(
      child: ListTile(
        leading: Text(createdAt),
        title: Text(
          receipt.customer!.name,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              totalDisplayValue,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              status, // Hiển thị trạng thái
              style: TextStyle(
                color: receipt.status == AppNum.two
                    ? Colors.green
                    : receipt.status == AppNum.one
                        ? Colors.orange
                        : Colors.red, // Thay đổi màu sắc của văn bản
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${details.length} mặt hàng - Số lượng: $totalQuantity',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // Hiển thị chi tiết sản phẩm đầu tiên
            if (firstDetail != null)
              Text(
                '${firstDetail.product!.name} x${firstDetail.quantity} ${firstDetail.product!.unit}',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            // Hiển thị số mặt hàng bổ sung nếu có
            if (additionalItems > AppNum.zero)
              Text(
                '+$additionalItems mặt hàng khác',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
        onTap: () {
          onTap(receipt.id.toString());
        },
      ),
    );
  }

  num getTotalValue() {
    if (displayValue == AppString.totalAmount) {
      return receipt.totalImportValue;
    }
    num totalPaid = 0;
    if (receipt.payments.isNotEmpty) {
      totalPaid += receipt.payments.fold(0, (sum, payment) =>
      timeFilterService.isTimeFilterd(payment.createdAt, fromDate, toDate) ? sum + payment.amount : sum + 0);
    }
    if (displayValue == AppString.totalPaid) {
      return totalPaid;
    }
    if (displayValue == AppString.totalImportDue) {
      num totalDue = receipt.totalImportValue - totalPaid;
      return totalDue;
    }
    return 0;
  }
}
