import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/customers/customer_controller.dart';
import 'package:sales_management_application/customers/customer.dart';

class CustomerDetailScreen extends StatefulWidget {
  Customer customer;
  CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState(customer);
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  Customer customer = Customer.empty();
  String sex = '';
  final CustomerController _customerController = CustomerController();

  _CustomerDetailScreenState(this.customer);

  // Future<void> fetchCustomerDetails(String id) async {
  //   await _customerController.getCustomerInfo(id);
  //   setState(() {
  //     customer = _customerController.customerDetail;
  //
  //     if (customer.gender == 1) {
  //       sex = 'Nam';
  //     } else if (customer.gender == 2) {
  //       sex = 'Nữ';
  //     } else if (customer.gender == 3) {
  //       sex = 'Khác';
  //     } else {
  //       sex = '';
  //     }
  //
  //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // Lấy ID khách hàng từ GoRouterState
    final customerId = GoRouterState.of(context).pathParameters['id']!;
    // fetchCustomerDetails(customerId);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Chi tiết khách hàng'),
          actions: [
            ///nút sửa
            IconButton(
              onPressed: () {
                context.push(
                    '/customers/${customer.id}/edit');
              },
              icon: const Icon(Icons.edit),
            ),

            ///nút xóa
            IconButton(
              onPressed: () {
                _showDeleteCustomerDialog(customer.id);
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
                /// Tên khách hàng
                ListTile(
                  title: const Text(
                    'Tên khách hàng',
                  ),
                  trailing: Text(
                    customer.name,
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
                      customer.phoneNumber,
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

                /// Giới tính
                ListTile(
                  title: const Text(
                    'Giới tính',
                  ),
                  trailing: Text(
                    sex,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),

                /// Lịch sử giao dịch và Công nợ TODO: xử lý xem chi tiết
                ListTile(
                  title: const Text('Lịch sử giao dịch'),
                  trailing: TextButton.icon(
                    label: const Text(
                      '0',
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
                    onPressed: () {},
                  ),
                ),
                const Divider(),

                /// Địa chỉ
                ListTile(
                  title: const Text(
                    'Địa chỉ',
                  ),
                  trailing: Text(
                    customer.address ?? '',
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
                    customer.email ?? '',
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
                    customer.note ?? '',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),

                /// trạng thái hoạt động TODO: xử lý bật tắt hoạt động (DONE)
                ListTile(
                  title: const Text(
                    'Trạng thái hoạt động',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Switch(
                    value: customer.status == 1 ? true : false,
                    onChanged: (bool value) {
                      _showConfirmationDialog(customer.id, value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  /// Hàm hiển thị hộp thoại xác nhận xóa khách hàng
  void _showDeleteCustomerDialog(String customerId) {
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
                'Bạn chắc chắn muốn xóa khách hàng này?',
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
              onPressed: () async {
                //TODO: Thực hiện thao tác xóa (DONE)
                if (await _customerController.deleteCustomer(customerId)) {
                  //Xóa thành công
                  Navigator.of(context).popUntil((route) => route.settings.name == '/customers');
                } else {
                  //Xóa thất bại
                  Navigator.of(context)
                      .pop(); // Đóng hộp thoại mà không thay đổi gì
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Lỗi khi xóa khách hàng, vui lòng thử lại sau!')),
                  );
                }
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }

  /// Hàm hiển thị hộp thoại xác nhận khi thay đổi trạng thái
  void _showConfirmationDialog(String customerId, bool newValue) {
    // Nội dung thông báo tùy thuộc vào trạng thái mới
    String dialogMessage = newValue
        ? 'Bật hoạt động của khách hàng này?'
        : 'Tắt hoạt động của khách hàng này?';

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

            /// Nút Đồng ý (thay đổi trạng thái) TODO: cập nhật trạng thái trong db (DONE)
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.green,
                size: 35,
              ),
              onPressed: () {
                setState(() {
                  // Cập nhật trạng thái dựa trên lựa chọn của người dùng
                  customer.status = customer.status == 1 ? 0 : 1;
                  _customerController.updateActive(customerId, customer.status);
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
