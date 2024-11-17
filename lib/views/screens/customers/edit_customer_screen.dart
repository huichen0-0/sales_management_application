import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/views/widgets/custom_sheet.dart';

import '../../widgets/custom_form.dart';
import '../../widgets/custom_form_fields.dart';

class EditCustomerScreen extends StatefulWidget {
  const EditCustomerScreen({super.key});

  @override
  _EditCustomerScreenState createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  // Tạo GlobalKey để quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();

  // Các TextEditingController để điều khiển giá trị của các trường nhập
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController customerCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Giả sử các giá trị ban đầu của khách hàng
    nameController.text = 'KH'; // Tên khách hàng
    phoneController.text = '0123456789'; // Số điện thoại
    sexController.text = 'Nam'; //Giới tính
    customerCodeController.text = 'KH000001'; // Mã khách hàng
    addressController.text = '123 Đường ABC, Quận 1, TP.HCM'; // Địa chỉ
    emailController.text = 'kh@example.com'; // Email
    notesController.text = 'KH vip'; //ghi chú
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Chỉnh sửa thông tin khách hàng'),
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
                onSubmit: (){
                  _showSuccessDialog(context);
                },
                submitBtn: 'Lưu',
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// hàm hiển thị thông báo sau khi submit và TODO: chuyển về trang customers/:id trước đó
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Đặt thời gian chuyển hướng sau 2 giây
        Future.delayed(const Duration(seconds: 2), () {
          context.go('/customers');
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
                'Sửa thông tin thành công!',
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
