import 'package:flutter/material.dart';
import '../../invoice/invoice_filter.dart';
import '../../invoice/invoice_home_screen.dart';
import '../../return_sale/return_sale_filter.dart';
import '../../return_sale/return_sale_home_screen.dart';

class DailySaleStatisticScreen extends StatefulWidget {
  //id ncc/kh
  final DateTime statisticDate;
  const DailySaleStatisticScreen({super.key, required this.statisticDate});

  @override
  State<DailySaleStatisticScreen> createState() => _DailySaleStatisticScreen();
}

class _DailySaleStatisticScreen extends State<DailySaleStatisticScreen> {
  int _pageIndex = 0; // vị trí page mặc định trên nav
  @override
  Widget build(BuildContext context) {
    //danh sách trang trên nav
    final List<Widget> pages = [
      InvoiceScreen(filter: InvoiceFilter(), date: widget.statisticDate,),
      ReturnInvoiceScreen(filter: ReturnInvoiceFilter(), date: widget.statisticDate,),
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
              icon: Icon(Icons.add_shopping_cart), label: 'Hóa đơn bán hàng'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Hóa đơn trả hàng',
          ),
        ],
      ),
      body: pages[_pageIndex],
    );
  }
}