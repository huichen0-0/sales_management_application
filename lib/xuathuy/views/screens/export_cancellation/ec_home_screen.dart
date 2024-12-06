import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/controllers/sorting_controller.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'package:sales_management_application/xuathuy/controllers/ec_controller.dart';
import 'package:sales_management_application/xuathuy/models/ec_receipt.dart';
import 'package:sales_management_application/xuathuy/views/helper/helper.dart';
import 'package:sales_management_application/xuathuy/views/widgets/cards/ec_card.dart';

class ExportCancellationScreen extends StatefulWidget {
  const ExportCancellationScreen({super.key});

  @override
  _ExportCancellationScreenState createState() =>
      _ExportCancellationScreenState();
}

class _ExportCancellationScreenState extends State<ExportCancellationScreen> {
  // Giá trị mặc định của sắp xếp
  String selectedSorting = AppSort.newest;
  //giá trị mặc định của lọc thời gian
  String selectedOption = AppTime.thisMonth;
  //xuất hủy controller
  final ExportCancellationController _controller =
      ExportCancellationController();
  //controller sắp xếp
  SortingController? _sortingController;
  late Future<List<ExportCancellationReceipt>> _receiptsFuture;
  List<ExportCancellationReceipt>? _receipts;

  @override
  void initState() {
    super.initState();
    _receiptsFuture = _controller.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<ExportCancellationReceipt>>(
        future: _receiptsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Lỗi tải dữ liệu'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return _buildEmptyView();
          } else {
            _receipts = snapshot.data;
            if (_sortingController == null) {
              _sortingController = SortingController(_controller.convertToJSON(_receipts));
              _sortingController!.updateSorting(selectedSorting);
            }
            final sortedMap = _sortingController!.currentData;
            final receipts = _controller.convertFromJSON(sortedMap);
            return _buildItemList(context, receipts);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => context.push('/export_cancellation/add'),
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
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _controller.openSearchScreen(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => _showSortingOptions(context),
        ),
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          onPressed: () => context.push('/export_cancellation/filter'),
        ),
      ],
    );
  }

  // Widget hiển thị khi không có phiếu xuất hủy
  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Chưa có phiếu xuất hủy',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị danh sách phiếu xuất hủyWidget _buildItemList(
  Widget _buildItemList(
      BuildContext context, List<ExportCancellationReceipt> items) {
    final groupedItems =
        groupBy(items, (item) => Helper.formatDate(item.createdAt!));

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
                  onTap: (id) => context.push('/export_cancellation/$id'),
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
            print('Lựa chọn: $option, Bắt đầu: $startDate, Kết thúc: $endDate');
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
