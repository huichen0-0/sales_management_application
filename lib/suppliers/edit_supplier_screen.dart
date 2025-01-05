import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';
import 'package:sales_management_application/suppliers/supplier.dart';
import 'package:sales_management_application/suppliers/supplier_detail_screen.dart';
import '../views/widgets/dialogs/confirmation_dialog.dart';
import '../views/widgets/forms/custom_form.dart';
import '../views/widgets/forms/custom_form_fields.dart';

class EditSupplierScreen extends StatefulWidget {
  const EditSupplierScreen({super.key, required this.id, required this.supplier});
  final Supplier supplier;
  final String id;

  @override
  _EditSupplierScreenState createState() => _EditSupplierScreenState(id: id, supplier: supplier);
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
    notesController.text = supplier.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Chỉnh sửa thông tin nhà cung cấp'),
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
                  Supplier updateSupplier = supplier;
                  updateSupplier.name = nameController.text;
                  updateSupplier.phone = phoneController.text;
                  updateSupplier.address = addressController.text;
                  updateSupplier.email = emailController.text;
                  updateSupplier.note = notesController.text;
                  _editSupplier(updateSupplier);
                  // context.go('/suppliers/${updateSupplier.id}');
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
    FirebaseService firebaseService = FirebaseService();
    firebaseService.updateData('Suppliers',  id, supplier.toJson());
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

  void _editSupplier(Supplier updateSupplier) {
    ConfirmationDialog.show(
      context: context,
      title: 'Sửa hàng hóa',
      content: 'Bạn có chắc muốn lưu lại thông tin không?',
      onConfirm: () {
        _updateSupplierInfo(id, updateSupplier);
        context.pop(updateSupplier);
        _showSnackBar('Sửa hàng hóa thành công!', Colors.green);
      },
    );
  }
}
