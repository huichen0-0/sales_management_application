import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/suppliers/supplier.dart';
import 'package:sales_management_application/suppliers/supplier_service.dart';

import '../views/widgets/dialogs/confirmation_dialog.dart';
import '../views/widgets/forms/custom_form.dart';
import '../views/widgets/forms/custom_form_fields.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  // Tạo GlobalKey để quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();
  SupplierService supplierService = SupplierService();

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
                  Supplier supplier = Supplier.empty();
                  supplier.name = nameController.text;
                  supplier.phone = phoneController.text.toString();
                  supplier.address = addressController.text;
                  supplier.email = emailController.text;
                  supplier.note = notesController.text;
                  _addSupplier(supplier);
                },
                submitBtn: 'Lưu',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addSupplier(Supplier supplier) {
    ConfirmationDialog.show(
      context: context,
      title: 'Thêm nhà cung cấp',
      content: 'Bạn có chắc muốn thêm nhà cung cấp này không?',
      onConfirm: () {
        supplierService.insertSupplier(supplier);
        context.pop();
        _showSnackBar('Thêm nhà cung cấp thành công!', Colors.green);
      },
    );
  }
}
