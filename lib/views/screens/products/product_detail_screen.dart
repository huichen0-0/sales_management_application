import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isActive =
  true; // biến check trạng thái hoạt động TODO: lấy từ thuộc tính của ncc
  ///fake dữ liệu
  final Map<String, dynamic> product = {
    'id': 1,
    'name': 'ABC1',
    'selling_price': 2000000,
    'capital_price': 1000000,
    'quantity': 400,
    'unit': 'Kg',
    'minLimit': 10,
    'maxLimit': 1000,
    'barcode': '1314124212',
    'description': '100% thịt heo rừng',
    'notes': 'hàng vip',
    'isActive': true,
  };
  /// Hàm format số tiền
  String formatCurrency(num amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Chi tiết hàng hóa'),
        actions: [

          ///nút sửa
          IconButton(
            onPressed: () {
              context.push('/products/:id/edit');
            },
            icon: const Icon(Icons.edit),
          ),

          ///nút xóa
          IconButton(
            onPressed: () {
              _showDeleteProductDialog();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Tên hàng hóa
              ListTile(
                leading: const Icon(
                  Icons.image,
                  size: 40,
                ),
                title: Text(
                  product['name'],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                trailing:
                Text(
                  'Đơn vị: ${product['unit']}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
              const Divider(),
              /// Mã vạch
              ListTile(
                title: const Text(
                  'Mã vạch',
                ),
                trailing: Text(
                  product['barcode'],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  AppDisplay.sellingPrice,
                ),
                trailing: Text(
                  formatCurrency(product['selling_price']),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  AppDisplay.capitalPrice,
                ),
                trailing: Text(
                  formatCurrency(product['capital_price']),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),

              /// Tồn kho
              ListTile(
                title: const Text('Tồn kho'),
                trailing: Text(
                    product['quantity'].toString(),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Định mức tồn',
                ),
                trailing: Text(
                  '${product['minLimit']} - ${product['maxLimit']}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),

              /// Ghi chú
              ListTile(
                title: const Text(
                  'Ghi chú',
                ),
                trailing: Text(
                  product['notes'],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),

              /// trạng thái hoạt động TODO: xử lý bật tắt hoạt động
              ListTile(
                title: const Text(
                  'Trạng thái kinh doanh',
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Switch(
                  value: product['isActive'],
                  onChanged: (bool value) {
                    _showConfirmationDialog(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hàm hiển thị hộp thoại xác nhận xóa hàng hóa
  void _showDeleteProductDialog() {
    // Hiển thị hộp thoại xác nhận
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                'Bạn chắc chắn muốn xóa hàng hóa này?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [

            /// Nút Hủy
            IconButton(
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 35,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Đóng hộp thoại mà không thay đổi gì
              },
            ),

            /// Nút Đồng ý
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.green,
                size: 35,
              ),
              onPressed: () {
                //TODO: thực hiện thao tác xóa
                context.go('/products');
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }

  /// Hàm hiển thị hộp thoại xác nhận khi thay đổi trạng thái
  void _showConfirmationDialog(bool newValue) {
    // Nội dung thông báo tùy thuộc vào trạng thái mới
    String dialogMessage = newValue
        ? 'Bật kinh doanh của hàng hóa này?'
        : 'Ngừng kinh doanh của hàng hóa này?';

    // Hiển thị hộp thoại xác nhận
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                dialogMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [

            /// Nút Hủy (không thay đổi trạng thái)
            IconButton(
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 35,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Đóng hộp thoại mà không thay đổi gì
              },
            ),

            /// Nút Đồng ý (thay đổi trạng thái) TODO: cập nhật trạng thái trong db
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.green,
                size: 35,
              ),
              onPressed: () {
                setState(() {
                  // Cập nhật trạng thái dựa trên lựa chọn của người dùng
                  isActive = newValue;
                });
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }
}
