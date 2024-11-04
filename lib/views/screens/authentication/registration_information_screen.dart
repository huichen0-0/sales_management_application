import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_form.dart';
import '../../widgets/custom_form_fields.dart';


class RegistrationInformationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  RegistrationInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Điền thông tin'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/register');
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomForm(
              formKey: _formKey,
              fields: [
                const SizedBox(height: 16),
                NameField(controller: _nameController,),
                const SizedBox(height: 16),
                ///field nhập mật khẩu
                //TODO: cần validate 2 mật khẩu giống nhau và đủ kí tự trước khi submit
                PasswordField(controller: _passwordController,),
                const SizedBox(height: 16),
                ///field nhập lại mật khẩu mới
                PasswordConfirmationField(
                  controller: _confirmPasswordController,
                  passwordController: _passwordController,
                ),
              ],
              onSubmit: (){
                _showSuccessDialog(context);
              },
              submitBtn: 'Hoàn thành',
            ),
          ],
        ),
      ),
    );
  }

  /// hàm hiển thị thông báo sau khi submit và chuyển sang trang login
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Đặt thời gian chuyển hướng sau 3 giây
        Future.delayed(const Duration(seconds: 3), () {
          context.go('/');
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
                'Đăng ký tài khoản thành công!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}