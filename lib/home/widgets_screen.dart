import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/authentication/auth_controller.dart';
import '../authentication/users.dart';
import '../views/widgets/cards/customer_card.dart';

class WidgetScreen extends StatelessWidget {
  const WidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                WidgetCard(
                  title: 'Giao dịch',
                  items: [
                    {
                      'icon': Icons.receipt,
                      'label': 'Hóa đơn',
                      'action': () {
                        context.push('/invoice');
                      },
                    },
                    {
                      'icon': Icons.add_shopping_cart,
                      'label': 'Đặt hàng',
                      'action': () {
                        context.push('/orders');
                      },
                    },
                    {
                      'icon': Icons.assignment_return,
                      'label': 'Trả hàng',
                      'action': () {
                        context.push('/returnInvoice');
                      },
                    },
                  ],
                ),
                const SizedBox(height: 8,),
                WidgetCard(
                  title: 'Hàng hóa',
                  items: [
                    {
                      'icon': Icons.inventory,
                      'label': 'Hàng hóa',
                      'action': () {
                        context.push('/products');
                      },
                    },
                    {
                      'icon': Icons.check_box,
                      'label': 'Kiểm kho',
                      'action': () {
                        context.push('/inventory');
                      },
                    },
                    {
                      'icon': Icons.input,
                      'label': 'Nhập hàng',
                      'action': () {
                        context.push(AppPath.import);
                      },
                    },
                    {
                      'icon': Icons.assignment_return,
                      'label': 'Trả hàng nhập',
                      'action': () {
                        context.push(AppPath.returnImport);
                      },
                    },
                    {
                      'icon': Icons.cancel,
                      'label': 'Xuất hủy',
                      'action': () {
                        context.push('/ec');
                      },
                    },
                  ],
                ),
                const SizedBox(height: 8,),
                WidgetCard(
                  title: 'Đối tác',
                  items: [
                    {
                      'icon': Icons.person,
                      'label': 'Khách hàng',
                      'action': () {
                        context.push('/customers');
                      },
                    },
                    {
                      'icon': Icons.group,
                      'label': 'Nhà cung cấp',
                      'action': () {
                        context.push('/suppliers');
                      },
                    },
                  ],
                ),
                const SizedBox(height: 8,),
                WidgetCard(
                  title: 'Báo cáo',
                  color: Colors.white,
                  items: [
                    {
                      'icon': Icons.inventory_outlined,
                      'label': 'Hàng hóa',
                      'action': () {
                        context.push('/productStatistic');
                      },
                    },
                    {
                      'icon': Icons.area_chart,
                      'label': 'Bán hàng',
                      'action': () {
                        context.push('/saleStatistic');
                      },
                    },
                  ],
                ),
              ],
            ),
      );
  }
}


