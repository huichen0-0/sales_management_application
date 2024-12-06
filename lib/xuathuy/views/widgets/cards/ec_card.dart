import 'package:flutter/material.dart';
import 'package:sales_management_application/xuathuy/models/ec_receipt.dart';
import 'package:sales_management_application/xuathuy/views/helper/helper.dart';

class ExportCancellationReceiptCard extends StatelessWidget {
  final ExportCancellationReceipt receipt;
  final Function(String id) onTap;

  const ExportCancellationReceiptCard(
      {super.key, required this.receipt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final products = receipt.products;
    final totalCancelledQuantity = receipt.totalCancelledQuantity;
    final createdAt = Helper.formatTime(receipt.createdAt ?? DateTime.now());
    final status = Helper.getStatusReceipt(receipt.status!);
    final totalCancelledValue =
        Helper.formatCurrency(receipt.totalCancelledValue);

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
                color: receipt.status == 3
                    ? Colors.green
                    : receipt.status == 1
                        ? Colors.orange
                        : Colors.red, // Thay đổi màu sắc của văn bản
              ),
            ),
          ],
        ),
        subtitle: Text(
          products
              .map((item) => '${item.product.name!} x${item.cancelledQuantity}')
              .join(', '),
          style: const TextStyle(
            fontSize: 10,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        onTap: () {
          onTap(receipt.id.toString());
        },
      ),
    );
  }
}
