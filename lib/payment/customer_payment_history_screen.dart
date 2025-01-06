import 'package:flutter/material.dart';
import 'package:sales_management_application/invoice/invoice_filter.dart';
import 'package:sales_management_application/invoice/invoice_home_screen.dart';
import 'package:sales_management_application/order/order_filter.dart';
import 'package:sales_management_application/order/order_home_screen.dart';
import 'package:sales_management_application/return_sale/return_sale_filter.dart';
import 'package:sales_management_application/return_sale/return_sale_home_screen.dart';

class CustomerPaymentHistoryScreen extends StatefulWidget {
  //id ncc/kh
  final String partnerId;
  const CustomerPaymentHistoryScreen({super.key, required this.partnerId});

  @override
  State<CustomerPaymentHistoryScreen> createState() => _CustomerPaymentHistoryState();
}

class _CustomerPaymentHistoryState extends State<CustomerPaymentHistoryScreen> {
  int _pageIndex = 0; // vị trí page mặc định trên nav
  @override
  Widget build(BuildContext context) {
    //danh sách trang trên nav
    final List<Widget> pages = [
      OrderScreen(filter:  OrderFilter(), customerId: widget.partnerId,),
      InvoiceScreen(filter: InvoiceFilter(), customerId: widget.partnerId,),
      ReturnInvoiceScreen(filter: ReturnInvoiceFilter(), customerId: widget.partnerId,)
    ];
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
              icon: Icon(Icons.add_shopping_cart), label: 'Phiếu đặt hàng'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Hóa đơn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_return),
            label: 'Phiếu trả hàng',
          ),
        ],
      ),
      body: pages[_pageIndex],
    );
  }
}
