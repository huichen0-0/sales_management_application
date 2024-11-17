import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/controllers/customer_controller.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';

import '../../widgets/forms/custom_form.dart';
import '../../widgets/forms/custom_form_fields.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  // Tạo GlobalKey để quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();

  // Thêm biến CustomerController
  final CustomerController _customerController = CustomerController();

  // Các TextEditingController để điều khiển giá trị của các trường nhập
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Thêm khách hàng'),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context); // Quay lại trang trước đó
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomForm(
                formKey: _formKey,
                fields: [
                  const SizedBox(height: 16),
                  NameField(controller: nameController,),
                  const SizedBox(height: 16),
                  PhoneNumberField(controller: phoneController,),
                  const SizedBox(height: 16),
                  ///giới tính
                  TextFormField(
                    readOnly: true, // Đặt readOnly để không cho nhập mà chỉ chọn
                    decoration: const InputDecoration(
                      labelText: 'Giới tính',
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 14,
                        color: Colors.blue,
                      ), // Mũi tên chỉ xuống
                      border: OutlineInputBorder(), // Đường viền cho TextFormField
                    ),
                    controller: sexController, // Hiển thị giới tính đã chọn
                    onTap: () => _showSexOptions(context), // Gọi hàm khi người dùng nhấn vào trường
                  ),
                  const SizedBox(height: 16),
                  InputField(controller: addressController, label: 'Địa chỉ'),
                  const SizedBox(height: 16),
                  InputField(controller: emailController, label: 'Email'),
                  const SizedBox(height: 16),
                  InputField(controller: notesController, label: 'Ghi chú'),
                ],
                onSubmit: () async {
                  //Lấy dữ liệu từ text
                  String name = nameController.text;
                  String phoneNumber = phoneController.text;
                  String sex = sexController.text;
                  String address = addressController.text;
                  String email = emailController.text;
                  String note = notesController.text;

                  //Thêm khách hàng
                  if(await _customerController.addCustomer(name, phoneNumber, sex, address, email, note)){
                    //Thêm khách hàng thành công
                    _showSuccessDialog(context);
                  } else {
                    //Thêm khách hàng thất bại
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi thêm khách hàng, vui lòng thử lại sau!')),
                    );
                  }
                },
                submitBtn: 'Lưu',
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// hàm hiển thị thông báo sau khi submit và chuyển về trang /customers
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Đặt thời gian chuyển hướng sau 2 giây
        Future.delayed(const Duration(seconds: 2), () {
          context.pop('/customers');
          context.pop('/customers');
        });

        return const AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                'Thành công',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Thêm khách hàng thành công!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
  /// Hiển thị Bottom Sheet cho tùy chọn giới tính
  void _showSexOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SexBottomSheet(
          selectedSex: sexController.text,
          onSelectSex: (option) {
            setState(() {
              sexController.text = option;
            });
          },
        );
      },
    );
  }
}
