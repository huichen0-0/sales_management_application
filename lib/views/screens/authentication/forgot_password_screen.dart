import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_form_fields.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Quên mật khẩu'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            margin: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Vui lòng nhập email'),
                const SizedBox(height: 16),
                CustomForm(
                    formKey: _formKey,
                    fields: [
                      EmailField(controller: _emailController,),
                    ],
                    onSubmit: (){
                      _showNotificationDialog(context, _emailController.text);
                    },
                    submitBtn: 'Tiếp tục',
                ),
                const Spacer(),
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
  void _showNotificationDialog(BuildContext context, String email) {
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
