import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/models/Customer.dart';

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
                  onPressed: item['action'],
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
////////////////////////////////////////////////////////////////////////////////

///suppliers hiển thị ở trang nhà cung cấp
class SupplierCard extends StatelessWidget {
  final Map<String, dynamic> supplier;
  final Function(String id) onTap;

  const SupplierCard({super.key, required this.supplier, required this.onTap});

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
////////////////////////////////////////////////////////////////////////////////

///customers hiển thị ở trang khach hang
class CustomerCard extends StatelessWidget {
  final Customer customer;
  final Function(String id) onTap;
  final num amount; // Biến truyền vào giá trị tổng bán hoặc tổng trả phụ thuộc vào tùy chọn

  const CustomerCard({super.key, required this.customer, required this.onTap, required this.amount});

  @override
  Widget build(BuildContext context) {
    //TODO: cần xử lý lấy giá trị từ db (DONE)
    bool isActive = customer.isActivated == 1 ? true : false;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.perm_identity),

        /// khách hàng hoạt đông thì màu xanh, không thì xám
        iconColor: isActive ? Colors.blue : Colors.black54,
        textColor: isActive ? Colors.blue : Colors.black54,

        /// tên
        title: Text(
          customer.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        /// SDT
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customer.phoneNumber),
          ],
        ),

        /// tổng mua (tạm thời để hiển thị) TODO: cần lấy các giá trị ở tùy chọn hiển thị (DONE)
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () {
          onTap(customer.id.toString());
        },
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

///products hiển thị ở trang hang hóa
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(String id) onTap;

  const ProductCard({super.key, required this.product, required this.onTap});
  /// Hàm format số tiền
  String formatCurrency(num amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }
  @override
  Widget build(BuildContext context) {
    //TODO: cần xử lý lấy giá trị từ db
    return Card(
      child: ListTile(
        leading: const Icon(Icons.image, size: 30,),
        /// tên
        title: Text(
          product['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        /// giá bán (tạm thời để hiển thị) TODO: cần lấy các giá trị ở tùy chọn hiển thị
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
        formatCurrency(product['price']),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5,),
            Text(
              'Tồn: ${formatCurrency(product['quantity'])} ${product['unit']}',
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
        onTap: () {
          onTap(product['id'].toString());
        },
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////
