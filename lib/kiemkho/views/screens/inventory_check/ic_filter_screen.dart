import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilterInventoryScreen extends StatefulWidget {
  const FilterInventoryScreen({super.key});

  @override
  State<FilterInventoryScreen> createState() => _FilterInventoryScreenState();
}

class _FilterInventoryScreenState extends State<FilterInventoryScreen> {
  bool _isCompleted = true;
  bool _isTemp = true;
  bool _isCancelled = false;
  late String selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bộ lọc phiếu nhập hàng'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  CheckboxListTile(
                    title: const Text('Đã hủy'),
                    value: _isCancelled,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCancelled = value ?? false;
                      });
                    },
                  ),
                ],
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
      _isCancelled = false;
    });
  }

  void _applyFilters() {
    // TODO: áp dụng bộ lọc
    context.pop();
  }
}
