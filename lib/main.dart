import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/views/screens/home/main_screen.dart';
import 'package:sales_management_application/views/screens/home/overview_screen.dart';
import 'package:sales_management_application/views/screens/home/widget_screen.dart';
import 'package:sales_management_application/views/screens/invoices/invoice_screen.dart';
import 'package:sales_management_application/views/screens/orders/order_screen.dart';
import 'package:sales_management_application/views/screens/products/product_screen.dart';
import 'views/screens/authentication/forgot_password_screen.dart';
import 'views/screens/authentication/login_screen.dart';
import 'views/screens/authentication/register_screen.dart';
import 'views/screens/authentication/registration_information_screen.dart';
import 'views/screens/authentication/reset_password_screen.dart';
import 'views/screens/authentication/verification_code_screen.dart';
import 'views/screens/terms_and_conditions_screen.dart';

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    ///authentication
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => VerificationCodeScreen(
        previousPage: state.extra as String?,
      ),
    ),
    GoRoute(
      path: '/reset_password',
      builder: (context, state) => ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/tac',
      builder: (context, state) => const TermsAndConditionsScreen(),
    ),
    GoRoute(
      path: '/registration_info',
      builder: (context, state) => RegistrationInformationScreen(),
    ),
    ///after login
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/overview',
      builder: (context, state) => const OverviewScreen(),
    ),
    GoRoute(
      path: '/invoice',
      builder: (context, state) => const InvoiceScreen(),
    ),
    GoRoute(
      path: '/order',
      builder: (context, state) => const OrderScreen(),
    ),
    GoRoute(
      path: '/product',
      builder: (context, state) => const ProductScreen(),
    ),
    GoRoute(
      path: '/all',
      builder: (context, state) => const WidgetScreen(),
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widgets is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

