import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/invoice/invoice_filter.dart';
import 'package:sales_management_application/invoice/invoice_home_screen.dart';
import '/config/constants.dart';

class FilterInvoiceScreen extends StatefulWidget {
  InvoiceFilter filter = InvoiceFilter();
  FilterInvoiceScreen({super.key, required this.filter});

  @override
  State<FilterInvoiceScreen> createState() => _FilterInvoiceScreenState(this.filter);
}

class _FilterInvoiceScreenState extends State<FilterInvoiceScreen> {
  bool _isCompleted = true;
  bool _isTemp = true;
  late String selectedStatus;
  _FilterInvoiceScreenState(InvoiceFilter filter) {
    _isTemp = filter.isTemp;
    _isCompleted = filter.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.filterInvoiceReceipt),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(AppString.statusReceipt,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text(AppString.completed),
                    value: _isCompleted,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCompleted = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text(AppString.temporary),
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
                    const Text(AppString.reset, style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child:
                    const Text(AppString.apply, style: TextStyle(fontSize: 16)),
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
    // TODO: áp dụng bộ lọc
    InvoiceFilter filter = InvoiceFilter();
    filter.isCompleted = _isCompleted;
    filter.isTemp = _isTemp;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceScreen(filter: filter,),
      ),
    );
  }
}
