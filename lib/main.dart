import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sales_management_application/authentication/auth_controller.dart';
import 'package:sales_management_application/authentication/edit_profile_screen.dart';
import 'package:sales_management_application/customers/model/customer.dart';
import 'package:sales_management_application/customers/filter/customer_filter.dart';
import 'package:sales_management_application/ec/ec_filter.dart';
import 'package:sales_management_application/import/import_filter.dart';
import 'package:sales_management_application/order/order_filter.dart';
import 'package:sales_management_application/payment/customer_payment_history_screen.dart';
import 'package:sales_management_application/payment/import_payment_screen.dart';
import 'package:sales_management_application/payment/supplier_payment_history_screen.dart';
import 'package:sales_management_application/payment/sale_payment_screen.dart';
import 'package:sales_management_application/products/add_product_screen.dart';
import 'package:sales_management_application/products/edit_product_screen.dart';
import 'package:sales_management_application/products/product_detail_screen.dart';
import 'package:sales_management_application/products/product_filter.dart';
import 'package:sales_management_application/products/products_screen.dart';
import 'package:sales_management_application/receipt/receipt_detail.dart';
import 'package:sales_management_application/return_import/model/return_import_receipt.dart';
import 'package:sales_management_application/return_import/return_import_filter.dart';
import 'package:sales_management_application/return_import/views/screens/return_import_detail_screen.dart';
import 'package:sales_management_application/return_import/views/screens/return_import_filter_screen.dart';
import 'package:sales_management_application/return_import/views/screens/return_import_home_screen.dart';
import 'package:sales_management_application/return_import/views/screens/return_import_update_screen.dart';
import 'package:sales_management_application/return_sale/return_sale_detail_screen.dart';
import 'package:sales_management_application/return_sale/return_sale_filter.dart';
import 'package:sales_management_application/return_sale/return_sale_filter_screen.dart';
import 'package:sales_management_application/return_sale/return_sale_home_screen.dart';
import 'package:sales_management_application/return_sale/return_sale_receipt.dart';
import 'package:sales_management_application/return_sale/return_sale_update_screen.dart';
import 'package:sales_management_application/statistic/product_statistic/product_statistic_screen.dart';
import 'package:sales_management_application/statistic/sale_statistic/daily_sale_statistic_screen.dart';
import 'package:sales_management_application/statistic/sale_statistic/sale_statistic_screen.dart';
import 'package:sales_management_application/suppliers/add_supplier_screen.dart';
import 'package:sales_management_application/suppliers/edit_supplier_screen.dart';
import 'package:sales_management_application/suppliers/supplier.dart';
import 'package:sales_management_application/suppliers/supplier_detail_screen.dart';
import 'package:sales_management_application/suppliers/suppliers_screen.dart';
import 'package:sales_management_application/term_condition/terms_and_conditions_screen.dart';
import 'package:sales_management_application/search/search_customer_screen.dart';
import 'package:sales_management_application/search/search_supplier.dart';
import 'authentication/forgot_password_screen.dart';
import 'authentication/login_screen.dart';
import 'authentication/register_screen.dart';
import 'authentication/reset_password_screen.dart';
import 'config/constants.dart';
import 'customers/view/add_customer_screen.dart';
import 'customers/view/customer_detail_screen.dart';
import 'customers/view/customers_screen.dart';
import 'customers/view/edit_customer_screen.dart';
import 'ec/view/ec_detail_screen.dart';
import 'ec/ec_filter_screen.dart';
import 'ec/view/ec_home_screen.dart';
import 'ec/view/ec_update_screen.dart';
import 'customers/filter/customer_filter_screen.dart';
import 'filter/product_filter_screen.dart';
import 'filter/supplier_filter_screen.dart';
import 'home/main_screen.dart';
import 'home/widgets_screen.dart';
import 'import/import_detail_screen.dart';
import 'import/import_filter_screen.dart';
import 'import/import_home_screen.dart';
import 'import/import_receipt.dart';
import 'ec/export_receipt.dart';
import 'import/import_update_screen.dart';
import 'inventory_check/ic_detail_screen.dart';
import 'inventory_check/ic_filter_screen.dart';
import 'inventory_check/ic_home_screen.dart';
import 'inventory_check/ic_update_screen.dart';
import 'inventory_check/inventory_check_receipt.dart';
import 'invoice/invoice_detail_screen.dart';
import 'invoice/invoice_filter.dart';
import 'invoice/invoice_filter_screen.dart';
import 'invoice/invoice_home_screen.dart';
import 'invoice/invoice_receipt.dart';
import 'invoice/invoice_update_screen.dart';
import 'order/order.dart';
import 'order/order_detail_screen.dart';
import 'order/order_filter_screen.dart';
import 'order/order_home_screen.dart';
import 'order/order_update_screen.dart';
import 'products/product.dart';
import 'receipt/receipt.dart';
import 'inventory_check/inventory_filter.dart';
import 'suppliers/supplier_filter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
  //     name: 'DATN-2024',
      // Cấu hình kết nối firebase
      options: const FirebaseOptions(
          apiKey: "AIzaSyCI8HdmbzR6Z22Sqws3ZfjOlp0MPHZWFnQ",
          appId: "1:580063029367:android:230872dc2993339fb8fe72",
          messagingSenderId: "580063029367",
          projectId: "datn-2024-af1a7",
          databaseURL:
          "datn-2024-af1a7-default-rtdb.asia-southeast1.firebasedatabase.app/"),
    );
  // } else {
  //   Firebase.app(); // if already initialized, use that one
  // }
  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider( //Kiểm tra trạng thái đăng nhập và thực hiện chuyển hướng cho tất cả giao diện
      // create: (context) => AuthController(),
      create: (context) => AuthController()..checkLogin(), //Chạy checkLogin() trước khi khởi tạo ứng dụng và sau khi khởi tạo AuthController
      child: const MyApp(),
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

    final router = GoRouter(
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
          path: '/resetPassword',
          builder: (context, state) => ResetPasswordScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
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
        /// edit profile ///
        GoRoute(
          path: '/editProfile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        ///invoice
        GoRoute(
          path: AppPath.invoice,
          builder: (context, state) {
            Object? extraObject = state.extra;
            if (extraObject == null) {
              return InvoiceScreen(filter: InvoiceFilter(), customerId: null,);
            } else {
              InvoiceFilter filter = extraObject as InvoiceFilter;
              return InvoiceScreen(filter: filter);
            }
          },
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) {
                InvoiceFilter filter = state.extra as InvoiceFilter;
                return FilterInvoiceScreen(filter: filter);
              },
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => const UpdateInvoiceScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.pathParameters['id']!; // Lấy ID từ URL
                InvoiceReceipt receipt = state.extra as InvoiceReceipt;
                return InvoiceDetailScreen(
                  receiptId: id, receipt: receipt,
                );
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    // Lấy dữ liệu
                    final InvoiceReceipt? existingInvoice = state.extra as InvoiceReceipt;
                    return UpdateInvoiceScreen(existingInvoice: existingInvoice,);
                  },
                ),
              ],
            ),
          ],
        ),
        ///statistic
        GoRoute(
          path: '/productStatistic',
          builder: (context, state) {
            return const ProductStatisticScreen();
          },
        ),
        GoRoute(
          path: '/saleStatistic',
          builder: (context, state) {
            return const SaleStatisticScreen();
          },
        ),
        GoRoute(
          path: '/dailySaleStatistic',
          builder: (context, state) {
            final date = state.extra as DateTime;
            return DailySaleStatisticScreen(statisticDate: date);
          },
        ),
        ///return invoice
        GoRoute(
          path: AppPath.returnInvoice,
          builder: (context, state) {
            Object? extraObject = state.extra;
            if (extraObject == null) {
              return ReturnInvoiceScreen(filter: ReturnInvoiceFilter());
            } else {
              ReturnInvoiceFilter filter = extraObject as ReturnInvoiceFilter;
              return ReturnInvoiceScreen(filter: filter);
            }
          },
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) {
                ReturnInvoiceFilter filter = state.extra as ReturnInvoiceFilter;
                return FilterReturnInvoiceScreen(filter: filter);
              },
            ),
            GoRoute(
                path: 'add',
                builder: (context, state) {
                  final invoiceReceipt = state.extra as InvoiceReceipt;
                  final receipt = ReturnInvoiceReceipt(
                      id: '',
                      invoiceReceiptId: invoiceReceipt.id,
                      partnerId: invoiceReceipt.partnerId,
                      customer: invoiceReceipt.customer,
                      payments: [],
                      status: 1,
                      createdAt: DateTime.now(),
                      details: [], uid: '');
                  for (var detail in invoiceReceipt.details) {
                    receipt.details.add(ReceiptDetail(
                        productId: detail.productId,
                        quantity: 0,
                        maxQuantity: detail.quantity,
                        product: detail.product));
                  }
                  return UpdateReturnInvoiceScreen(
                    receipt: receipt,
                  );
                }),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.pathParameters['id']!; // Lấy ID từ URL
                return ReturnInvoiceDetailScreen(receiptId: id,);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    ReturnInvoiceReceipt receipt = state.extra as ReturnInvoiceReceipt;
                    return UpdateReturnInvoiceScreen(receipt: receipt,);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) => OrderScreen(filter: OrderFilter()),
        ),
        GoRoute(
          path: '/products',
          builder: (context, state) {
            Object? extraObject = state.extra;
            if (extraObject == null) {
              return ProductScreen(ProductFilter());
            } else {
              ProductFilter filter = extraObject as ProductFilter;
              return ProductScreen(filter);
            }
          },
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) {
                ProductFilter filter = state.extra as ProductFilter;
                return FilterProductScreen(filter);
              },
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddProductScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                List<dynamic> extraList = (state.extra as List);
                Product product = Product.fromJSON(extraList.elementAt(1));
                final String key = extraList.elementAt(0);
                return ProductDetailScreen(id: key, product: product);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    List<dynamic> extraList = (state.extra as List);
                    Product product = extraList.elementAt(1);
                    final String key = extraList.elementAt(0);
                    return EditProductScreen(id: key, product: product);
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
        GoRoute(
          path: '/inventory',
          builder: (context, state) {
            Object? extraObject = state.extra;
            if (extraObject == null) {
              return InventoryScreen(InventoryFilter());
            } else {
              InventoryFilter filter = extraObject as InventoryFilter;
              return InventoryScreen(filter);
            }
          } ,
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) {
                InventoryFilter filter = state.extra as InventoryFilter;
                return  FilterInventoryScreen(filter);
              },
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => UpdateInventoryScreen(id: '', receipt: InventoryCheckReceipt.empty()),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                List<dynamic> extraList = (state.extra as List);
                InventoryCheckReceipt inventoryCheck = extraList.elementAt(1) as InventoryCheckReceipt;
                final String key = extraList.elementAt(0);
                return InventoryDetailScreen(id: key, receipt: inventoryCheck);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    List<dynamic> extraList = (state.extra as List);
                    InventoryCheckReceipt inventoryCheck = extraList.elementAt(1);
                    final String key = extraList.elementAt(0);
                    return UpdateInventoryScreen(id: key, receipt: inventoryCheck);
                  },
                ),
              ],
            ),
          ],
        ),
        ///invoice
        GoRoute(
          path: AppPath.invoice,
          builder: (context, state) {
            Object? extraObject = state.extra;
            if (extraObject == null) {
            return InvoiceScreen(filter: InvoiceFilter());
            } else {
            InvoiceFilter filter = extraObject as InvoiceFilter;
            return InvoiceScreen(filter: filter);
            }
          },
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) {
                InvoiceFilter filter = state.extra as InvoiceFilter;
                return FilterInvoiceScreen(filter: filter);
              },
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => const UpdateInvoiceScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                List<dynamic> extraList = (state.extra as List);
                InvoiceReceipt receipt = InvoiceReceipt.fromJson(extraList.elementAt(1));
                final String key = extraList.elementAt(0);
                return InvoiceDetailScreen(receiptId: key, receipt: receipt);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    InvoiceReceipt receipt = state.extra as InvoiceReceipt;
                    return UpdateInvoiceScreen(existingInvoice: receipt);
                  },
                ),
              ],
            ),
          ],
        ),

        /// export cancellation
        GoRoute(
          path: '/ec',
          builder: (context, state) {
              Object? extraObject = state.extra;
              if (extraObject == null) {
                return ExportCancellationScreen(EcFilter());
    } else {
    EcFilter filter = extraObject as EcFilter;
    return ExportCancellationScreen(filter);
    }
          },
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) {
                EcFilter filter = state.extra as EcFilter;
                return  FilterExportCancellationScreen(filter);
              }
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => UpdateExportCancellationScreen(id: '', receipt: ExportCancellationReceipt.empty()),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                List<dynamic> extraList = (state.extra as List);
                ExportCancellationReceipt ec = extraList.elementAt(1) as ExportCancellationReceipt;
                final String key = extraList.elementAt(0);
                return ExportCancellationDetailScreen(id: key, ec: ec);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    List<dynamic> extraList = (state.extra as List);
                    ExportCancellationReceipt ec = extraList.elementAt(1);
                    final String key = extraList.elementAt(0);
                    return UpdateExportCancellationScreen(id: key, receipt: ec);
                  },
                ),
              ],
            ),
          ],
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
                final id = state.pathParameters['id']!;
                return SupplierDetailScreen(id: id);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    List<dynamic> extraList = (state.extra as List);
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
          builder: (context, state) {
            Object? extraObject = state.extra;
            if (extraObject == null) {
              return CustomerScreen(filter: CustomerFilter.empty());
            } else {
              CustomerFilter filter = extraObject as CustomerFilter;
              return CustomerScreen(filter: filter);
            }
          },
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) {
                CustomerFilter filter = state.extra as CustomerFilter;
                return  FilterCustomerScreen(filter: filter,);
              },
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddCustomerScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                Customer customer = state.extra as Customer;
                return CustomerDetailScreen(customer: customer);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    Customer customer = state.extra as Customer;
                    return EditCustomerScreen(customer: customer,);
                  },
                ),
              ],
            ),
          ],
        ),
        ///import
        GoRoute(
          path: AppPath.import,
          builder: (context, state) {
              Object? extraObject = state.extra;
              if (extraObject == null) {
              return ImportScreen(filter: ImportFilter());
              } else {
              ImportFilter filter = extraObject as ImportFilter;
              return ImportScreen(filter: filter);
              }
          },
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) {
                ImportFilter filter = state.extra as ImportFilter;
                  return  FilterImportScreen(filter: filter);
              }
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => UpdateImportScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.pathParameters['id']!; // Lấy ID từ URL
                ImportReceipt receipt = state.extra as ImportReceipt;
                return ImportDetailScreen(receipt: receipt, id: id);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    List<dynamic> extraList = (state.extra as List);
                    ImportReceipt ir = extraList.elementAt(1);
                    return UpdateImportScreen(existingReceipt: ir);
                  },
                ),
              ],
            ),
          ],
        ),
        ///order
        GoRoute(
          path: AppPath.order,
          builder: (context, state) {
            Object? extraObject = state.extra;
            if (extraObject == null) {
              return OrderScreen(filter: OrderFilter());
            } else {
              OrderFilter filter = extraObject as OrderFilter;
              return OrderScreen(filter: filter);
            }
          },
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) {
                OrderFilter filter = state.extra as OrderFilter;
                return FilterOrderScreen(filter: filter,);
              },
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => const UpdateOrderScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                // final id = state.pathParameters['id']!; // Lấy ID từ URL
                Order order = state.extra as Order;
                return OrderDetailScreen(order: order,);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    // final OrderController controller = OrderController();
                    // final Order? existingOrder = controller.getOrderById(id);
                    Order existingOrder = state.extra as Order;
                    return UpdateOrderScreen(existingOrder: existingOrder,);
                  },
                ),
              ],
            ),
          ],
        ),
        ///return import
        GoRoute(
          path: AppPath.returnImport,
          builder: (context, state) {
            Object? extraObject = state.extra;
            if (extraObject == null) {
              return ReturnImportScreen(filter: ReturnImportFilter());
            } else {
              ReturnImportFilter filter = extraObject as ReturnImportFilter;
              return ReturnImportScreen(filter: filter);
            }
          },
          routes: [
            GoRoute(
              path: 'filter',
              builder: (context, state) {
                ReturnImportFilter filter = state.extra as ReturnImportFilter;
                return  FilterReturnImportScreen(filter: filter);
              },
            ),
            GoRoute(path: 'add', builder: (context, state) {
              ImportReceipt importReceipt = state.extra as ImportReceipt;
              final receipt = ReturnImportReceipt(
                  id: '',
                  importReceiptId: importReceipt.id,
                  partnerId: importReceipt.partnerId,
                  supplier: importReceipt.supplier,
                  payments: [],
                  status: 1,
                  createdAt: DateTime.now(),
                  details: [], uid: '');
              for (var detail in importReceipt.details) {
                receipt.details.add(ReceiptDetail(
                    productId: detail.productId,
                    quantity: 0,
                    maxQuantity: detail.quantity,
                    product: detail.product));
              }
              return UpdateReturnImportScreen(existingReceipt: receipt,);
            },
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                // final id = state.pathParameters['id']!; // Lấy ID từ URL
                ReturnImportReceipt receipt = state.extra as ReturnImportReceipt;
                return ReturnImportDetailScreen(receipt: receipt);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    List<dynamic> extraList = (state.extra as List);
                    ReturnImportReceipt receipt = extraList.elementAt(1);
                    return UpdateReturnImportScreen(existingReceipt: receipt);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppPath.supplierSelection,
          builder: (context, state) =>
              SupplierSelectionSceen(
                onSupplierTap: (supplier) {
                  context.pop(supplier); // Pop and return the selected supplier
                },
              ),
        ),
        GoRoute(
          path: AppPath.customerSelection,
          builder: (context, state) => CustomerSelectionSceen(
            onCustomerTap: (customer) {
              context.pop(customer); // Pop and return the selected supplier
            },
          ),
        ),
        ///payment
        GoRoute(
          path: AppPath.payment,
          builder: (context, state) {
            final receipt = state.extra as Receipt;
            return ImportPaymentScreen(
              receipt: receipt,
              onSubmit: (receipt) {
                context.pop(receipt);
              },
            );
          },
        ),
        ///sale payment
        GoRoute(
          path: AppPath.salePayment,
          builder: (context, state) {
            final receipt = state.extra as Receipt;
            return SalePaymentScreen(
              receipt: receipt,
              onSubmit: (receipt) {
                context.pop(receipt);
              },
            );
          },
        ),
        ///paymentHistory
        GoRoute(
          path: '/paymentHistory',
          builder: (context, state) {
            final id = state.extra.toString();
            return PaymentHistory(partnerId: id);
          },
        ),
        ///customerHistory
        GoRoute(
          path: '/customerPaymentHistory',
          builder: (context, state) {
            final id = state.extra.toString();
            return CustomerPaymentHistoryScreen(partnerId: id);
          },
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
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
