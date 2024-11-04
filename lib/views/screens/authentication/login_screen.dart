import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_form_fields.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_bag,
                size: 100,
                color: Colors.blue,
              ),
              const Text(
                'Quản lý bán hàng',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 32),
              /// field nhập SDT TODO: cần validate trước khi gửi đi
              CustomForm(
                formKey: _formKey,
                fields: [
                  PhoneNumberField(controller: _phoneController,),
                  const SizedBox(height: 16),
                  PasswordField(controller: _passwordController,),
                  const SizedBox(height: 8),
                  /// link Quên mật khẩu
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.push('/forgot_password');
                      },
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                onSubmit: (){
                  context.go('/home');
                },
                submitBtn: 'Đăng nhập',
              ),
              const SizedBox(height: 16),
              /// link đăng ký
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bạn chưa có tài khoản?'),
                  TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              /// link hotline TODO: xử lý nhâps vào sdt hotline
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
    );
  }
}

