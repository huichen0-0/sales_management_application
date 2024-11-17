import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/controllers/customer_controller.dart';
import 'package:sales_management_application/models/Customer.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({super.key});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  bool isActive = true; // biến check trạng thái hoạt động
  Customer customerInfo = Customer(name: '', phoneNumber: '', amountSell: 0, amountReturn: 0);
  String sex = '';
  CustomerController _customerController = CustomerController();

  Future<void> fetchCustomerDetails(String id) async {
    await _customerController.getCustomerInfo(id);
    setState(() {
      customerInfo = _customerController.customerDetail;

      if (customerInfo.gender == 1) {
        sex = 'Nam';
      } else if (customerInfo.gender == 2) {
        sex = 'Nữ';
      } else if (customerInfo.gender == 3) {
        sex = 'Khác';
      } else {
        sex = '';
      }

      isActive = customerInfo.isActivated == 1 ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy ID khách hàng từ GoRouterState
    final customerId = GoRouterState.of(context).pathParameters['id']!;
    fetchCustomerDetails(customerId);

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
                    '/customers/${customerInfo.id}/edit');
              },
              icon: const Icon(Icons.edit),
            ),

            ///nút xóa
            IconButton(
              onPressed: () {
                _showDeleteCustomerDialog(customerInfo.id);
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
                    customerInfo.name,
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
                      customerInfo.phoneNumber,
                      style: TextStyle(
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
                ListTile(
                  title: const Text('Công nợ'),
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
                    customerInfo.address ?? '',
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
                    customerInfo.email ?? '',
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
                    customerInfo.note ?? '',
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
                    value: isActive,
                    onChanged: (bool value) {
                      _showConfirmationDialog(customerInfo.id, value);
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
                    SnackBar(
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
                _customerController
                    .changeCustomerActivated(customerId, newValue)
                    .then((_) {
                  // Cập nhật thành công
                  Navigator.of(context).pop(); // Đóng hộp thoại
                  // Tải lại thông tin trạng thái khách hàng
                  setState(() {
                    isActive = newValue;
                  });
                }).catchError((error) {
                  // Xử lý lỗi
                  print('Lỗi: $error');
                  Navigator.of(context)
                      .pop(); // Đóng hộp thoại mà không thay đổi gì
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Lỗi khi chuyển đổi trạng thái khách hàng, vui lòng thử lại sau!')),
                  );
                });
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }
}
