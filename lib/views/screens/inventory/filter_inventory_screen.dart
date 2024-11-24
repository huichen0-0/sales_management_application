import 'package:flutter/material.dart';
import 'package:sales_management_application/views/widgets/forms/ratio_field.dart';

class FilterInventoryScreen extends StatefulWidget {
  const FilterInventoryScreen({super.key});

  @override
  State<FilterInventoryScreen> createState() => _FilterInventoryScreenState();
}

class _FilterInventoryScreenState extends State<FilterInventoryScreen> {
  late String selectedStatus;

  // Sử dụng GlobalKey để tham chiếu đến trạng thái của RatioField
  final GlobalKey<RatioFieldState> _ratioFieldKey = GlobalKey<RatioFieldState>();

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
              RatioField(
                key: _ratioFieldKey, // Gán key cho RatioField
                title: 'Trạng thái phiếu',
                options: const [
                  'Đã cân bằng',
                  'Phiếu tạm',
                  'Đã hủy',
                ],
                onChanged: (value) {
                  selectedStatus = value;
                },
              ),
              const SizedBox(height: 20),

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

  // Hàm đặt lại bộ lọc
  void _resetFilters() {
    setState(() {
      // Gọi hàm reset của RatioField để đặt lại trạng thái
      _ratioFieldKey.currentState?.reset();
    });
  }

  void _applyFilters() {
    // TODO: áp dụng bộ lọc
  }
}
