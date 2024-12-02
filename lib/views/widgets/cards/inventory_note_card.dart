import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/models/inventory_note.dart';
import 'package:sales_management_application/models/inventory_note_detail.dart';

class InventoryNoteCard extends StatelessWidget {
  final InventoryNote inventoryNote;
  final Function(String id) onTap;

  const InventoryNoteCard(
      {super.key, required this.inventoryNote, required this.onTap});

  @override
  Widget build(BuildContext context) {
    //danh sách sản phẩm được kiểm
    List<InventoryNoteDetail> products = inventoryNote.products;
    // Tính tổng lương sản phẩm đã kiểm
    num totalCheckedQuantity = inventoryNote.totalMatchedQuantity;
    // format thơì gian tạo
    String createdAt = DateFormat('HH:mm').format(inventoryNote.createdAt!);

    return Card(
      child: ListTile(
        leading: Text(createdAt),
        title: Text(
          '${products.length} mặt hàng - Số lượng: $totalCheckedQuantity',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        trailing: Text(
          inventoryNote.getStatusLabel(), // Hiển thị trạng thái trực tiếp
          style: TextStyle(
            color: inventoryNote.status == 2
                ? Colors.blue
                : inventoryNote.status == 1
                  ? Colors.orange
                  : Colors.grey, // Thay đổi màu sắc của văn bản
          ),
        ),
        subtitle: Text(
          products
              .map((item) =>
                  '${item.product.name} x${item.matchedQuantity}')
              .join(', '),
          style: const TextStyle(
            fontSize: 10,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        onTap: () {
          onTap(inventoryNote.id.toString());
        },
      ),
    );
  }
}
