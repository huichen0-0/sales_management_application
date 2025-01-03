import 'package:flutter/material.dart';
import 'package:sales_management_application/order/order_home_screen.dart';
import '/config/constants.dart';
import 'order_filter.dart';

class FilterOrderScreen extends StatefulWidget {
  OrderFilter filter = OrderFilter();
  FilterOrderScreen({super.key, required this.filter});

  @override
  State<FilterOrderScreen> createState() => _FilterOrderScreenState(this.filter);
}

class _FilterOrderScreenState extends State<FilterOrderScreen> {
  bool _isCompleted = true;
  bool _isTemp = true;
  bool _isCancelled = false;
  late String selectedStatus;

  _FilterOrderScreenState(OrderFilter filter) {
    _isCompleted = filter.isFinished;
    _isTemp = filter.isTemp;
    _isCancelled = filter.isCancelled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.filterOrder),
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
                  CheckboxListTile(
                    title: const Text(AppString.canceled),
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

  //Hàm đặt lại bộ lọc
  void _resetFilters() {
    setState(() {
      //đặt lại trạng thái
      _isCompleted = true;
      _isTemp = true;
      _isCancelled = true;
    });
  }

  void _applyFilters() {
    OrderFilter filter = OrderFilter();
    filter.isFinished = _isCompleted;
    filter.isTemp = _isTemp;
    filter.isCancelled = _isCancelled;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderScreen(filter: filter),
      ),
    );
  }
}
