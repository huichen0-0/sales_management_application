import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async'; // để sử dụng Timer cho debounce

import '../suppliers/supplier-controller.dart';
import '../suppliers/supplier_filter.dart';
import '../suppliers/supplier.dart';

class SupplierSelectionSceen extends StatefulWidget {
  final void Function(Supplier supplier)
  onSupplierTap; // hàm xử lý khi chọn nhà cung cấp

  const SupplierSelectionSceen({
    super.key,
    required this.onSupplierTap,
  });

  @override
  State<SupplierSelectionSceen> createState() => _SupplierSelectionSceenState();
}

class _SupplierSelectionSceenState extends State<SupplierSelectionSceen> {
  // controller cho việc nhập liệu tìm kiếm
  final TextEditingController _textController = TextEditingController();
  final SupplierController supplierController = SupplierController();
  // danh sách tất cả nhà cung cấp
  List<Supplier> _allSuppliers = [];
  // danh sách nhà cung cấp đã lọc
  final ValueNotifier<List<Supplier>> _filteredSuppliers = ValueNotifier([]);
  // timer cho việc debounce tìm kiếm
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
    _textController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _debounceTimer?.cancel();
    _filteredSuppliers.dispose();
    super.dispose();
  }

  // hàm tải danh sách nhà cung cấp từ API
  Future<void> _loadSuppliers() async {
    final filter = SupplierFilter()..isInactive = false;
    final suppliers = await supplierController.getSupplierToSearch(filter);
    if (mounted) {
      setState(() {
        _allSuppliers = suppliers;
        _filteredSuppliers.value = List.from(suppliers); // hiển thị tất cả nhà cung cấp ban đầu
      });
    }
  }

  // hàm xử lý khi text trong ô tìm kiếm thay đổi (có debounce)
  void _onSearchTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _filterSuppliers(_textController.text);
    });
  }

  // hàm lọc danh sách nhà cung cấp dựa trên từ khóa tìm kiếm
  void _filterSuppliers(String searchText) {
    final String lowerSearchText = searchText.toLowerCase();
    final List<Supplier> results = _allSuppliers.where((supplier) {
      return supplier.name.toLowerCase().contains(lowerSearchText) ||
          supplier.phone.contains(lowerSearchText);
    }).toList();
    _filteredSuppliers.value = results;
  }

  // hàm xử lý khi nhấn vào icon x để xóa text tìm kiếm
  void _onCancelIconPressed() {
    _textController.clear();
    _filterSuppliers(''); // hiển thị lại tất cả nhà cung cấp
  }

  // hàm xử lý khi nhấn vào icon + để thêm nhà cung cấp mới
  void _onAddIconPressed() {
    context.push('/suppliers/add');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Chọn nhà cung cấp'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Chọn nhà cung cấp',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_textController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          onPressed: _onCancelIconPressed,
                        ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _onAddIconPressed,
                      ),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder<List<Supplier>>(
                valueListenable: _filteredSuppliers,
                builder: (context, suppliers, child) {
                  if (_allSuppliers.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (suppliers.isEmpty) {
                    return const Center(child: Text('Không tìm thấy nhà cung cấp'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: suppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = suppliers[index];
                      return ListTile(
                        title: Text(supplier.name),
                        leading: const Icon(Icons.person, size: 30),
                        trailing: Text(supplier.phone),
                        onTap: () {
                          widget.onSupplierTap(supplier);
                          _onCancelIconPressed();
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}