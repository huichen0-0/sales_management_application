import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/invoice/invoice_filter.dart';
import 'package:sales_management_application/time_filter/time_filter_controller.dart';
import '../../../views/widgets/search_bars/search_note_screen.dart';
import '../../../views/widgets/sheets/display_bottom_sheet.dart';
import '../helper/helper.dart';
import '../views/widgets/cards/invoice_card.dart';
import '/config/constants.dart';
import '/views/widgets/sheets/sorting_bottom_sheet.dart';
import '/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'invoice_controller.dart';
import 'invoice_receipt.dart';

class InvoiceScreen extends StatefulWidget {
  InvoiceFilter filter = InvoiceFilter();
  InvoiceScreen({super.key, required this.filter});

  @override
  InvoiceScreenState createState() => InvoiceScreenState(this.filter);
}

class InvoiceScreenState extends State<InvoiceScreen> {
  //biến lưu tùy chọn sắp xếp
  String _selectedSorting = AppString.newest;

  //biến lưu tùy chọn loọc thơời gian
  String _selectedOption = AppString.allTime;

  //Biến lưu tùy chọn hiển thị
  String _selectedDisplay = AppString.totalAmount;

  //biến lưu thuộc tính hiển thị
  String _displayAttribute = AppAttribute.totalSaleValue;

  //biến lưu thời gian lọc
  DateTime? fromDate;
  DateTime? toDate;

  // controller hóa đơn
  InvoiceController _controller = InvoiceController();

  //dữ liệu sau khi lấy
  List<InvoiceReceipt>? _receipts;

  InvoiceFilter filter = InvoiceFilter();
  TimeFilterController timeFilterController = TimeFilterController();
  InvoiceScreenState(this.filter);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<InvoiceReceipt>>(
        future: _controller.getData(filter),
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
              _receipts!, _selectedSorting, _displayAttribute);
            return _buildItemList(context, _receipts!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppPath.invoiceAdd),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text(AppString.invoice, style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.go('/home');
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_shopping_cart, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            AppString.emptyInvoiceReceipt,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(BuildContext context, List<InvoiceReceipt> receipts) {
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
          '${receipts.length} hóa đơn',
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
                InvoiceReceiptCard(
                  displayValue: _displayAttribute,
                  receipt: receipt,
                  onTap: (id) {
                    return context.push('${AppPath.invoice}/$id', extra: receipt);
                  },
                  fromDate: fromDate,
                  toDate: toDate,
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
          sale: true,
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
          // showAscendingValue: false,
          // showDescendingValue: false,
          selectedSorting: _selectedSorting,
          onSelectSorting: (option) {
            setState(() {
              _selectedSorting = option;
              List<DateTime?> timeRange = timeFilterController.getTimeRange(_selectedOption, fromDate, toDate);
              fromDate = timeRange[0]!;
              toDate = timeRange[1];
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
              'searchKey': AppAttribute.customer,
              'tag': AppString.customer,
              'hint': AppString.searchCustomerHint
            },
          ],
          //chuyển sang map để tìm kiếm
          searchData: _controller.convertToJSON(_receipts),
          dataType: 'invoice',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: AppString.searchInvoiceReceipt,
          itemBuilder: (item) {
            return InvoiceReceiptCard(
              displayValue: _displayAttribute,
              receipt: InvoiceReceipt.fromJson(item), //chuyển về object
              onTap: (id) => context.push('${AppPath.invoice}/$id', extra: [id, item]),
              fromDate: fromDate,
              toDate: toDate,
            );
          },
        ),
      ),
    );
  }

  // Hàm này được gọi khi bạn trở lại từ trang lọc và nhận được kết quả
  Future<void> _openFilterScreen() async {
    final result = await context.push(AppPath.invoiceFilter, extra: filter);
    // Đường dẫn đến trang lọc
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
      });
    }
  }
}
