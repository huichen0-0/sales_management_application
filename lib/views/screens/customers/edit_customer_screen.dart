import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';
import 'package:sales_management_application/controllers/customer_controller.dart';
import 'package:sales_management_application/models/Customer.dart';

import '../../widgets/forms/custom_form.dart';
import '../../widgets/forms/custom_form_fields.dart';

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
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final CustomerController _customerController = CustomerController();
  bool _isLoading = true; // Biến để theo dõi trạng thái loading
  Customer _customer = Customer(name: '', phoneNumber: '', amountSell: 0, amountReturn: 0);

  Future<void> _loadCustomerInfo() async {
    String customerId = GoRouterState.of(context).pathParameters['id']!;
    await _customerController.getCustomerInfo(customerId);
    
    setState(() {
      _customer = _customerController.customerDetail;
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
      _isLoading = false; // Đặt trạng thái loading là false
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra trạng thái loading
    if (_isLoading) {
      _loadCustomerInfo();
    }

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
                onSubmit: () async {
                  if(await _customerController.editCustomerInfo(
                    _customer.id,
                    nameController.text,
                    phoneController.text,
                    sexController.text,
                    addressController.text,
                    emailController.text,
                    notesController.text
                  )){
                    //Sửa thành công
                    _showSuccessDialog(context);
                  } else {
                    //Sửa thất bại
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi sửa thông tin khách hàng, vui lòng thử lại sau!')),
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
  /// hàm hiển thị thông báo sau khi submit và TODO: chuyển về trang /customers (DONE)
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Đặt thời gian chuyển hướng sau 2 giây
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).popUntil((route) => route.settings.name == '/customers');
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