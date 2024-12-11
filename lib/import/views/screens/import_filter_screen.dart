import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilterImportScreen extends StatefulWidget {
  const FilterImportScreen({super.key});

  @override
  State<FilterImportScreen> createState() => _FilterImportScreenState();
}

class _FilterImportScreenState extends State<FilterImportScreen> {
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
                    title: const Text('Đã hoàn thành'),
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
    final Map<String, dynamic> filters = {
      'status' : {
        0 : _isCancelled,
        1 : _isTemp,
        3 : _isCompleted,
      }};
    context.pop(filters);
  }
}
