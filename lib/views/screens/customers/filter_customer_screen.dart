import 'package:flutter/material.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/views/widgets/forms/date_range_field.dart';
import 'package:sales_management_application/views/widgets/forms/number_range_field.dart';

/// hiển thị tùy chọn lọc cho trang /customers
/// TODO: cần xử lý áp dung
class FilterCustomerScreen extends StatefulWidget {
  const FilterCustomerScreen({super.key});

  @override
  _FilterCustomerScreenState createState() => _FilterCustomerScreenState();
}

class _FilterCustomerScreenState extends State<FilterCustomerScreen> {
  // Các biến lưu trữ trạng thái của các trường
  bool isActive = true; // Trạng thái: Đang hoạt động
  bool isInactive = false; // Trạng thái: Ngừng hoạt động

  // Các TextEditingController cho Tổng bán , Nợ cần thu, số ngày nợ
  final TextEditingController purchaseFromController = TextEditingController();
  final TextEditingController purchaseToController = TextEditingController();
  final TextEditingController debtFromController = TextEditingController();
  final TextEditingController debtToController = TextEditingController();

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
              // Ngày giao dịch cuối
              _buildRangeDateSection('Ngày giao dịch cuối'),
              const SizedBox(height: 16),
              // Tổng bans
              _buildRangeInputSection(
                  AppDisplay.totalSale, purchaseFromController, purchaseToController),
              const SizedBox(height: 16),
              // Tong tra
              _buildRangeInputSection(
                  AppDisplay.totalRefund, debtFromController, debtToController),
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
  Widget _buildRangeInputSection(
      String title,
      TextEditingController fromController,
      TextEditingController toController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        NumberRangeField(
          fromController: fromController,
          toController: toController,
          fromLabel: 'Từ',
          toLabel: 'Đến',
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
          value: isActive, // tạm để biến cua status
          onChanged: (bool? value) {
            setState(() {
              //TODO: lấy gia tri
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Nữ'),
          value: isInactive, // tạm để biến cua status
          onChanged: (bool? value) {
            setState(() {
              //TODO: lấy gia tri
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
    // Thực hiện logic áp dụng bộ lọc
    print('Áp dụng bộ lọc');
    print(
        'Tổng mua từ: ${purchaseFromController.text} đến: ${purchaseToController.text}');
    print('Trạng thái: ${isActive ? 'Đang hoạt động' : 'Ngừng hoạt động'}');
  }
}