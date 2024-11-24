import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/repository/FirebaseService.dart';
import 'package:sales_management_application/views/screens/suppliers/supplier_detail_screen.dart';

import '../../../models/Supplier.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_form_fields.dart';

class EditSupplierScreen extends StatefulWidget {
  const EditSupplierScreen({required this.id, required this.supplier});
  final Supplier supplier;
  final String id;

  @override
  _EditSupplierScreenState createState() => _EditSupplierScreenState(id: this.id, supplier: this.supplier);
}

class _EditSupplierScreenState extends State<EditSupplierScreen> {
  // Tạo GlobalKey để quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();
  Supplier supplier;
  String id;

  _EditSupplierScreenState({required this.id, required this.supplier});

  // Các TextEditingController để điều khiển giá trị của các trường nhập
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController supplierCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Giả sử các giá trị ban đầu của nhà cung cấp
    nameController.text = supplier.name; // Tên nhà cung cấp
    phoneController.text = supplier.phone; // Số điện thoại
    supplierCodeController.text = supplier.id.toString(); // Mã nhà cung cấp
    addressController.text = supplier.address; // Địa chỉ
    emailController.text = supplier.email; // Email
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Chỉnh sửa thông tin nhà cung cấp'),
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
                  Supplier updateSupplier = this.supplier;
                  updateSupplier.name = nameController.text;
                  updateSupplier.phone = phoneController.text;
                  updateSupplier.address = addressController.text;
                  updateSupplier.email = emailController.text;
                  updateSupplier.note = notesController.text;
                  _updateSupplierInfo(id, updateSupplier);
                  this.supplier = updateSupplier;
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

  void _updateSupplierInfo(String id, Supplier supplier) async {
    FirebaseService firebaseService = new FirebaseService();
    firebaseService.updateDate('Suppliers',  id, supplier.toJson());
  }

  /// hàm hiển thị thông báo sau khi submit và TODO: chuyển về trang suppliers/:id trước đó
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Đặt thời gian chuyển hướng sau 2 giây
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupplierDetailScreen(id: id, supplier: supplier),
            ),
          );
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
}
