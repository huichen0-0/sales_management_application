import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/controllers/sorting_controller.dart';
import 'package:sales_management_application/views/widgets/cards/custom_card.dart';
import 'package:sales_management_application/views/widgets/search_bar.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'package:sales_management_application/models/Supplier.dart';
import 'package:sales_management_application/services/SupplierService.dart';
import 'package:sales_management_application/services/filter/SupplierFilter.dart';
import '../../widgets/custom_sheet.dart';

class SupplierScreen extends StatefulWidget {
  SupplierFilter filter = SupplierFilter();
  SupplierScreen(this.filter);

  @override
  _SupplierScreenState createState() => _SupplierScreenState(this.filter);
}

class _SupplierScreenState extends State<SupplierScreen> {
  SortingController _sortingController = SortingController([]);
  String selectedSorting = AppSort.newest; // Giá trị mặc định của sắp xếp
  String selectedDisplay = AppDisplay.totalPurchase; // Giá trị mặc định của tổng mua
  String selectedOption = AppTime.today; //giá trị mặc định của lọc thời gian
  SupplierService supplierService = SupplierService();
  List<Supplier> suppliers = [];
  List<Map<String, dynamic>> items = [];
  SupplierFilter filter = SupplierFilter();

  _SupplierScreenState(this.filter);

  /// Hàm format số tiền
  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Nhà cung cấp"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
        actions: [
          /// tìm kiếm
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (items.isEmpty) {
                items = supplierService.convertToJson(suppliers);
              }
              _openSearchPage();
            },
          ),

          /// sắp xếp
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Xử lý sắp xếp
              // Mở Bottom Sheet để chọn sắp xếp
              _showSortingOptions(context);
            },
          ),

          /// lọc
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              // TODO: Xử lý lọc
              context.push('/suppliers/filter', extra: this.filter);
            },
          ),
        ],
      ),
      body:
        FutureBuilder<List<Supplier>>(
          future: supplierService.getSupplierList(filter), // Pass the Future function here
          builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while waiting for data
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle any error that occurs during data fetching
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                suppliers = snapshot.data!;
                if (_sortingController.currentData.isNotEmpty) {
                  suppliers = supplierService.convertToSupplier(
                      _sortingController.currentData);
                }
                return _buildItemList(context, suppliers);
              } else {
                return _buildEmptyView();
              }
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/suppliers/add');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget hiển thị khi không có nhà cung cấp
  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Chưa có nhà cung cấp',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị danh sách nhà cung cấp
  Widget _buildItemList(
      BuildContext context, List<Supplier> suppliers) {
    // Tính tổng mua từ danh sách nhà cung cấp TODO: thực hiện ở tầng logic
    // suppliers.forEach((i) {print(i.toJson());});
    double totalPurchase = suppliers.fold(0, (sum, item) => sum + item.amount);
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// nút lọc thời gian TODO: cần xử lý áp dụng
            TextButton.icon(
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.black,
              ),
              label: Text(
                selectedOption,
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                _showTimeFilterOptions(context);
              },
            ),

            ///nút lọc hiển thị TODO: cần xử lý áp dụng
            TextButton.icon(
              onPressed: () {
                // Mở Bottom Sheet để chọn Tổng mua
                _showDisplayOptions(context);
              },
              label: Text(
                selectedDisplay,
                style: const TextStyle(color: Colors.black),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              iconAlignment: IconAlignment.end,
            ),

            //tổng tiền theo hiển thị TODO: thay đổi theo tùy chọn
            Text(
              formatCurrency(totalPurchase),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${suppliers.length} nhà cung cấp',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ///hiển thị danh sách nhà cung cấp
        for (var entry in suppliers)
          if (entry.isDeleted == false)
            SupplierCard(
              supplier: entry,
              onTap: (id) {
                context.push('/suppliers/${entry.id}', extra: [entry.id, entry]);
              },
            )
      ],
    );
  }

  /// Hiển thị Bottom Sheet cho tùy chọn hiển thị theo
  void _showDisplayOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DisplaySupplierBottomSheet(
          selectedDisplay: selectedDisplay,
          onSelectDisplay: (option) {
            setState(() {
              selectedDisplay = option;
              _sortingController.updateSorting(option, 'amount');
            });
          },
        );
      },
    );
  }

  /// hiển thị Bottom Sheet cho tùy chọn lọc thời gian
  void _showTimeFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TimeFilterBottomSheet(
          onOptionSelected: (option, startDate, [endDate]) {
            setState(() {
              selectedOption = option;
            });
          },
        );
      },
    );
  }

  /// Hiển thị Bottom Sheet cho tùy chọn sắp xếp
  void _showSortingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SortingBottomSheet(
          //đang tắt mới, cũ nhất
          showNewest: false,
          showOldest: false,
          selectedSorting: selectedSorting,
          onSelectSorting: (option) {
            setState(() {
              selectedSorting = option;
              //cập nhật ui đã sắp xếp
              items = supplierService.convertToJson(suppliers);
              _sortingController = SortingController(items);
              _sortingController.updateSorting(option, 'amount');
            });
          },
        );
      },
    );
  }

  // Hàm mở trang tìm kiếm
  Future<void> _openSearchPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchBarScreen(
          searchOptions: const [
            {'searchKey': 'name', 'tag': 'Tên', 'hint': 'Tìm theo tên'},
            {'searchKey': 'phone', 'tag': 'SĐT', 'hint': 'Tìm theo SĐT'},
            {'searchKey': 'email', 'tag': 'Email', 'hint': 'Tìm theo email'},
            {'searchKey': 'address', 'tag': 'Địa chỉ', 'hint': 'Tìm theo địa chỉ'},
            {'searchKey': 'notes', 'tag': 'Ghi chú', 'hint': 'Tìm theo ghi chú'},
          ],
          searchData: items,
          dataType: 'Suppliers',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: 'Tìm kiếm nhà cung cấp',
        ),
      ),
    );
  }
}
