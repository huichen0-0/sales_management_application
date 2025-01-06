import 'package:flutter/material.dart';
import '../../../config/constants.dart';
import '../../../ec/export_receipt.dart';
import '../../../helper/helper.dart';

class ExportCancellationReceiptCard extends StatelessWidget {
  final ExportCancellationReceipt receipt;
  final Function(String id) onTap;

  const ExportCancellationReceiptCard(
      {super.key, required this.receipt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final products = receipt.details;
    final totalCancelledQuantity = receipt.totalCancelledQuantity;
    final createdAt = Helper.formatTime(receipt.createdAt ?? DateTime.now());
    final status = Helper.getStatusReceipt(receipt.status);
    final totalCancelledValue = Helper.formatCurrency(receipt.totalCancelledValue);

    // Lấy chi tiết sản phẩm đầu tiên và số lượng sản phẩm còn lại
    final firstDetail = products.isNotEmpty ? products.first : null;
    final additionalItems = products.length > AppNum.one ? products.length - AppNum.one : AppNum.zero;
    return Card(
      child: ListTile(
        leading: Text(createdAt),
        title: Text(
          '${products.length} mặt hàng - Số lượng: $totalCancelledQuantity',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              totalCancelledValue,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              status, // Hiển thị trạng thái
              style: TextStyle(
                color: receipt.status == 2
                    ? Colors.green
                    : receipt.status == 1
                        ? Colors.orange
                        : Colors.red, // Thay đổi màu sắc của văn bản
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị chi tiết sản phẩm đầu tiên
            if (firstDetail != null)
              Text(
                '${firstDetail.product!.name} x${firstDetail.cancelledQuantity} ${firstDetail.product!.unit}',
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
          onTap(receipt.id);
        },
      ),
    );
  }
}
