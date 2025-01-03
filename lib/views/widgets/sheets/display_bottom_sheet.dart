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
            title: const Text(AppString.totalPurchase),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay(AppString.totalPurchase);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppString.totalRefund),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay(AppString.totalRefund);
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
            title: const Text(AppString.totalSale),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay(AppString.totalSale);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppString.totalRefund),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay(AppString.totalRefund);
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
            title: const Text(AppString.sellingPrice),
            trailing: selectedDisplay == AppString.sellingPrice
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectDisplay(AppString.sellingPrice);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppString.capitalPrice),
            trailing: selectedDisplay == AppString.capitalPrice
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectDisplay(AppString.capitalPrice);
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
        ],
      ),
    );
  }
}
///bottom sheet của hiển thị khach hang theo ...
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class DisplayReceiptBottomSheet extends StatelessWidget {
  final String selectedDisplay;
  final Function(String) onSelectDisplay;
  final bool sale;

  const DisplayReceiptBottomSheet(
      {super.key,
        required this.selectedDisplay,
        required this.onSelectDisplay, required this.sale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(!sale) ListTile(
            title: const Text(AppString.totalImportValue),
            trailing: selectedDisplay == AppString.totalImportValue
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectDisplay(AppString.totalImportValue);
              Navigator.pop(context);
            },
          ),
          if(sale) ListTile(
            title: const Text(AppString.totalSaleValue),
            trailing: selectedDisplay == AppString.totalSaleValue
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectDisplay(AppString.totalSaleValue);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppString.totalPaid),
            trailing: selectedDisplay == AppString.totalPaid
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectDisplay(AppString.totalPaid);
              Navigator.pop(context);
            },
          ),
          if(!sale) ListTile(
            title: const Text(AppString.totalImportDue),
            trailing: selectedDisplay == AppString.totalImportDue
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectDisplay(AppString.totalImportDue);
              Navigator.pop(context);
            },
          ),
          if(sale) ListTile(
            title: const Text(AppString.totalSaleDue),
            trailing: selectedDisplay == AppString.totalSaleDue
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectDisplay(AppString.totalSaleDue);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}