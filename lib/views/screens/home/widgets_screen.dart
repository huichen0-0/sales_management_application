import 'package:flutter/material.dart';
import '../../widgets/custom_card.dart';

class WidgetScreen extends StatelessWidget {
  const WidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          WidgetCard(
            title: 'Tài khoản',
            items: [
              {'icon': Icons.person, 'label': 'Thông tin', 'link': '/home'},
              {'icon': Icons.lock, 'label': 'Đổi mật khẩu', 'link': '/reset_password'},
              {'icon': Icons.logout, 'label': 'Đăng xuất', 'link': '/'},
            ],
          ),
          WidgetCard(
            title: 'Giao dịch',
            items: [
              {'icon': Icons.shopping_bag, 'label': 'Bán hàng', 'link': '/order'},
              {'icon': Icons.receipt, 'label': 'Hóa đơn', 'link': '/invoice'},
              {'icon': Icons.add_shopping_cart, 'label': 'Đặt hàng', 'link': '/order'},
              {'icon': Icons.assignment_return, 'label': 'Trả hàng', 'link': '/home'},
            ],
          ),
          WidgetCard(
            title: 'Hàng hóa',
            items: [
              {'icon': Icons.inventory, 'label': 'Hàng hóa', 'link': '/product'},
              {'icon': Icons.check_box, 'label': 'Kiểm kho', 'link': '/home'},
              {'icon': Icons.input, 'label': 'Nhập hàng', 'link': '/home'},
              {'icon': Icons.assignment_return, 'label': 'Trả hàng nhập', 'link': '/home'},
              {'icon': Icons.cancel, 'label': 'Xuất hủy', 'link': '/home'},
            ],
          ),
          WidgetCard(
            title: 'Đối tác',
            items: [
              {'icon': Icons.person, 'label': 'Khách hàng', 'link': '/customers'},
              {'icon': Icons.group, 'label': 'Nhà cung cấp', 'link': '/suppliers'},
            ],
          ),
          WidgetCard(
            title: 'Báo cáo',
            items: [
              {'icon': Icons.insert_chart_outlined, 'label': 'Cuối ngày', 'link': '/home'},
              {'icon': Icons.inventory_outlined, 'label': 'Hàng hóa', 'link': '/home'},
              {'icon': Icons.area_chart, 'label': 'Bán hàng', 'link': '/home'},
            ],
          ),
          WidgetCard(
            title: 'Cài đặt',
            items: [
              {'icon': Icons.inventory, 'label': 'Hàng hóa', 'link': '/product'},
              {'icon': Icons.sell, 'label': 'Bán hàng', 'link': '/home'},
              {'icon': Icons.group, 'label': 'Đối tác', 'link': '/home'},
              {'icon': Icons.devices_other, 'label': 'Ứng dụng & thiết bị', 'link': '/home'},
            ],
          ),
          WidgetCard(
            title: 'Về chúng tôi',
            items: [
              {'icon': Icons.menu_book, 'label': 'Hướng dẫn sử dụng', 'link': '/product'},
              {'icon': Icons.event_note_outlined, 'label': 'Điều khoản sử dụng', 'link': '/tac'},
              {'icon': Icons.phone, 'label': 'Tổng đài 1900 0091', 'link': '/home'},
            ],
          ),
        ],
      ),
    );
  }
}