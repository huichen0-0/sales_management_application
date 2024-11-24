import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InventoryNoteCard extends StatelessWidget {
  final Map<String, dynamic> inventoryNote;
  final Function(String id) onTap;

  const InventoryNoteCard(
      {super.key, required this.inventoryNote, required this.onTap});

  @override
  Widget build(BuildContext context) {
    //danh sách sản phẩm được kiểm
    List products = inventoryNote['products'];
    // Tính tổng lương sản phẩm
    num totalCheckedQuantity = products
        .map((product) => product['checked_quantity'] as num)
        .reduce((sum, element) => sum + element);
    // format thơì gian tạo
    String createdAt = DateFormat('HH:mm').format(inventoryNote['created_at']);

    return Card(
      child: ListTile(
        leading: Text(createdAt),
        title: Text(
          '${products.length} mặt hàng - Số lượng: $totalCheckedQuantity',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        trailing: Text(
          inventoryNote['status'], // Hiển thị trạng thái trực tiếp
          style: TextStyle(
            color: inventoryNote['status'] == 'Đã cân bằng'
                ? Colors.blue
                : inventoryNote['status'] == 'Phiếu tạm'
                  ? Colors.orange
                  : Colors.grey, // Thay đổi màu sắc của văn bản
          ),
        ),
        subtitle: Text(
          products
              .map((product) =>
                  '${product["name"]} x${product["checked_quantity"]}')
              .join(', '),
          style: const TextStyle(
            fontSize: 10,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        onTap: () {},
      ),
    );
  }
}
