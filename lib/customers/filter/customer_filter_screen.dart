
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/authentication/forgot_password_screen.dart';
import 'package:sales_management_application/customers/controller/customer_controller.dart';

import '../view/customers_screen.dart';
import 'customer_filter.dart';
import '../../views/widgets/forms/date_range_field.dart';

/// hiển thị tùy chọn lọc cho trang /customers
class FilterCustomerScreen extends StatefulWidget {
  final CustomerFilter filter;
  FilterCustomerScreen({super.key, required this.filter});

  @override
  _FilterCustomerScreenState createState() => _FilterCustomerScreenState(this.filter);
}

class _FilterCustomerScreenState extends State<FilterCustomerScreen> {
  // Các biến lưu trữ trạng thái của các trường
  bool isActive = true; // Trạng thái: Đang hoạt động
  bool isInactive = false; // Trạng thái: Ngừng hoạt động
  bool isMale = true;
  bool isFemale = true;
  CustomerController controller = CustomerController();
  // Các TextEditingController cho Tổng bán , Nợ cần thu, số ngày nợ
  final TextEditingController purchaseFromController = TextEditingController();
  final TextEditingController purchaseToController = TextEditingController();
  final TextEditingController debtFromController = TextEditingController();
  final TextEditingController debtToController = TextEditingController();

  _FilterCustomerScreenState(CustomerFilter filter) {
    this.isActive = filter.isActive;
    this.isInactive = filter.isInactive;
    this.isMale = filter.isMan;
    this.isFemale = filter.isWoman;
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
              _buildRangeInputSection('Tổng bán', purchaseFromController, purchaseToController),
              const SizedBox(height: 16),
              // Nợ hiện tại
              _buildRangeInputSection('Nợ hiện tại', debtFromController, debtToController),
              const SizedBox(height: 16),
              // giới tinhs
              _buildSexSection(),
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
// hàm tạo phần chọn khoảng thời gian cho Ngày giao dịch cuối
  Widget _buildRangeDateSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const DateRangePickerField(),
      ],
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
  // hàm tạo phần giới tính
  Widget _buildSexSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Giới tính', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('Nam'),
          value: isMale, // tạm để biến cua status
          onChanged: (bool? value) {
            setState(() {
              isMale = !isMale;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Nữ'),
          value: isFemale,// tạm để biến cua status
          onChanged: (bool? value) {
            setState(() {
              isFemale = !isFemale;
            });
          },
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
              isActive = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Ngừng hoạt động'),
          value: isInactive,
          onChanged: (bool? value) {
            setState(() {
              isInactive = value ?? false;
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
      isInactive = false;
      purchaseFromController.clear();
      purchaseToController.clear();
      debtFromController.clear();
      debtToController.clear();
    });
  }

  // Hàm xử lý khi nhấn nút Áp dụng TODO: áp dụng vào trang /customers
  void _applyFilters() {
    CustomerFilter filter = controller.convertInputToFilter(isActive, isInactive, isMale, isFemale, purchaseFromController, purchaseToController, debtFromController, debtToController);
    context.pop(filter);
  }
}