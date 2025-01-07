
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/authentication/forgot_password_screen.dart';

import '../suppliers/supplier_filter.dart';
import '../suppliers/suppliers_screen.dart';

/// hiển thị tùy chọn lọc cho trang /suppliers
class FilterSupplierScreen extends StatefulWidget {
  SupplierFilter filter = SupplierFilter();
  FilterSupplierScreen(this.filter, {super.key});

  @override
  _FilterSupplierScreenState createState() => _FilterSupplierScreenState(filter);
}

class _FilterSupplierScreenState extends State<FilterSupplierScreen> {
  // Các biến lưu trữ trạng thái của các trường
  SupplierFilter supplierFilter = SupplierFilter();
  bool isActive = true; // Trạng thái: Đang hoạt động
  bool isInactive = true; // Trạng thái: Ngừng hoạt động

  // Các TextEditingController cho Tổng mua và Nợ hiện tại
  TextEditingController lowerbound = TextEditingController();
  TextEditingController upperbound = TextEditingController();


  _FilterSupplierScreenState(SupplierFilter filter) {
    isActive = filter.isActive;
    isInactive = filter.isInactive;
    lowerbound.text = filter.purchaseLowerBound.toString();
    upperbound.text = filter.purchaseUpperBound.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Bộ lọc'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tổng mua
              _buildRangeInputSection('Tổng mua', lowerbound, upperbound),
              const SizedBox(height: 16),

              // Trạng thái
              _buildStatusSection(),
              const SizedBox(height: 16),

              // Nút Đặt lại và Áp dụng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _resetFilters,
                    child: const Text('Đặt lại', style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Áp dụng', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo phần nhập phạm vi (Từ - Đến) cho Tổng mua và Nợ hiện tại
  Widget _buildRangeInputSection(String title, TextEditingController fromController, TextEditingController toController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: fromController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Từ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: toController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Đến',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Hàm tạo phần Trạng thái
  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('Đang hoạt động'),
          value: isActive,
          onChanged: (bool? value) {
            setState(() {
              isActive = !isActive;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Ngừng hoạt động'),
          value: isInactive,
          onChanged: (bool? value) {
            setState(() {
              isInactive = !isInactive;
            });
          },
        ),
      ],
    );
  }

  // Hàm xử lý khi nhấn nút Đặt lại
  void _resetFilters() {
    setState(() {
      isActive = true;
      isInactive = true;
      lowerbound.clear();
      upperbound.clear();
    });
  }

  // Hàm xử lý khi nhấn nút Áp dụng TODO: áp dụng vào trang /suppliers
  void _applyFilters() {
    SupplierFilter filter = SupplierFilter();
    filter.isActive = isActive;
    filter.isInactive = isInactive;
    if (lowerbound.text.isEmpty) {
      filter.purchaseLowerBound = 0;
    } else {
      filter.purchaseLowerBound = int.parse(lowerbound.text);
    }
    if (upperbound.text.isEmpty) {
      filter.purchaseUpperBound = 0;
    } else {
      filter.purchaseUpperBound = int.parse(upperbound.text);
    }
    context.pop(filter);
  }
}