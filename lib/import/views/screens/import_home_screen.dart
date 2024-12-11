import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import '../../../views/widgets/search_bars/search_note_screen.dart';
import '../../../views/widgets/sheets/display_bottom_sheet.dart';
import '../../controllers/import_controller.dart';
import '../../models/import_receipt.dart';
import '../widgets/import_card.dart';
import '/config/constants.dart';
import '/controllers/sorting_controller.dart';
import '/views/helper/helper.dart';
import '/views/widgets/sheets/sorting_bottom_sheet.dart';
import '/views/widgets/sheets/time_filter_bottom_sheet.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  _ImportScreenState createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  String _selectedSorting = AppSort.newest;
  String _selectedOption = AppTime.allTime;
  String _selectedDisplay =
      AppDisplay.totalPurchase; // Giá trị mặc định của tổng mua
  String _displayAttribute = AppAttribute.totalValue;
  DateTime? _startDate;
  DateTime? _endDate;
  final ImportController _controller = ImportController();
  SortingController? _sortingController;
  late Future<List<ImportReceipt>> _receiptsFuture;
  List<ImportReceipt>? _receipts;
  Map<String, dynamic> _filters = {};

  @override
  void initState() {
    super.initState();
    _receiptsFuture = _controller.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<ImportReceipt>>(
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
            _receipts = _controller.filterAndSortReceipts(_receipts!,_filters,_startDate,_endDate,_selectedSorting);
            return _buildItemList(context, _receipts!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/import/add'),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text('Nhập hàng', style: TextStyle(color: Colors.white)),
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_shopping_cart, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Chưa có phiếu nhập hàng',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(BuildContext context, List<ImportReceipt> receipts) {
    final groupedReceipts =
        groupBy(receipts, (item) => Helper.formatDate(item.createdAt));
    final totalDisplayValue = Helper.formatCurrency(
        _controller.getTotalDisplayValue(_displayAttribute));
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
                  displayValue: _displayAttribute,
                  receipt: receipt,
                  onTap: (id) {
                    return context.push('/import/$id');
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
            print('Lựa chọn: $option, Bắt đầu: $startDate, Kết thúc: $endDate');
            setState(() {
              _selectedOption = option;
              if (startDate != null) {
                _startDate = startDate;
                _endDate = endDate;
              }
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
          selectedDisplay: _selectedDisplay,
          onSelectDisplay: (option) {
            switch (option) {
              case AppDisplay.totalDue:
                _displayAttribute = AppAttribute.totalDue;
              case AppDisplay.totalPaid:
                _displayAttribute = AppAttribute.totalPaid;
              default:
                _displayAttribute = AppAttribute.totalValue;
            }
            setState(() {
              _selectedDisplay = option;
              _sortingController?.updateSorting(option, _displayAttribute);
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
              _sortingController?.updateSorting(option);
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
              'searchKey': 'details',
              'tag': 'Hàng hóa',
              'hint': 'Tìm theo hàng hóa'
            },
            {
              'searchKey': 'supplier',
              'tag': 'Nhà cung cấp',
              'hint': 'Tìm theo nhà cung cấp'
            },
          ],
          //chuyển sang map để tìm kiếm
          searchData: _controller.convertToJSON(_controller.data),
          dataType: 'import',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: 'Tìm kiếm phiếu nhập hàng',
          itemBuilder: (item) {
            return ImportReceiptCard(
              displayValue: _displayAttribute,
              receipt: ImportReceipt.fromJson(item), //chuyển về object
              onTap: (id) => context.push('/import/$id'),
            );
          },
        ),
      ),
    );
  }

  // Hàm này được gọi khi bạn trở lại từ trang lọc và nhận được kết quả
  Future<void> _openFilterScreen() async {
    final result = await context.push('/import/filter');
    // Đường dẫn đến trang lọc
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _filters = result;
      });
    }
  }
}
