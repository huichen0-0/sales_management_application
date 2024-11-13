import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///widgets hiển thị ở trang chức năng
class WidgetCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const WidgetCard({
    super.key,
    required this.items,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: items.map((item) {
                return TextButton(
                  onPressed: () {
                    context.go(item['link']);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'],
                        size: 32,
                        color: Colors.lightBlue,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'],
                        style: const TextStyle(color: Colors.lightBlue),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
///suppliers hiển thị ở trang nhà cung cấp
class SupplierCard extends StatelessWidget {
  final Map<String, dynamic> supplier;
  final Function(String id) onTap;

  SupplierCard({required this.supplier, required this.onTap});

  @override
  Widget build(BuildContext context) {
    //TODO: cần xử lý lấy giá trị từ db
    return Card(
      child: ListTile(
        leading: const Icon(Icons.perm_identity),
        /// ncc hoạt đông thì màu xanh, không thì xám
        iconColor: supplier['isActive'] ? Colors.blue : Colors.black54,
        textColor: supplier['isActive'] ? Colors.blue : Colors.black54,
        /// tên
        title: Text(
          supplier['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,

          ),
        ),
        /// SDT
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(supplier['phone']),
          ],
        ),
        /// tổng mua (tạm thời để hiển thị) TODO: cần lấy các giá trị ở tùy chọn hiển thị
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              supplier['amount'].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,

              ),
            ),
          ],
        ),
        onTap: () {
          onTap(supplier['id'].toString());
        },
      ),
    );
  }
}

