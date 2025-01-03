import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/sort/sorting_controller.dart';
import 'package:sales_management_application/time_filter/time_filter_controller.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'package:sales_management_application/ec/ec_controller.dart';
import 'package:sales_management_application/views/widgets/cards/export_cancel_card.dart';

import '../helper/helper.dart';
import 'export_receipt.dart';
import 'ec_filter.dart';
import 'ec_update_screen.dart';

class ExportCancellationScreen extends StatefulWidget {
  EcFilter filter = EcFilter();
  ExportCancellationScreen(this.filter, {super.key});

  @override
  _ExportCancellationScreenState createState() => _ExportCancellationScreenState(filter);
}

class _ExportCancellationScreenState extends State<ExportCancellationScreen> {

  String selectedSorting = AppString.newest;
  String selectedOption = AppString.thisMonth;
  final ExportCancellationController ecController = ExportCancellationController();
  SortingController? _sortingController;
  TimeFilterController timeFilterController = TimeFilterController();
  DateTime? fromDate;
  DateTime? toDate;
  EcFilter filter = EcFilter();
  List<ExportCancellationReceipt> _receipts = [];
  _ExportCancellationScreenState(this.filter);

  @override
  Widget build(BuildContext context) {
    List<DateTime?> timeRange = timeFilterController.getTimeRange(selectedOption, fromDate, toDate);
    fromDate = timeRange[0]!;
    toDate = timeRange[1];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<ExportCancellationReceipt>>(
        future: ecController.getData(filter, selectedOption, fromDate, toDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            _receipts = snapshot.data!;
            if (_sortingController == null) {
              _sortingController = SortingController(ecController.convertToJSON(_receipts));
              _sortingController!.updateSorting(selectedSorting);
            }
            final sortedMap = _sortingController!.currentData;
            _receipts = ecController.convertFromJSON(sortedMap);
            return _buildItemList(context, _receipts);
          } else {
            return _buildEmptyView();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() =>
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateExportCancellationScreen(id: '', receipt: ExportCancellationReceipt.empty()),
              ),
            ),
            // context.go('/ec/add'),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

//Widget hiển thị appbar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text('Xuất hủy'),
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
            ecController.openSearchScreen(context, _receipts);
          },
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => _showSortingOptions(context),
        ),
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          onPressed: () => context.push('/ec/filter', extra: filter),
        ),
      ],
    );
  }

  // Widget hiển thị khi không có phiếu xuất hủy
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

  // Widget hiển thị danh sách phiếu xuất hủy Widget _buildItemList(
  Widget _buildItemList(BuildContext context, List<ExportCancellationReceipt> items) {
    final groupedItems = groupBy(items, (item) => Helper.formatDate(item.createdAt));
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        //hiển thị nút lọc thời gian
        _buildTimeFilterRow(context),
        const SizedBox(height: 10),

        /// Hiển thị tổng số phiếu
        Text(
          '${items.length} phiếu xuất hủy',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        /// Hiển thị danh sách phiếu theo nhóm ngày
        for (var group in groupedItems.entries)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.key,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              for (var item in group.value)
                ExportCancellationReceiptCard(
                  receipt: item,
                  onTap: (id) => context.push('/ec/$id', extra: [item.id, item.toJSON1()]),
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
            // Xử lý lựa chọn thời gian
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
              _sortingController!.updateSorting(option);
            });
          },
        );
      },
    );
  }
}
