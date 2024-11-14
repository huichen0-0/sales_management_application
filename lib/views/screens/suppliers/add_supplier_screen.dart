import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_form.dart';
import '../../widgets/custom_form_fields.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  // Tạo GlobalKey để quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();

  // Các TextEditingController để điều khiển giá trị của các trường nhập
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController supplierCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Thêm nhà cung cấp'),
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
  /// hàm hiển thị thông báo sau khi submit và TODO: chuyển về trang suppliers/:id trước đó
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Đặt thời gian chuyển hướng sau 2 giây
        Future.delayed(const Duration(seconds: 2), () {
          context.go('/suppliers');
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
                'Thêm nhà cung cấp thành công!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
