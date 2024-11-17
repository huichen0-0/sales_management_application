import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sales_management_application/controllers/auth_controller.dart';
import 'package:sales_management_application/models/Users.dart';
import '../../widgets/cards/custom_card.dart';

class WidgetScreen extends StatelessWidget {
  const WidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Tạo một thể hiện của AuthController
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAccountInfoCard(
            context,
            [
              {
                'icon': Icons.lock,
                'label': 'Đổi mật khẩu',
                'action': () {
                  context.go('/reset_password');
                },
              },
              {
                'icon': Icons.logout,
                'label': 'Đăng xuất',
                'action': () {
                  context.go('/sell');
                },
              },
            ],
          ),
          WidgetCard(
            title: 'Giao dịch',
            items: [
              {
                'icon': Icons.shopping_bag,
                'label': 'Bán hàng',
                'action': () {
                  context.go('/sell');
                },
              },
              {
                'icon': Icons.receipt,
                'label': 'Hóa đơn',
                'action': () {
                  context.go('/invoices');
                },
              },
              {
                'icon': Icons.add_shopping_cart,
                'label': 'Đặt hàng',
                'action': () {
                  context.go('/orders');
                },
              },
              {
                'icon': Icons.assignment_return,
                'label': 'Trả hàng',
                'action': () {
                  context.go('/home');
                },
              },
            ],
          ),
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
                  context.go('/home');
                },
              },
              {
                'icon': Icons.assignment_return,
                'label': 'Trả hàng nhập',
                'action': () {
                  context.go('/home');
                },
              },
              {
                'icon': Icons.cancel,
                'label': 'Xuất hủy',
                'action': () {
                  context.go('/home');
                },
              },
            ],
          ),
          WidgetCard(
            title: 'Đối tác',
            items: [
              {
                'icon': Icons.person,
                'label': 'Khách hàng',
                'action': () {
                  context.go('/customers');
                },
              },
              {
                'icon': Icons.group,
                'label': 'Nhà cung cấp',
                'action': () {
                  context.go('/suppliers');
                },
              },
            ],
          ),
          WidgetCard(
            title: 'Báo cáo',
            items: [
              {
                'icon': Icons.insert_chart_outlined,
                'label': 'Cuối ngày',
                'action': () {
                  context.go('/home');
                },
              },
              {
                'icon': Icons.inventory_outlined,
                'label': 'Hàng hóa',
                'action': () {
                  context.go('/home');
                },
              },
              {
                'icon': Icons.area_chart,
                'label': 'Bán hàng',
                'action': () {
                  context.go('/home');
                },
              },
            ],
          ),
          WidgetCard(
            title: 'Cài đặt',
            items: [
              {
                'icon': Icons.inventory,
                'label': 'Hàng hóa',
                'action': () {
                  context.go('/home');
                },
              },
              {
                'icon': Icons.sell,
                'label': 'Bán hàng',
                'action': () {
                  context.go('/home');
                },
              },
              {
                'icon': Icons.group,
                'label': 'Đối tác',
                'action': () {
                  context.go('/home');
                },
              },
              {
                'icon': Icons.devices_other,
                'label': 'Ứng dụng & thiết bị',
                'action': () {
                  context.go('/home');
                },
              },
            ],
          ),
          WidgetCard(
            title: 'Về chúng tôi',
            items: [
              {
                'icon': Icons.menu_book,
                'label': 'Hướng dẫn sử dụng',
                'action': () {
                  context.go('/home');
                },
              },
              {
                'icon': Icons.event_note_outlined,
                'label': 'Điều khoản sử dụng',
                'action': () {
                  context.go('/tac');
                },
              },
              {
                'icon': Icons.phone,
                'label': 'Tổng đài 1900 0091',
                'action': () {
                  context.go('/home');
                },
              },
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildAccountInfoCard(
      BuildContext context, List<Map<String, dynamic>> items) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tài khoản',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LayTenDeHienThi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text('LayEmailDeHienThi', style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: items.map((item) {
                return TextButton(
                  onPressed: item['action'],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'],
                        size: 32,
                        color: Colors.lightBlue,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'],
                        style: const TextStyle(color: Colors.lightBlue),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}


