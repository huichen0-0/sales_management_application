import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/views/screens/home/main_screen.dart';
import 'package:sales_management_application/views/screens/home/overview_screen.dart';
import 'package:sales_management_application/views/screens/home/widgets_screen.dart';
import 'package:sales_management_application/views/screens/invoices/invoices_screen.dart';
import 'package:sales_management_application/views/screens/orders/orders_screen.dart';
import 'package:sales_management_application/views/screens/products/products_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/add_supplier_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/edit_supplier_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/suppliers_screen.dart';
import 'package:sales_management_application/views/widgets/filter_list.dart';
import 'views/screens/authentication/forgot_password_screen.dart';
import 'views/screens/authentication/login_screen.dart';
import 'views/screens/authentication/register_screen.dart';
import 'views/screens/authentication/reset_password_screen.dart';
import 'views/screens/authentication/verification_code_screen.dart';
import 'views/screens/suppliers/supplier_detail_screen.dart';
import 'views/screens/terms_and_conditions_screen.dart';

final _router = GoRouter(
  initialLocation: '/',
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
      path: '/invoices',
      builder: (context, state) => const InvoiceScreen(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrderScreen(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductScreen(),
    ),
    GoRoute(
      path: '/all',
      builder: (context, state) => const WidgetScreen(),
    ),
    GoRoute(
      path: '/suppliers',
      builder: (context, state) => const SupplierScreen(),
      routes: [
        GoRoute(
          path: 'filter',
          builder: (context, state) => FilterSupplierScreen(),
        ),
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddSupplierScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) {
            return const SupplierDetailScreen();
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                return EditSupplierScreen();
              },
            ),
          ],
        ),
      ],
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

