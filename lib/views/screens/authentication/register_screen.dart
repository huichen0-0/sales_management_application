import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_form.dart';
import '../../widgets/custom_form_fields.dart';

class RegisterScreen extends StatefulWidget {

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

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
        title: const Text('Tạo tài khoản miễn phí'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          margin: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Vui lòng nhập số điện thoại của bạn'),
              const SizedBox(height: 16),
              /// form nhập SDT TODO: lấy SDT để xử lý và hiển thị ở sau
              CustomForm(
                formKey: _formKey,
                fields: [
                  PhoneNumberField(controller: _phoneController,),
                  const SizedBox(height: 8),
                  const TermsAndConditionsRow(),
                ],
                onSubmit: (){
                  context.push('/otp', extra: 'register');
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

/// widget kiểm tra chính sách điều khoản
}
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

