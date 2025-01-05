import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/authentication/forgot_password_screen.dart';
import 'package:sales_management_application/inventory_check/inventory_filter.dart';

import 'ic_home_screen.dart';

class FilterInventoryScreen extends StatefulWidget {
  InventoryFilter filter = InventoryFilter();
  FilterInventoryScreen(this.filter, {super.key});

  @override
  State<FilterInventoryScreen> createState() => _FilterInventoryScreenState(filter);
}

class _FilterInventoryScreenState extends State<FilterInventoryScreen> {
  bool _isCompleted = true;
  bool _isTemp = true;
  late String selectedStatus;
  InventoryFilter filter = InventoryFilter();
  _FilterInventoryScreenState(InventoryFilter filter) {
    _isCompleted = filter.isBalanced;
    _isTemp = filter.isTemp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bộ lọc phiếu kiểm kho'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Trạng thái phiếu',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('Đã cân bằng'),
                value: _isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    _isCompleted = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Phiếu tạm'),
                value: _isTemp,
                onChanged: (bool? value) {
                  setState(() {
                    _isTemp = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Nút Đặt lại và Áp dụng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _resetFilters,
                    child:
                    const Text('Đặt lại', style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child:
                    const Text('Áp dụng', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm đặt lại bộ lọc
  void _resetFilters() {
    setState(() {
      //đặt lại trạng thái
      _isCompleted = true;
      _isTemp = true;
    });
  }

  void _applyFilters() {
    InventoryFilter filter = InventoryFilter();
    filter.isBalanced = _isCompleted;
    filter.isTemp = _isTemp;
    context.pop(filter);
  }
}
