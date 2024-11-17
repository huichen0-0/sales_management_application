import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sales_management_application/controllers/auth_controller.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_form_fields.dart';

class LoginScreen extends StatelessWidget {
  // final AuthController _authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Tạo một thể hiện của AuthController
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
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
                /// form login
                CustomForm(
                  formKey: _formKey,
                  fields: [
                    /// nhap emaik
                    EmailField(controller: _emailController,),
                    const SizedBox(height: 16),
                    /// nhap password
                    PasswordField(controller: _passwordController, label: 'Mật khẩu',),
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
                  onSubmit: () async {
                    var user = await authController.login(_emailController.text, _passwordController.text);//Đăng nhập
                    var logginOK = 0;
                    if (user != null && user.emailVerified) { //Nếu người dùng tồn tại và email đã xác thực
                      logginOK = 1;
                      context.go('/home');
                    } else {
                      // TODO: Sửa lại giao diện hiển thị thông báo lỗi nếu cần
                      if(user != null && !user.emailVerified){ //Nếu người email người dùng chưa xác thực
                        logginOK = 2;
                      }
                      if(logginOK == 2){ //Nếu email chưa xác thực
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email chưa được xác thực. Hãy xác thực email!')),
                        );
                      } else if (logginOK == 0){ //Nếu sai email hoặc mật khẩu
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email hoặc mật khẩu sai. Vui lòng nhập lại')),
                        );
                      } // loggginOK == 1 tức là đã đăng nhập thành công nên không hiển thị gì
                    }
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
      ),
    );
  }
}

