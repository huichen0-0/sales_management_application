import 'package:flutter/material.dart';
import 'package:sales_management_application/kiemkho/models/ic_receipt.dart';
import 'package:sales_management_application/views/helper/helper.dart';

class InventoryCheckReceiptCard extends StatelessWidget {
  final InventoryCheckReceipt receipt;
  final Function(String id) onTap;

  const InventoryCheckReceiptCard(
      {super.key, required this.receipt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // format tổng lương sản phẩm đã kiểm
    final totalCheckedQuantity = Helper.formatCurrency(receipt.totalMatchedQuantity);
    // format thơì gian tạo
    final createdAt =
        Helper.formatTime(receipt.createdAt);
    final status = Helper.getStatusReceipt(receipt.status!);

    return Card(
      child: ListTile(
        leading: Text(createdAt),
        title: Text(
          '${receipt.products.length} mặt hàng - Số lượng: $totalCheckedQuantity',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        trailing: Text(
          status, // Hiển thị trạng thái
          style: TextStyle(
            color: receipt.status == 2
                ? Colors.green
                : receipt.status == 1
                    ? Colors.orange
                    : Colors.red, // Thay đổi màu sắc của văn bản
          ),
        ),
        subtitle: Text(
          receipt.products
              .map((detail) => '${detail.product.name} x${detail.matchedQuantity}')
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
