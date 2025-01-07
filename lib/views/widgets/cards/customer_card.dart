import 'package:flutter/material.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/suppliers/supplier-controller.dart';
import '../../../customers/model/customer.dart';
import '../../../helper/helper.dart';
import '../../../products/product.dart';
import '../../../suppliers/supplier.dart';


///widgets hiển thị ở trang chức năng
class WidgetCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;

  WidgetCard({
    super.key,
    required this.items,
    required this.title,
    this.color,
    this.margin,
    this.decoration,
    this.padding
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Theme.of(context).cardColor,
      margin: margin ?? EdgeInsets.zero,
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
  final Supplier supplier;
  final Function(String id) onTap;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String selectedDisplay;
  String total = '';
  SupplierController supplierController = SupplierController();

   SupplierCard({super.key, required this.supplier, required this.onTap, required this.fromDate, required this.toDate, required this.selectedDisplay});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.perm_identity),

        /// ncc hoạt đông thì màu xanh, không thì xám
        iconColor: supplier.isActive ? Colors.blue : Colors.black54,
        textColor: supplier.isActive ? Colors.blue : Colors.black54,
        /// tên
        title: Text(
          supplier.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        /// SDT
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(supplier.phone),
          ],
        ),

        /// tổng mua (tạm thời để hiển thị) TODO: cần lấy các giá trị ở tùy chọn hiển thị
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Helper.formatCurrency(supplier.amount),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          //   FutureBuilder<String>(
          //     future: getTotal(), // Call your async function here
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Text(
          //           'Loading...',
          //           style: TextStyle(fontWeight: FontWeight.bold),
          //         );
          //       } else if (snapshot.hasError) {
          //         return const Text(
          //           'Error',
          //           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          //         );
          //       } else {
          //         total = snapshot.data!;
          //         return Text(
          //           snapshot.data ?? '',
          //           style: const TextStyle(fontWeight: FontWeight.bold),
          //         );
          //       }
          //     },
          //   ),
          ],
        ),
        onTap: () {
          onTap(supplier.id.toString());
        },
      ),
    );
  }

  Future<String> getTotal() async {
    if (selectedDisplay == AppString.allTime) {
      return supplier.amount.toString();
    } else {
      return (await supplierController.getTotalAmount(fromDate!, toDate!, selectedDisplay, supplier)).toString();
    }
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
    bool isActive = customer.status == 1 ? true : false;
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
              Helper.formatCurrency(amount),
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
  final Product product;
  final Function(String id) onTap;
  final String selectedDisplay;

  const ProductCard({super.key, required this.product, required this.onTap, required this.selectedDisplay});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.image, size: 30,),
        /// tên
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        /// giá bán (tạm thời để hiển thị) TODO: cần lấy các giá trị ở tùy chọn hiển thị
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
        Helper.formatCurrency(selectedDisplay == 'Giá bán' ? product.sellingPrice : product.capitalPrice),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5,),
            Text(
              'Tồn: ${Helper.formatCurrency(product.quantity)} ${product.unit}',
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
        onTap: () {
          onTap(product.id.toString());
        },
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////
