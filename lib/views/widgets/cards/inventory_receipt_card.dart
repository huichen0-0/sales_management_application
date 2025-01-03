import 'package:flutter/material.dart';

import '../../../helper/helper.dart';
import '../../../inventory_check/inventory_check_receipt.dart';

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
          '${receipt.details.length} mặt hàng - Số lượng: $totalCheckedQuantity',
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
          receipt.details
              .map((detail) => '${detail.product!.name} x${detail.matchedQuantity}')
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
