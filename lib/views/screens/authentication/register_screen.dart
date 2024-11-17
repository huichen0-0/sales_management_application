import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sales_management_application/controllers/auth_controller.dart';

import '../../widgets/custom_form.dart';
import '../../widgets/custom_form_fields.dart';

class RegisterScreen extends StatefulWidget {

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Bổ sung Auth Controller
  // final AuthController _authController = AuthController(); 
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Tạo một thể hiện của AuthController
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/');
          },
        ),
        title: const Text('Tạo tài khoản miễn phí'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            margin: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Vui lòng nhập thông tin đăng ký'),
                const SizedBox(height: 16),
                /// form nhập SDT TODO: lấy SDT để xử lý và hiển thị ở sau
                CustomForm(
                  formKey: _formKey,
                  fields: [
                    /// nhap email
                    EmailField(controller: _emailController,),
                    const SizedBox(height: 16),
                    NameField(controller: _nameController,),
                    const SizedBox(height: 16),
                    ///field nhập mật khẩu
                    //TODO: cần validate 2 mật khẩu giống nhau và đủ kí tự trước khi submit
                    PasswordField(controller: _passwordController, label: 'Mật khẩu',),
                    const SizedBox(height: 16),
                    ///field nhập lại mật khẩu mới
                    PasswordConfirmationField(
                      controller: _confirmPasswordController,
                      passwordController: _passwordController,
                    ),
                  ],
                  onSubmit: () async {
                    if(await authController.register(// Đăng ký
                        _emailController.text,
                        _nameController.text,
                        _passwordController.text
                      )){ //Nếu email chưa được đăng ký
                      _showSuccessDialog(context, _emailController.text);
                    } else {
                      // TODO: Sửa lại giao diện thông báo lỗi nếu cần
                      //Nếu email đã được đăng ký hoặc email không hợp lệ hay lỗi khác
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email không hợp lệ hoặc email đã được đăng ký')),
                      );
                    }
                  },
                  submitBtn: 'Đăng ký',
                ),
                /// link hotline TODO: xử lý như bên login
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.grey),
                    Text('Hỗ trợ 1900 0091'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
  /// hàm hiển thị thông báo sau khi submit và chuyển sang trang login
  void _showSuccessDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Đặt thời gian chuyển hướng sau 5 giây
        Future.delayed(const Duration(seconds: 5), () {
          context.go('/');
        });

        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Kiểm tra email',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Chúng tôi đã gửi xác thực đến email $email của bạn!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// widget kiểm tra chính sách điều khoản
class TermsAndConditionsRow extends StatefulWidget {
  const TermsAndConditionsRow({super.key});

  @override
  State<TermsAndConditionsRow> createState() => _TermsAndConditionsRowState();
}

class _TermsAndConditionsRowState extends State<TermsAndConditionsRow> {
  //biến checkbox
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (bool? value) {
            setState(() {
              _isChecked = value ?? false;
            });
          },
        ),
        Expanded(
          child: Wrap(
            children: [
              const Text('Tôi đã đọc và đồng ý '),
              TextButton(
                onPressed: () {
                  //TODO: chuyển hướng đến trang điều khoản
                  context.push('/tac');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(top: 9.0),
                  minimumSize: Size.zero,
                ),
                child: const Text(
                  'Điều khoản và chính sách sử dụng',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              const Text(' của Nhóm 5.'),
            ],
          ),
        ),
      ],
    );
  }
}

