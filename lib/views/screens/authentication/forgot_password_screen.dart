import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_form_fields.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
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
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          margin: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Vui lòng nhập số điện thoại'),
              const SizedBox(height: 16),
              CustomForm(
                  formKey: _formKey,
                  fields: [
                    PhoneNumberField(controller: _phoneController,),
                  ],
                  onSubmit: (){
                    context.push('/otp', extra: 'forgot_password');
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
    );
  }
}
