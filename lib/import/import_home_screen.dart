import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/import/import_filter.dart';
import 'package:sales_management_application/suppliers/supplier_filter.dart';
import 'package:sales_management_application/time_filter/time_filter_controller.dart';
import '../../../views/widgets/search_bars/search_note_screen.dart';
import '../../../views/widgets/sheets/display_bottom_sheet.dart';
import '../helper/helper.dart';
import '../views/widgets/cards/import_card.dart';
import 'import_controller.dart';
import '/config/constants.dart';
import '/views/widgets/sheets/sorting_bottom_sheet.dart';
import '/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'import_receipt.dart';

class ImportScreen extends StatefulWidget {
  final String? supplierId;
  ImportFilter filter;
  ImportScreen({super.key, this.supplierId, required this.filter});

  @override
  _ImportScreenState createState() => _ImportScreenState(filter);
}

class _ImportScreenState extends State<ImportScreen> {
  //biến lưu tùy chọn sắp xếp
  String _selectedSorting = AppString.newest;

  //biến lưu tùy chọn loọc thời gian
  String _selectedOption = AppString.allTime;

  //Biến lưu tùy chọn hiển thị
  String _selectedDisplay = AppString.totalAmount;

  //biến lưu thuộc tính hiển thị
  String _displayAttribute = AppAttribute.totalCapitalValue;

  //biến lưu thời gian lọc
  DateTime? fromDate;
  DateTime? toDate;

  // controller nhập hàng
  final ImportController _controller = ImportController();

  //dữ liệu lấy từ db
  late Future<List<ImportReceipt>> _receiptsFuture;

  //dữ liệu sau khi lấy
  List<ImportReceipt>? _receipts;

  ImportFilter filter;
  ImportController importController = ImportController();
  TimeFilterController timeFilterController = TimeFilterController();
  _ImportScreenState(this.filter);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime?> timeRange = timeFilterController.getTimeRange(_selectedOption, fromDate, toDate);
    fromDate = timeRange[0]!;
    toDate = timeRange[1];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<ImportReceipt>>(
        future: importController.getData(filter, fromDate, toDate, widget.supplierId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // return const Center(child: Text(AppString.errorLoadingData));
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            _receipts = snapshot.data;

            //sắp xếp
            _receipts = _controller.sortReceipts(
                _receipts!, _selectedSorting);

            return _buildItemList(context, _receipts!);
          } else {
            return _buildEmptyView();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppPath.importAdd),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text(AppString.import, style: TextStyle(color: Colors.white)),
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

  Widget _buildItemList(BuildContext context, List<ImportReceipt> receipts) {
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
              onPressed: () {
                // Mở Bottom Sheet để chọn Tổng mua
                _showDisplayOptions(context);
              },
              label: Text(
                _selectedDisplay,
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
          '${receipts.length} phiếu nhập hàng',
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
                ImportReceiptCard(
                  displayValue: _selectedDisplay,
                  receipt: receipt,
                  onTap: (id) {
                    return context.push('${AppPath.import}/$id', extra: receipt);
                  },
                  fromDate: fromDate,
                  toDate: toDate
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

  /// Hiển thị Bottom Sheet cho tùy chọn hiển thị theo
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
          // searchData: _controller.convertToJSON(_controller.data),
          searchData: _controller.convertToJSON(_receipts),
          dataType: 'import',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: AppString.searchImportReceipt,
          itemBuilder: (item) {
            return ImportReceiptCard(
              displayValue: _displayAttribute,
              receipt: ImportReceipt.fromJson(item), //chuyển về object
              onTap: (id) {context.push('${AppPath.import}/id', extra: ImportReceipt.fromJson(item));},
              fromDate: fromDate, toDate: toDate,
            );
          },
        ),
      ),
    );
  }

  // Hàm này được gọi khi bạn trở lại từ trang lọc và nhận được kết quả
  Future<void> _openFilterScreen() async {
    await context.push(AppPath.importFilter, extra: filter)
    .then((result) {
      if (result != null && result is ImportFilter) {
        setState(() {
          filter = result;
        });
      }
    });
  }
}
