import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/suppliers/supplier-controller.dart';
import 'package:sales_management_application/suppliers/supplier.dart';

class SupplierDetailScreen extends StatefulWidget {
  const SupplierDetailScreen({super.key, required this.id});
  final String id;

  @override
  State<SupplierDetailScreen> createState() => _SupplierDetailScreenState(id);
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen> {
  Supplier supplier = Supplier.empty();
  String id;
  SupplierController supplierController = SupplierController();

  _SupplierDetailScreenState(this.id);

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Chi tiết nhà cung cấp'),
          actions: [

            ///nút sửa
            IconButton(
              onPressed: () {
                context.push('/suppliers/$id/edit', extra: [id, supplier]);
              },
              icon: const Icon(Icons.edit),
            ),

            ///nút xóa
            IconButton(
              onPressed: () {
                _showDeleteSupplierDialog();
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: FutureBuilder<Supplier>(
          future: supplierController.getSupplierByKey(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data != null) {
              supplier = snapshot.data!;
            }
            return buildBody();
          },
        ),
      );
    } catch (e) {
      print(e.toString());
      return const Scaffold();
    }
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Tên nhà cung cấp
            ListTile(
              title: const Text(
                'Tên nhà cung cấp',
              ),
              trailing: Text(
                supplier.name,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),

            /// Điện thoại TODO: xử lý gọi khi click vào
            ListTile(
              title: const Text(
                'Số điện thoại',
              ),
              trailing: TextButton.icon(
                label: Text(
                  supplier.phone,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                icon: const Icon(
                  Icons.phone_enabled,
                  size: 14,
                  color: Colors.blue,
                ),
                iconAlignment: IconAlignment.end,
                onPressed: () {},
              ),
            ),
            const Divider(),

            /// Lịch sử giao dịch và Công nợ TODO: xử lý xem chi tiết
            ListTile(
              title: const Text('Lịch sử giao dịch'),
              trailing: TextButton.icon(
                label: const Text(
                  '',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.blue,
                ),
                iconAlignment: IconAlignment.end,
                onPressed: () {
                  context.push('/paymentHistory', extra: id);
                },
              ),
            ),
            // const Divider(),
            // ListTile(
            //   title: const Text('Công nợ'),
            //   trailing: TextButton.icon(
            //     label: const Text(
            //       '0',
            //       style: TextStyle(
            //           color: Colors.blue,
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold),
            //     ),
            //     icon: const Icon(
            //       Icons.arrow_forward_ios,
            //       size: 14,
            //       color: Colors.blue,
            //     ),
            //     iconAlignment: IconAlignment.end,
            //     onPressed: () {},
            //   ),
            // ),
            const Divider(),

            /// Địa chỉ
            ListTile(
              title: const Text(
                'Địa chỉ',
              ),
              trailing: Text(
                supplier.address,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),

            /// Email
            ListTile(
              title: const Text(
                'Email',
              ),
              trailing: Text(
                supplier.email,
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
                supplier.note,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),

            /// trạng thái hoạt động
            ListTile(
              title: const Text(
                'Trạng thái hoạt động',
                style: TextStyle(color: Colors.black),
              ),
              trailing: Switch(
                value: supplier.isActive,
                onChanged: (bool value) {
                  _showConfirmationDialog(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Hàm hiển thị hộp thoại xác nhận xóa nhà cung cấp
  void _showDeleteSupplierDialog() {
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
                'Bạn chắc chắn muốn xóa nhà cung cấp này?',
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
                supplierController.deleteSupplier(supplier);
            context.pop();

            context.pop();
            _showSnackBar('Xóa NCC thành công!', Colors.green);
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Hàm hiển thị hộp thoại xác nhận khi thay đổi trạng thái
  void _showConfirmationDialog(bool newValue) {
    // Nội dung thông báo tùy thuộc vào trạng thái mới
    String dialogMessage = newValue
        ? 'Bật hoạt động của nhà cung cấp này?'
        : 'Tắt hoạt động của nhà cung cấp này?';

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

            /// Nút Đồng ý (thay đổi trạng thái)
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.green,
                size: 35,
              ),
              onPressed: () {
                setState(() {
                  // Cập nhật trạng thái dựa trên lựa chọn của người dùng
                  supplierController.updateActive(supplier, !supplier.isActive);
                  supplier.isActive = !supplier.isActive;
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
