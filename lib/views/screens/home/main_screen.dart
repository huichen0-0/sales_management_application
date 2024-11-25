import 'package:flutter/material.dart';
import 'package:sales_management_application/views/screens/home/overview_screen.dart';
import 'package:sales_management_application/views/screens/home/widgets_screen.dart';
import 'package:sales_management_application/views/screens/invoices/invoices_screen.dart';
import 'package:sales_management_application/views/screens/orders/orders_screen.dart';
import 'package:sales_management_application/views/screens/products/products_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 4; // vị trí page mặc định trên nav
  //danh sách trang trên nav
  final List<Widget> _pages = [
    const OverviewScreen(),
    const InvoiceScreen(),
    const OrderScreen(),
    ProductScreen(),
    const WidgetScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      //thanh nav chuyển trang
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.yellowAccent,
        unselectedItemColor: Colors.white,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart), label: 'Tổng quan'),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Hóa đơn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bán hàng',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.token), label: 'Hàng hóa'),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Tất cả'),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
