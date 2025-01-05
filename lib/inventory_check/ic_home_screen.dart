import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/inventory_check/inventory_controller.dart';
import 'package:sales_management_application/sort/sorting_controller.dart';
import 'package:sales_management_application/inventory_check/inventory_filter.dart';
import 'package:sales_management_application/time_filter/time_filter_controller.dart';
import 'package:sales_management_application/views/widgets/cards/inventory_receipt_card.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/time_filter_bottom_sheet.dart';
import '../helper/helper.dart';
import 'ic_update_screen.dart';
import 'inventory_check_receipt.dart';

class InventoryScreen extends StatefulWidget {
  InventoryFilter filter = InventoryFilter();
  InventoryScreen(this.filter, {super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState(filter);
}

class _InventoryScreenState extends State<InventoryScreen> {
  // Giá trị mặc định của sắp xếp
  String selectedSorting = AppString.newest;
  String selectedOption = AppString.thisMonth;
  final InventoryController _controller = InventoryController();
  TimeFilterController timeFilterController = TimeFilterController();
  InventoryFilter filter = InventoryFilter();
  SortingController _sortingController = SortingController([]);
  List<InventoryCheckReceipt>? _receipts = [];
  DateTime? fromDate;
  DateTime? toDate;
  _InventoryScreenState(this.filter);

  @override @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime?> timeRange = timeFilterController.getTimeRange(selectedOption, fromDate, toDate);
    fromDate = timeRange[0]!;
    toDate = timeRange[1];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body:FutureBuilder<List<InventoryCheckReceipt>>(
        future: _controller.getData(filter, fromDate, toDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            _receipts = snapshot.data!;
            _sortingController?.currentData = _controller.convertToJSON(_receipts);
            _sortingController!.updateSorting(selectedSorting);
            final sortedMap = _sortingController!.currentData;
            _receipts = _controller.convertFromJSON(sortedMap);
            return _buildItemList(context, _receipts!);
          } else {
            return _buildEmptyView();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() =>
            context.push('/inventory/add'),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
  //Widget hiển thị appbar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text('Kiểm kho'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _controller.openSearchScreen(context, _receipts!);
          },
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => _showSortingOptions(context),
        ),
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          onPressed: () => context.push('/inventory/filter', extra: filter)
          .then((result) {
            if (result != null && result is InventoryFilter) {
              setState(() {
                filter = result;
              });
            }
          }),
        ),
      ],
    );
  }

  // Widget hiển thị khi không có phiếu kiểm kho
  Widget _buildEmptyView() {
    return ListView(
        children: [
          _buildTimeFilterRow(context),
          const SizedBox(height: 32),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.remove_shopping_cart, size: 100, color: Colors.blue),
                SizedBox(height: 20),
                Text(
                  'Chưa có phiếu xuất hủy',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ]
    );
  }

  // Widget hiển thị danh sách phiếu kiểm kho
  Widget _buildItemList(
      BuildContext context, List<InventoryCheckReceipt> receipts) {
    // Nhóm danh sách theo ngày
    final groupedReceipts =
    groupBy(receipts, (item) => Helper.formatDate(item.createdAt));
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        //hiển thị nút lọc thời gian
        _buildTimeFilterRow(context),
        const SizedBox(height: 10),
        //Hiển thị tổng phiếu
        Text(
          '${receipts.length} phiếu kiểm kho',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        //hiển thị danh sách phiếu nhóm theo ngày
        for (var group in groupedReceipts.entries)
          Column(
            children: [
              Text(group.key,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              //hiển thị danh sách phiếu kiểm kho trong ngày
              for (var receipt in group.value)
                InventoryCheckReceiptCard(
                  receipt: receipt,
                  onTap: (id) {
                    return context.push('/inventory/$id', extra: [receipt.id, receipt.toJSON1()]);
                  },
                ),
            ],
          ),
      ],
    );
  }
  //Hiển thị nút lọc thời gian
  Row _buildTimeFilterRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Nút lọc thời gian
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
      ],
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
              fromDate = timeRange[0]!;
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
          //tăts các tùy chọn sort không cần thiết
          showAZ: false,
          showZA: false,
          showAscendingValue: false,
          showDescendingValue: false,
          selectedSorting: selectedSorting,
          onSelectSorting: (option) {
            setState(() {
              selectedSorting = option;
              //cập nhật ui đã sắp xếp
              _sortingController?.updateSorting(option);
            });
          },
        );
      },
    );
  }
}
