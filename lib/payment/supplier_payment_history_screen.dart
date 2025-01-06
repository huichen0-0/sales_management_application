import 'package:flutter/material.dart';
import 'package:sales_management_application/import/import_filter.dart';
import 'package:sales_management_application/return_import/views/screens/return_import_home_screen.dart';

import '../import/import_home_screen.dart';
import '../return_import/return_import_filter.dart';
class PaymentHistory extends StatefulWidget {
  //id ncc/kh
  final String partnerId;
  const PaymentHistory({super.key, required this.partnerId});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  int _pageIndex = 0; // vị trí page mặc định trên nav
  @override
  Widget build(BuildContext context) {
    //danh sách trang trên nav
    final List<Widget> pages = [
      ImportScreen(filter: ImportFilter(),supplierId: widget.partnerId,),
      ReturnImportScreen(supplierId: widget.partnerId, filter: ReturnImportFilter(),),
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
              icon: Icon(Icons.assignment_returned), label: 'Phiếu nhập hàng'),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Phiếu trả hàng nhập',
          ),
        ],
      ),
      body: pages[_pageIndex],
    );
  }
}
