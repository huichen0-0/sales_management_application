import 'package:flutter/material.dart';
import 'package:sales_management_application/config/constants.dart';

///bottom sheet của hiển thị NCC theo ...
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class DisplaySupplierBottomSheet extends StatelessWidget {
  final String selectedDisplay;
  final Function(String) onSelectDisplay;

  const DisplaySupplierBottomSheet(
      {super.key,
        required this.selectedDisplay,
        required this.onSelectDisplay});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(AppDisplay.totalPurchase),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay(AppDisplay.totalPurchase);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppDisplay.totalRefund),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay(AppDisplay.totalRefund);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

///bottom sheet của hiển thị khach hang theo ...
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class DisplayCustomerBottomSheet extends StatelessWidget {
  final String selectedDisplay;
  final Function(String) onSelectDisplay;

  const DisplayCustomerBottomSheet(
      {super.key,
        required this.selectedDisplay,
        required this.onSelectDisplay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(AppDisplay.totalSale),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay(AppDisplay.totalSale);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppDisplay.totalRefund),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay(AppDisplay.totalRefund);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

///bottom sheet của hiển thị khach hang theo ...
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class DisplayProductBottomSheet extends StatelessWidget {
  final String selectedDisplay;
  final Function(String) onSelectDisplay;

  const DisplayProductBottomSheet(
      {super.key,
        required this.selectedDisplay,
        required this.onSelectDisplay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Loại giá',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: const Text(AppDisplay.sellingPrice),
            trailing: selectedDisplay == AppDisplay.sellingPrice
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectDisplay(AppDisplay.sellingPrice);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppDisplay.capitalPrice),
            trailing: selectedDisplay == AppDisplay.capitalPrice
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectDisplay(AppDisplay.capitalPrice);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
///bottom sheet của giới tính
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class SexBottomSheet extends StatelessWidget {
  final String selectedSex;
  final Function(String) onSelectSex;

  const SexBottomSheet(
      {super.key,
        required this.selectedSex,
        required this.onSelectSex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Giới tính',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: const Text('Nam'),
            trailing: selectedSex == 'Nam'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSex('Nam');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Nữ'),
            trailing: selectedSex == 'Nữ'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSex('Nữ');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Khác'),
            trailing: selectedSex == 'Khác'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSex('Khác');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}