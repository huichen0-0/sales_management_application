import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/models/Supplier.dart';
import 'package:sales_management_application/repository/FirebaseService.dart';
import 'package:sales_management_application/views/screens/suppliers/supplier_detail_screen.dart';
import 'package:sales_management_application/views/widgets/custom_card.dart';
import 'package:sales_management_application/views/widgets/filter_list.dart';

import '../../widgets/custom_sheet.dart';
import 'add_supplier_screen.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  String selectedSorting = 'Mới nhất'; // Giá trị mặc định của sắp xếp
  String selectedDisplay = 'Tổng mua'; // Giá trị mặc định của tổng mua
  String selectedOption = 'Hôm nay'; //giá trị mặc định của lọc thời gian
  Map<String, Supplier> suppliers = new HashMap();

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
              // TODO: Xử lý tìm kiếm
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
              context.push('/suppliers/filter');
            },
          ),
        ],
      ),
      body:
          // items.isNotEmpty ? _buildItemList(context, items) : _buildEmptyView(),
        FutureBuilder<Map<String, Supplier>>(
          future: _getData(), // Pass the Future function here
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for data
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Handle any error that occurs during data fetching
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty && suppliers.isNotEmpty) {
              // When data is available, display the items list
              // items = snapshot.data!;
              return _buildItemList(context, suppliers);
            } else {
              // Handle case when no data is available
              return _buildEmptyView();
            }
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSupplierScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<Map<String, Supplier>> _getData() async {
    FirebaseService firebaseService = new FirebaseService();
    Map<String, Object> result = await firebaseService.readData("Suppliers");
    result.forEach((key, value) {
      Supplier mapValue = Supplier.fromJson(Map<dynamic, dynamic>.from(value as Map));
      suppliers[key] = mapValue;
    });
    return suppliers;
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
      BuildContext context, Map<String, Supplier> suppliers) {
    // Tính tổng mua từ danh sách nhà cung cấp TODO: thực hiện ở tầng logic
    double totalPurchase = suppliers.values.fold(0, (sum, item) => sum + item.amount);
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// nút lọc thời gian TODO: cần xử lý áp dụng
            // TextButton.icon(
            //   icon: const Icon(
            //     Icons.calendar_today,
            //     color: Colors.black,
            //   ),
            //   label: Text(
            //     selectedOption,
            //     style: const TextStyle(color: Colors.black),
            //   ),
            //   onPressed: () {
            //     _showTimeFilterOptions(context);
            //   },
            // ),

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
        for (var entry in suppliers.entries)
          SupplierCard(
            supplier: entry.value,
            onTap: (id) {
              context.push('/',)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupplierDetailScreen(id: entry.key, supplier: entry.value,),
                ),
              );
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
            // String formattedDate = endDate != null
            //     ? '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}'
            //     : DateFormat('dd/MM/yyyy').format(startDate);
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
          selectedSorting: selectedSorting,
          onSelectSorting: (option) {
            setState(() {
              selectedSorting = option;
            });
          },
        );
      },
    );
  }
}
