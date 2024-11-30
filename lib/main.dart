import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sales_management_application/controllers/auth_controller.dart';
import 'package:sales_management_application/models/Supplier.dart';
import 'package:sales_management_application/services/filter/SupplierFilter.dart';
import 'package:sales_management_application/views/screens/authentication/forgot_password_screen.dart';
import 'package:sales_management_application/views/screens/authentication/login_screen.dart';
import 'package:sales_management_application/views/screens/authentication/register_screen.dart';
import 'package:sales_management_application/views/screens/authentication/reset_password_screen.dart';
import 'package:sales_management_application/views/screens/customers/add_customer_screen.dart';
import 'package:sales_management_application/views/screens/customers/customer_detail_screen.dart';
import 'package:sales_management_application/views/screens/customers/customers_screen.dart';
import 'package:sales_management_application/views/screens/customers/edit_customer_screen.dart';
import 'package:sales_management_application/views/screens/home/main_screen.dart';
import 'package:sales_management_application/views/screens/home/overview_screen.dart';
import 'package:sales_management_application/views/screens/home/widgets_screen.dart';
import 'package:sales_management_application/views/screens/invoices/invoices_screen.dart';
import 'package:sales_management_application/views/screens/orders/orders_screen.dart';
import 'package:sales_management_application/views/screens/products/products_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/add_supplier_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/edit_supplier_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/supplier_detail_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/suppliers_screen.dart';
import 'package:sales_management_application/views/screens/terms_and_conditions_screen.dart';
import 'package:sales_management_application/views/widgets/filter_list.dart';

import 'models/Filter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Cấu hình kết nối firebase
    options: FirebaseOptions(
        apiKey: "AIzaSyCI8HdmbzR6Z22Sqws3ZfjOlp0MPHZWFnQ",
        appId: "1:580063029367:android:230872dc2993339fb8fe72",
        messagingSenderId: "580063029367",
        projectId: "datn-2024-af1a7",
        databaseURL:
            "datn-2024-af1a7-default-rtdb.asia-southeast1.firebasedatabase.app/"),
  );
  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider( //Kiểm tra trạng thái đăng nhập và thực hiện chuyển hướng cho tất cả giao diện
      // create: (context) => AuthController(),
      create: (context) => AuthController()..checkLogin(), //Chạy checkLogin() trước khi khởi tạo ứng dụng và sau khi khởi tạo AuthController
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widgets is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Tạo một thể hiện của AuthController
    final authController = Provider.of<AuthController>(context);

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
        // GoRoute(
        //   path: '/otp',
        //   builder: (context, state) => VerificationCodeScreen(
        //     previousPage: state.extra as String?,
        //   ),
        // ),
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

        /// after login ///
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

        /// supplier
        GoRoute(
          path: '/suppliers',
          builder: (context, state) {
            Object? extraObject = state.extra;
            if (extraObject == null) {
              return SupplierScreen(SupplierFilter());
            } else {
              SupplierFilter filter = extraObject as SupplierFilter;
              return SupplierScreen(filter);
            }
          },
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) {
                SupplierFilter filter = state.extra as SupplierFilter;
                return  FilterSupplierScreen(filter);
              },
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddSupplierScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                List<dynamic> extraList = (state.extra as List);
                Supplier supplier = extraList.elementAt(1);
                final String key = extraList.elementAt(0);
                return SupplierDetailScreen(id: key, supplier: supplier);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    List<dynamic> extraList = (state.extra as List);
                    // Map<dynamic, dynamic> extraValue = Map<dynamic, dynamic>.from(extraList.elementAt(1));
                    // Supplier supplier = Supplier.fromJson(extraValue);
                    Supplier supplier = extraList.elementAt(1);
                    final String key = extraList.elementAt(0);
                    return EditSupplierScreen(id: key, supplier: supplier);
                  },
                ),
              ],
            ),
          ],
        ),

        /// customer
        GoRoute(
          path: '/customers',
          builder: (context, state) => const CustomerScreen(),
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) => const FilterCustomerScreen(),
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddCustomerScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                return const CustomerDetailScreen();
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    return const EditCustomerScreen();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final isLoggedIn = authController.isLoggedIn;
        final String location = state.matchedLocation;

        // Nếu chưa đăng nhập và không phải ở trang login/register/quên mật khẩu => chuyển hướng tới trang login
        if (!isLoggedIn &&
            location != '/' &&
            location != '/register' &&
            location != '/forgot_password') {
          return '/';
        }

        // Nếu đã đăng nhập và đang ở trang login => chuyển về trang chủ
        if (isLoggedIn &&
            (location == '/' ||
                location == '/register' ||
                location == '/forgot_password')) {
          return '/home';
        }

        return null; // Không điều hướng gì thêm
      },
    );
    return SafeArea(
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
