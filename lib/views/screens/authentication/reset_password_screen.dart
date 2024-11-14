import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_form_fields.dart';

class ResetPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Đổi mật khẩu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomForm(
                formKey: _formKey,
                fields: [
                  ///field nhập mật khẩu
                  PasswordField(controller: _passwordController, label: 'Mật khẩu hiện tại',),
                  const SizedBox(height: 16),
                  ///field nhập mật khẩu
                  PasswordField(controller: _newPasswordController, label: 'Mật khẩu mới',),
                  const SizedBox(height: 16),
                  ///field nhập lại mật khẩu mới
                  PasswordConfirmationField(
                    controller: _confirmPasswordController,
                    passwordController: _newPasswordController,
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
      ),
    );
  }

  /// hàm hiển thị thông báo sau khi submit và chuyển sang trang login
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Đặt thời gian chuyển hướng sau 3 giây
        Future.delayed(const Duration(seconds: 3), () {
          context.go('/home');
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
                'Mật khẩu đã được thay đổi thành công.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}