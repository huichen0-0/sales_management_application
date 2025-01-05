import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/time_filter/time_filter_controller.dart';
import '../../../helper/helper.dart';
import '../../../views/widgets/search_bars/search_note_screen.dart';
import '../../../views/widgets/sheets/display_bottom_sheet.dart';
import '../../controller/return_import_controller.dart';
import '../../model/return_import_receipt.dart';
import '../../return_import_filter.dart';
import '../widgets/return_import_card.dart';
import '/config/constants.dart';
import '/views/widgets/sheets/sorting_bottom_sheet.dart';
import '/views/widgets/sheets/time_filter_bottom_sheet.dart';

class ReturnImportScreen extends StatefulWidget {
  final String? supplierId;
  ReturnImportFilter filter;
  ReturnImportScreen({super.key, this.supplierId, required this.filter});

  @override
  ReturnImportScreenState createState() => ReturnImportScreenState(filter);
}

class ReturnImportScreenState extends State<ReturnImportScreen> {
  //biến lưu tùy chọn sắp xếp
  String _selectedSorting = AppString.newest;

  //biến lưu tùy chọn loọc thơời gian
  String _selectedOption = AppString.allTime;

  //Biến lưu tùy chọn hiển thị
  String _selectedDisplay = AppString.totalReturnAmount;

  //biến lưu thuộc tính hiển thị
  String _displayAttribute = AppAttribute.totalSaleValue;

  //biến lưu thời gian lọc
  DateTime? fromDate;
  DateTime? toDate;
  TimeFilterController timeFilterController = TimeFilterController();

  //controller trả hàng nhập
  final ReturnImportController _controller = ReturnImportController();

  //lưu dữ liệu ban đầu
  List<ReturnImportReceipt>? _receipts;
  ReturnImportFilter filter = ReturnImportFilter();
  ReturnImportController controller= ReturnImportController();
  ReturnImportScreenState(this.filter);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<ReturnImportReceipt>>(
        future: controller.getData(filter, _selectedOption, fromDate, toDate, widget.supplierId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return _buildEmptyView();
          } else {
            _receipts = snapshot.data;
            //sắp xếp
            _receipts = _controller.sortReceipts(
                _receipts!, _selectedSorting);
            return _buildItemList(context, _receipts!);
          }
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text(AppString.returnImport, style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.pop();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            _openSearchScreen();
          },
        ),
        IconButton(
          icon: const Icon(Icons.sort, color: Colors.white),
          onPressed: () => _showSortingOptions(context),
        ),
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
          onPressed: () => _openFilterScreen(),
        ),
      ],
    );
  }

  Widget _buildEmptyView() {
    return ListView(
        children: [
          TextButton.icon(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            label: Text(_selectedOption,
                style: const TextStyle(color: Colors.black)),
            onPressed: () {
              _showTimeFilterOptions();
            },
          ),
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

  Widget _buildItemList(
      BuildContext context, List<ReturnImportReceipt> receipts) {
    final groupedReceipts = groupBy(receipts, (item) => Helper.formatDate(item.createdAt));
    final totalDisplayValue = Helper.formatCurrency(_controller.getTotalDisplayValue(_displayAttribute, receipts));
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.calendar_today, color: Colors.black),
              label: Text(_selectedOption,
                  style: const TextStyle(color: Colors.black)),
              onPressed: () {
                _showTimeFilterOptions();
              },
            ),

            ///nút lọc hiển thị TODO: cần xử lý áp dụng
            TextButton.icon(
              onPressed: null,
              label: Text(
                _selectedDisplay,
                style: const TextStyle(color: Colors.black),
              ),
            ),

            //tổng tiền theo hiển thị TODO: thay đổi theo tùy chọn
            Text(
              totalDisplayValue,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${receipts.length} phiếu trả hàng nhập',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        for (var group in groupedReceipts.entries)
          Column(
            children: [
              Text(group.key,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              for (var receipt in group.value)
                ReturnImportReceiptCard(
                  displayValue: _displayAttribute,
                  receipt: receipt,
                  onTap: (id) {
                    return context.push('${AppPath.returnImport}/$id', extra: receipt);
                  },
                ),
            ],
          ),
      ],
    );
  }

  void _showTimeFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TimeFilterBottomSheet(
          selectedOption: _selectedOption,
          onOptionSelected: (option, startDate, [endDate]) {
            setState(() {
              _selectedOption = option;
              List<DateTime?> timeRange = timeFilterController.getTimeRange(_selectedOption, startDate, endDate);
              fromDate = timeRange[0]!;
              toDate = timeRange[1];
            });
          },
        );
      },
    );
  }

  // /// Hiển thị Bottom Sheet cho tùy chọn hiển thị theo
  void _showDisplayOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DisplayReceiptBottomSheet(
          sale: false,
          selectedDisplay: _selectedDisplay,
          onSelectDisplay: (option) {
            _displayAttribute = Helper.getAttribute(option);
            setState(() {
              _selectedDisplay = option;
            });
          },
        );
      },
    );
  }

  void _showSortingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SortingBottomSheet(
          showAZ: false,
          showZA: false,
          showAscendingValue: false,
          showDescendingValue: false,
          selectedSorting: _selectedSorting,
          onSelectSorting: (option) {
            setState(() {
              _selectedSorting = option;
            });
          },
        );
      },
    );
  }

  // Hàm mở trang tìm kiếm phiếu kiểm
  Future<void> _openSearchScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchNoteScreen(
          searchOptions: const [
            {
              'searchKey': AppAttribute.details,
              'tag': AppString.product,
              'hint': AppString.searchProductHint
            },
            {
              'searchKey': AppAttribute.supplier,
              'tag': AppString.supplier,
              'hint': AppString.searchSupplierHint
            },
          ],
          //chuyển sang map để tìm kiếm
          searchData: _controller.convertToJSON(_receipts),
          dataType: 'returnImport',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: AppString.searchReturnImportReceipt,
          itemBuilder: (item) {
            return ReturnImportReceiptCard(
              displayValue: _displayAttribute,
              receipt: ReturnImportReceipt.fromJson(item),
              //chuyển về object
              onTap: (id) => context.push('/returnImport/$id', extra: ReturnImportReceipt.fromJson(item)),
            );
          },
        ),
      ),
    );
  }

  // Hàm này được gọi khi bạn trở lại từ trang lọc và nhận được kết quả
  Future<void> _openFilterScreen() async {
    final result = await context.push(AppPath.returnImportFilter, extra: filter);
    // Đường dẫn đến trang lọc
    if (result != null && result is ReturnImportFilter) {
      setState(() {
        filter = result;
      });
    }
  }
}
