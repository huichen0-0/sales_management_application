import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/models/inventory_check_receipt.dart';
import 'package:sales_management_application/models/inventory_check_receipt_detail.dart';

class InventoryCheckReceiptCard extends StatelessWidget {
  final InventoryCheckReceipt inventoryCheckReceipt;
  final Function(String id) onTap;

  const InventoryCheckReceiptCard(
      {super.key, required this.inventoryCheckReceipt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    //danh sách sản phẩm được kiểm
    List<InventoryCheckReceiptDetail> products = inventoryCheckReceipt.products;
    // Tính tổng lương sản phẩm đã kiểm
    num totalCheckedQuantity = inventoryCheckReceipt.totalMatchedQuantity;
    // format thơì gian tạo
    String createdAt =
        DateFormat('HH:mm').format(inventoryCheckReceipt.createdAt);

    return Card(
      child: ListTile(
        leading: Text(createdAt),
        title: Text(
          '${products.length} mặt hàng - Số lượng: $totalCheckedQuantity',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        trailing: Text(
          inventoryCheckReceipt
              .getStatusLabel(), // Hiển thị trạng thái trực tiếp
          style: TextStyle(
            color: inventoryCheckReceipt.status == 2
                ? Colors.blue
                : inventoryCheckReceipt.status == 1
                    ? Colors.orange
                    : Colors.grey, // Thay đổi màu sắc của văn bản
          ),
        ),
        subtitle: Text(
          products
              .map((item) => '${item.product.name} x${item.matchedQuantity}')
              .join(', '),
          style: const TextStyle(
            fontSize: 10,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        onTap: () {
          onTap(inventoryCheckReceipt.id.toString());
        },
      ),
    );
  }
}
