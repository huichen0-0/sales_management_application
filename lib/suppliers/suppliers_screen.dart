import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/sort/sorting_controller.dart';
import 'package:sales_management_application/suppliers/supplier-controller.dart';
import 'package:sales_management_application/suppliers/supplier.dart';
import 'package:sales_management_application/time_filter/time_filter_controller.dart';
import 'package:sales_management_application/views/widgets/cards/customer_card.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'package:sales_management_application/suppliers/supplier_service.dart';
import '../helper/helper.dart';
import '../search/search_bar.dart';
import 'supplier_filter.dart';

class SupplierScreen extends StatefulWidget {
  SupplierFilter filter = SupplierFilter();
  SupplierScreen(this.filter, {super.key});

  @override
  _SupplierScreenState createState() => _SupplierScreenState(filter);
}

class _SupplierScreenState extends State<SupplierScreen> {
  SortingController _sortingController = SortingController([]);
  String selectedSorting = AppString.newest; // Giá trị mặc định của sắp xếp
  String selectedDisplay = AppString.totalPurchase; // Giá trị mặc định của tổng mua
  String selectedOption = AppString.today; //giá trị mặc định của lọc thời gian
  DateTime? fromDate;
  DateTime? toDate;
  TimeFilterController timeFilterController = TimeFilterController();
  SupplierController supplierController = SupplierController();
  List<Supplier> suppliers = [];
  List<Map<String, dynamic>> items = [];
  SupplierFilter filter = SupplierFilter();
  num total =0;

  _SupplierScreenState(this.filter);

  /// Hàm format số tiền
  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime?> timeRange = timeFilterController.getTimeRange(selectedOption, fromDate, toDate);
    fromDate = timeRange[0];
    toDate = timeRange[1];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Nhà cung cấp"),
        actions: [
          /// tìm kiếm
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (items.isEmpty) {
                items = supplierController.convertToJson(suppliers);
              }
              _openSearchPage();
            },
          ),

          /// sắp xếp
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Mở Bottom Sheet để chọn sắp xếp
              _showSortingOptions(context);
            },
          ),

          /// lọc
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              context.push('/suppliers/filter', extra: filter)
              .then((result) {
                if (result != null && result is SupplierFilter) {
                  setState(() {
                    filter = result;
                    //gán filter
                  });
                }
              });;
            },
          ),
        ],
      ),
      body:
        FutureBuilder<List<Supplier>>(
          future: supplierController.getSupplierList(filter, selectedDisplay, fromDate, toDate), // Pass the Future function here
          builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while waiting for data
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle any error that occurs during data fetching
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                suppliers = snapshot.data!;

                total = getTotal();
                if (_sortingController.currentData.isNotEmpty) {
                  suppliers = supplierController.convertToSupplier(
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
          context.push('/suppliers/add')
          .then((result) {
            if (result != null && result is Supplier) {
              setState(() {
                //gán filter
              });
            }
          });
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget hiển thị khi không có nhà cung cấp
  Widget _buildEmptyView() {
    return ListView(
        children: [
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
          const SizedBox(height: 60),
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 100, color: Colors.blue),
                  SizedBox(height: 30),
                  Text(
                    'Chưa có nhà cung cấp',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ]
    );
  }

  // Widget hiển thị danh sách nhà cung cấp
  Widget _buildItemList(BuildContext context, List<Supplier> suppliers) {
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
              Helper.formatCurrency(total),
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
            SupplierCard(
                supplier: entry,
                onTap: (id) {
                  context.push('/suppliers/${entry.id}');
                },
                fromDate: fromDate,
                toDate: toDate,
                selectedDisplay: selectedDisplay
            )
      ],
    );
  }

  num getTotal()  {
    num result = 0;
    for(Supplier supplier in suppliers) {
        result += supplier.amount;
    }
    return result;
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
              // _sortingController.updateSorting(option, 'amount');
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
          selectedOption: selectedOption,
          onOptionSelected: (option, startDate, [endDate]) {
            setState(() {
              selectedOption = option;
              List<DateTime?> timeRange = timeFilterController.getTimeRange(selectedOption, startDate, endDate);
              fromDate = timeRange[0];
              toDate = timeRange[1];
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
              items = supplierController.convertToJson(suppliers);
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
          dataType: 'suppliers',
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
