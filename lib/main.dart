import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/controllers/inventory_controller.dart';
import 'package:sales_management_application/models/inventory_check_receipt.dart';
import 'package:sales_management_application/views/screens/authentication/forgot_password_screen.dart';
import 'package:sales_management_application/views/screens/authentication/login_screen.dart';
import 'package:sales_management_application/views/screens/authentication/register_screen.dart';
import 'package:sales_management_application/views/screens/authentication/reset_password_screen.dart';
import 'package:sales_management_application/views/screens/customers/add_customer_screen.dart';
import 'package:sales_management_application/views/screens/customers/customer_detail_screen.dart';
import 'package:sales_management_application/views/screens/customers/customers_screen.dart';
import 'package:sales_management_application/views/screens/customers/edit_customer_screen.dart';
import 'package:sales_management_application/views/screens/customers/filter_customer_screen.dart';
import 'package:sales_management_application/views/screens/home/main_screen.dart';
import 'package:sales_management_application/views/screens/home/overview_screen.dart';
import 'package:sales_management_application/views/screens/home/widgets_screen.dart';
import 'package:sales_management_application/views/screens/inventory_check/inventory_update_screen.dart';
import 'package:sales_management_application/views/screens/inventory_check/inventory_filter_screen.dart';
import 'package:sales_management_application/views/screens/inventory_check/inventory_detail_screen.dart';
import 'package:sales_management_application/views/screens/inventory_check/inventory_screen.dart';
import 'package:sales_management_application/views/screens/invoices/invoices_screen.dart';
import 'package:sales_management_application/views/screens/orders/orders_screen.dart';
import 'package:sales_management_application/views/screens/products/add_product_screen.dart';
import 'package:sales_management_application/views/screens/products/edit_product_screen.dart';
import 'package:sales_management_application/views/screens/products/filter_product_screen.dart';
import 'package:sales_management_application/views/screens/products/product_detail_screen.dart';
import 'package:sales_management_application/views/screens/products/products_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/add_supplier_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/edit_supplier_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/filter_supplier_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/supplier_detail_screen.dart';
import 'package:sales_management_application/views/screens/suppliers/suppliers_screen.dart';
import 'package:sales_management_application/views/screens/terms_and_conditions_screen.dart';
import 'package:sales_management_application/xuathuy/controllers/ec_controller.dart';
import 'package:sales_management_application/xuathuy/models/ec_receipt.dart';
import 'package:sales_management_application/xuathuy/views/screens/export_cancellation/ec_detail_screen.dart';
import 'package:sales_management_application/xuathuy/views/screens/export_cancellation/ec_filter_screen.dart';
import 'package:sales_management_application/xuathuy/views/screens/export_cancellation/ec_home_screen.dart';
import 'package:sales_management_application/xuathuy/views/screens/export_cancellation/ec_update_screen.dart';

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
      routes: [
        GoRoute(
          path: 'filter',
          builder: (context, state) => const FilterProductScreen(),
        ),
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddProductScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) {
            return const ProductDetailScreen();
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                return const EditProductScreen();
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/all',
      builder: (context, state) => const WidgetScreen(),
    ),

    /// supplier
    GoRoute(
      path: '/suppliers',
      builder: (context, state) => const SupplierScreen(),
      routes: [
        GoRoute(
          path: 'filter',
          builder: (context, state) => const FilterSupplierScreen(),
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

    /// inventory
    GoRoute(
      path: '/inventory',
      builder: (context, state) => const InventoryScreen(),
      routes: [
        GoRoute(
          path: 'filter',
          builder: (context, state) => const FilterInventoryScreen(),
        ),
        GoRoute(
          path: 'add',
          builder: (context, state) => const UpdateInventoryScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!); // Lấy ID từ URL
            return InventoryDetailScreen(
              inventoryCheckReceiptId: id,
            );
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                final id =
                    int.parse(state.pathParameters['id']!); // Lấy ID từ URL
                final InventoryController controller = InventoryController();
                final InventoryCheckReceipt? existingNote =
                    controller.getInventoryCheckReceiptById(id); // Lấy dữ liệu
                return UpdateInventoryScreen(
                  existingNote: existingNote,
                );
              },
            ),
          ],
        ),
      ],
    ),

    /// export cancellation
    GoRoute(
      path: '/export_cancellation',
      builder: (context, state) => const ExportCancellationScreen(),
      routes: [
        GoRoute(
          path: 'filter',
          builder: (context, state) => const FilterExportCancellationScreen(),
        ),
        GoRoute(
          path: 'add',
          builder: (context, state) => const UpdateExportCancellationScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!); // Lấy ID từ URL

            return ExportCancellationDetailScreen(
              receiptId: id,
            );
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                final id =
                    int.parse(state.pathParameters['id']!); // Lấy ID từ URL
                final ExportCancellationController controller =
                    ExportCancellationController();

                final ExportCancellationReceipt? existingReceipt =
                    controller.getReceiptById(id); // Lấy dữ liệu
                return UpdateExportCancellationScreen(
                  existingReceipt: existingReceipt,
                );
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
