import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// /Phone number field/ ///
class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  const PhoneNumberField({super.key, required this.controller});

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}
class _PhoneNumberFieldState extends State<PhoneNumberField> {
  ///định dạng sdt
  // bool _validatePhoneNumber(String value) {
  //   final phoneRegExp = RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$');
  //   return phoneRegExp.hasMatch(value);
  // }
  ///giải phóng controller
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        labelText: 'Số điện thoại *',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập số điện thoại';
        }
        // else if (!_validatePhoneNumber(value)) {
        //   return 'Số điện thoại không hợp lệ';
        // }
        return null;
      },
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

/// /Name field/ ///
class NameField extends StatelessWidget {
  final TextEditingController controller;

  const NameField({super.key, required this.controller});

  ///giải phóng controller
  void dispose() {
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Họ tên',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập họ tên';
        }
        return null;
      },
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

/// /Password field/ ///
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  const PasswordField({
    super.key, required this.controller, required this.label,
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}
class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true; // Bắt đầu ở trạng thái ẩn

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText, // Ẩn/hiện mật khẩu
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // Đảo ngược trạng thái ẩn/hiện
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập mật khẩu';
        } else if (value.length < 6) {
          return 'Mật khẩu phải có ít nhất 6 ký tự';
        }
        return null;
      },
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

/// /Password Confirmation field/ ///
class PasswordConfirmationField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  const PasswordConfirmationField({
    super.key, required this.controller, required this.passwordController
  });

  @override
  _PasswordConfirmationFieldState createState() => _PasswordConfirmationFieldState();
}
class _PasswordConfirmationFieldState extends State<PasswordConfirmationField> {
  bool _obscureText = true; // Bắt đầu ở trạng thái ẩn

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText, // Ẩn/hiện mật khẩu
      decoration: InputDecoration(
        labelText: 'Nhập lại mật khẩu',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // Đảo ngược trạng thái ẩn/hiện
            });
          },
        ),
      ),
      validator: (value) {
        if (value != widget.passwordController.text) {
          return 'Mật khẩu không khớp';
        }
        return null;
      },
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

///Email
class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  ///giải phóng controller
  void dispose() {
    controller.dispose();
  }
  bool _validateEmail(String value) {
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegExp.hasMatch(value);
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập email';
        }
        else if (!_validateEmail(value)) {
          return 'Email không hợp lệ';
        }
        return null;
      },
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

/// /Input field/ trươờng nhập k validate///
class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const InputField({super.key, required this.controller, required this.label});

  //giải phóng controller
  void dispose() {
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        return null;
      },
    );
  }
}