import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// hiển thị tùy chọn lọc cho trang /suppliers
/// TODO: cần xử lý áp dung
class FilterSupplierScreen extends StatefulWidget {
  const FilterSupplierScreen({super.key});

  @override
  _FilterSupplierScreenState createState() => _FilterSupplierScreenState();
}

class _FilterSupplierScreenState extends State<FilterSupplierScreen> {
  // Các biến lưu trữ trạng thái của các trường
  bool isActive = true; // Trạng thái: Đang hoạt động
  bool isInactive = false; // Trạng thái: Ngừng hoạt động
  bool isSupplier = false; // Loại đối tác: Nhà cung cấp
  bool isCustomerSupplier = false; // Loại đối tác: Khách hàng - Nhà cung cấp

  // Các TextEditingController cho Tổng mua và Nợ hiện tại
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
              // Tổng mua
              _buildRangeInputSection('Tổng mua', purchaseFromController, purchaseToController),
              const SizedBox(height: 16),

              // Nợ hiện tại
              _buildRangeInputSection('Nợ hiện tại', debtFromController, debtToController),
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
      isSupplier = false;
      isCustomerSupplier = false;
      purchaseFromController.clear();
      purchaseToController.clear();
      debtFromController.clear();
      debtToController.clear();
    });
  }

  // Hàm xử lý khi nhấn nút Áp dụng TODO: áp dụng vào trang /suppliers
  void _applyFilters() {
    // Thực hiện logic áp dụng bộ lọc
    print('Áp dụng bộ lọc');
    print('Tổng mua từ: ${purchaseFromController.text} đến: ${purchaseToController.text}');
    print('Nợ hiện tại từ: ${debtFromController.text} đến: ${debtToController.text}');
    print('Trạng thái: ${isActive ? 'Đang hoạt động' : 'Ngừng hoạt động'}');
    print('Loại đối tác: ${isSupplier ? 'Nhà cung cấp' : ''} ${isCustomerSupplier ? 'Khách hàng - Nhà cung cấp' : ''}');
  }
}
////////////////////////////////////////////////////////////////////////////////
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
  final TextEditingController debtDaysFromController = TextEditingController();
  final TextEditingController debtDaysToController = TextEditingController();
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
              // Số ngày nợ
              _buildRangeInputSection('Số ngày nợ', debtDaysFromController, debtDaysToController),
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
          value: isActive, // tạm để biến cua status
          onChanged: (bool? value) {
            setState(() {
              //TODO: lấy gia tri
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Nữ'),
          value: isInactive,// tạm để biến cua status
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
    print('Tổng mua từ: ${purchaseFromController.text} đến: ${purchaseToController.text}');
    print('Nợ hiện tại từ: ${debtFromController.text} đến: ${debtToController.text}');
    print('Trạng thái: ${isActive ? 'Đang hoạt động' : 'Ngừng hoạt động'}');
  }
}
////////////////////////////////////////////////////////////////////////////////
