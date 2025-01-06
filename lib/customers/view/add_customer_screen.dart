import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/customers/model/customer.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';
import '../../views/widgets/dialogs/confirmation_dialog.dart';
import '../../views/widgets/forms/custom_form.dart';
import '../../views/widgets/forms/custom_form_fields.dart';
import '../controller/customer_controller.dart';

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
                  final newCustomer = _customerController.getNewCustomer(name, phoneNumber, sex, address, email, note);
                  //Thêm khách hàng
                  _addCustomer(newCustomer);
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

  void _addCustomer(Customer newCustomer) {
    ConfirmationDialog.show(
      context: context,
      title: 'Thêm khách hàng',
      content: 'Bạn có chắc muốn thêm khách hàng này không?',
      onConfirm: () {
        _customerController.addCustomer(newCustomer);
        context.pop();
        _showSnackBar('Thêm khách hàng thành công!', Colors.green);
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
