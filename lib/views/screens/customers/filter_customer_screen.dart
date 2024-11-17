import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/models/FilterCustomer.dart';
import 'package:sales_management_application/views/widgets/forms/date_range_field.dart';
import 'package:sales_management_application/views/widgets/forms/number_range_field.dart';

/// hiển thị tùy chọn lọc cho trang /customers
/// TODO: cần xử lý áp dung (gần DONE, chưa lọc được theo ngày giao dịch cuối, chờ những module khác)
class FilterCustomerScreen extends StatefulWidget {
  final FilterCustomer? filterCustomer;
  const FilterCustomerScreen({super.key, this.filterCustomer});

  @override
  _FilterCustomerScreenState createState() => _FilterCustomerScreenState();
}

class _FilterCustomerScreenState extends State<FilterCustomerScreen> {
  // Các biến lưu trữ trạng thái của các trường
  bool isActive = true; // Trạng thái: Đang hoạt động
  bool isInactive = false; // Trạng thái: Ngừng hoạt động
  bool isMan = true; //Giới tính: Nam được chọn
  bool isWoman = false; //Giới tính: Nữ được chọn

  // Các TextEditingController cho Tổng bán , Tổng trả
  final TextEditingController purchaseFromController = TextEditingController();
  final TextEditingController purchaseToController = TextEditingController();
  final TextEditingController returnFromController = TextEditingController();
  final TextEditingController returnToController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    if (widget.filterCustomer != null) {
      // Thiết lập giá trị ban đầu từ filterCustomer
      purchaseFromController.text = formatCurrency(widget.filterCustomer!.fromSellAmount);
      purchaseToController.text = formatCurrency(widget.filterCustomer!.toSellAmount);
      returnFromController.text = formatCurrency(widget.filterCustomer!.fromReturnAmount);
      returnToController.text = formatCurrency(widget.filterCustomer!.toReturnAmount);
      isMan = widget.filterCustomer!.isMan;
      isWoman = widget.filterCustomer!.isWoman;
      isActive = widget.filterCustomer!.isActive;
      isInactive = widget.filterCustomer!.isInactive;
    }
  }

  /// Hàm format số tiền
  String formatCurrency(num? amount) {
    if(amount == null){
      return '';
    } else {
      final formatter = NumberFormat('#,###');
      return formatter.format(amount);
    }
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
              // Ngày giao dịch cuối
              _buildRangeDateSection('Ngày giao dịch cuối'),
              const SizedBox(height: 16),
              // Tổng bán
              _buildRangeInputSection(
                  AppDisplay.totalSale, purchaseFromController, purchaseToController),
              const SizedBox(height: 16),
              // Tổng trả
              _buildRangeInputSection(
                  AppDisplay.totalRefund, returnFromController, returnToController),
              const SizedBox(height: 16),
              // giới tính
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

  // Hàm tạo phần nhập phạm vi (Từ - Đến) cho Tổng mua và Tổng trả
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
          value: isMan,
          onChanged: (bool? value) {
            setState(() {
              isMan = value ?? false; //TODO: lấy giá tri (DONE)
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Nữ'),
          value: isWoman,
          onChanged: (bool? value) {
            setState(() {
              isWoman = value ?? false;//TODO: lấy gia tri (DONE)
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
      isMan = true;
      isWoman = false;
      purchaseFromController.clear();
      purchaseToController.clear();
      returnFromController.clear();
      returnToController.clear();
    });
  }

  // Hàm xử lý khi nhấn nút Áp dụng TODO: áp dụng vào trang /customers (gần DONE, chưa lọc được theo ngày giao dịch cuối, chờ những module khác)
  Future<void> _applyFilters() async {
    FilterCustomer filterCustomer = FilterCustomer(fromDate: null , toDate: null, 
                                                    fromSellAmount: convertStringToNum(purchaseFromController.text), 
                                                    toSellAmount: convertStringToNum(purchaseToController.text), 
                                                    fromReturnAmount: convertStringToNum(returnFromController.text), 
                                                    toReturnAmount: convertStringToNum(returnToController.text), 
                                                    isMan: isMan, isWoman: isWoman,
                                                    isActive: isActive, isInactive: isInactive
                                                  );
    context.pop(filterCustomer);
  }

  // Hàm chuyển giá trị nhập vào các textEdittingController của bộ lọc thành kiểu num
  num? convertStringToNum(String? input) {
    // Kiểm tra nếu input là null
    if (input == null) {
      return null;
    }
    
    // Loại bỏ khoảng trắng và dấu phẩy
    input = input.trim().replaceAll(',', '');

    try {
      if (input.isEmpty) {
        return null;
      }
      return num.parse(input); // Ép kiểu thành num
    } catch (e) {
      throw FormatException('Lỗi khi chuyển đổi: ${e.toString()}');
    }
  }
}
