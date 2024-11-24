import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../widgets/forms/custom_form.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String? previousPage;

  const VerificationCodeScreen({super.key, this.previousPage});

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  //biến thời gian đếm ngược
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Nhập mã xác thực'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/register');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomForm(
              formKey: _formKey,
              fields: [
                // text thông báo
                // TODO: cần lấy sdt người dùng nhập ở trước đó để hiển thị
                const Text(
                  'Mã xác thực vừa gửi đến số *******130.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                _buildPinCodeTextField(context),
                const SizedBox(height: 32),
                _buildCountdownTimer(context),
              ],
              onSubmit: () {
                // TODO: cần xử lý mã OTP nhập vaò
                if (widget.previousPage == 'register') {
                  context.go('/registration_info');
                } else if (widget.previousPage == 'forgot_password') {
                  context.go('/reset_password');
                }
              },
              submitBtn: 'Tiếp tục',
            ),
         ],
        ),
      ),
    );
  }
  /// widget thời gian hiệu lực otp
  Widget _buildCountdownTimer(BuildContext context) {
    return CountdownTimer(
      endTime: endTime,
      widgetBuilder: (_, time) {
        return time == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Gửi lại mã xác thực'),
                  TextButton(
                    onPressed: () {
                      context.go('/otp'); // load lại trang
                    }, //TODO: xử lý khi nhấn gửi lại mã OTP
                    child: const Text(
                      'Gửi lại',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              )
            : Text('Gửi lại mã xác thực (0:${time.sec})');
      },
    );
  }

  /// hàm xây dựng vùng nhập mã OTP,
  /// đã xử lý chỉ cho nhập số và nhập đủ 6 số mới cho submit
  //TODO: lấy mã nhập vào để xác thực
  Widget _buildPinCodeTextField(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        inactiveFillColor: Colors.white60,
        activeFillColor: Colors.white,
        inactiveColor: Colors.grey,
        activeColor: Colors.blue,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white60,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      enableActiveFill: true,
      errorTextSpace: 20.0,
      /// TODO: lấy otp nhập vào
      onCompleted: (value) {
        //
      },
      validator: (value){
        if (value == null || value.isEmpty || value.length < 6) {
          return 'Vui lòng nhập mã OTP';
        }
        return null;
      },
    );
  }
}
