import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/authentication/forgot_password_screen.dart';
import 'package:sales_management_application/ec/ec_filter.dart';

import 'view/ec_home_screen.dart';

class FilterExportCancellationScreen extends StatefulWidget {
  EcFilter filter = EcFilter();
  FilterExportCancellationScreen(this.filter, {super.key});

  @override
  State<FilterExportCancellationScreen> createState() => _FilterExportCancellationScreenState(filter);
}

class _FilterExportCancellationScreenState extends State<FilterExportCancellationScreen> {
  bool _isCompleted = true;
  bool _isTemp = true;
  late String selectedStatus;
  EcFilter filter = EcFilter();
  _FilterExportCancellationScreenState(EcFilter filter) {
   _isCompleted = filter.isFinished;
   _isTemp = filter.isTemp;
  }

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
    });
  }

  void _applyFilters() {
    EcFilter filter = EcFilter();
    filter.isFinished = _isCompleted;
    filter.isTemp = _isTemp;
    context.pop(filter);
  }
}
