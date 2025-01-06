import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/customers/view/customer_detail_screen.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';
import '../../views/widgets/dialogs/confirmation_dialog.dart';
import '../../views/widgets/forms/custom_form.dart';
import '../../views/widgets/forms/custom_form_fields.dart';
import '../controller/customer_controller.dart';
import '../model/customer.dart';

class EditCustomerScreen extends StatefulWidget {
  Customer customer;
  EditCustomerScreen({super.key, required this.customer});

  @override
  _EditCustomerScreenState createState() => _EditCustomerScreenState(customer);
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  // Tạo GlobalKey để quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();

  // Các TextEditingController để điều khiển giá trị của các trường nhập
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final CustomerController _customerController = CustomerController();
  Customer _customer = Customer.empty();
  _EditCustomerScreenState(Customer customer) {
    _customer = customer;
    String sex = '';
    if(_customer.gender == 1){
      sex = 'Nam';
    } else if (_customer.gender == 2){
      sex = 'Nữ';
    } else if (_customer.gender == 3){
      sex = 'Khác';
    } else {
      sex = '';
    }
    nameController.text = _customer.name;
    phoneController.text = _customer.phoneNumber;
    sexController.text = sex;
    addressController.text = _customer.address!;
    emailController.text = _customer.email!;
    notesController.text = _customer.note!;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Chỉnh sửa thông tin khách hàng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước đó
          },
        ),
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
                onSubmit: () {
                  Customer updateCustomer = _customer;
                  updateCustomer.name = nameController.text;
                  updateCustomer.address = addressController.text;
                  updateCustomer.email = emailController.text;
                  updateCustomer.note = notesController.text;
                  updateCustomer.phoneNumber = phoneController.text;
                  _editCustomer(updateCustomer);
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

  void _editCustomer(Customer updateCustomer) {
    ConfirmationDialog.show(
      context: context,
      title: 'Sửa thông tin khách hàng',
      content: 'Bạn có chắc muốn lưu lại thông tin không?',
      onConfirm: () {
        _customerController.editCustomerInfo(_customer);
        context.pop();
        _showSnackBar('Sửa thông tin khách hàng thành công!', Colors.green);
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