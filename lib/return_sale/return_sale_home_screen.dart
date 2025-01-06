import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/return_sale/return_sale_filter.dart';
import 'package:sales_management_application/time_filter/time_filter_controller.dart';
import '../../../views/widgets/search_bars/search_note_screen.dart';
import '../../../views/widgets/sheets/display_bottom_sheet.dart';
import '../helper/helper.dart';
import '/config/constants.dart';
import '/views/widgets/sheets/sorting_bottom_sheet.dart';
import '/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'return_sale_card.dart';
import 'return_sale_controller.dart';
import 'return_sale_receipt.dart';

class ReturnInvoiceScreen extends StatefulWidget {
  String? customerId;
  DateTime? date;
  final ReturnInvoiceFilter filter;
  ReturnInvoiceScreen({super.key, required this.filter, this.customerId, this.date});

  @override
  _ReturnInvoiceScreenState createState() => _ReturnInvoiceScreenState(filter);
}

class _ReturnInvoiceScreenState extends State<ReturnInvoiceScreen> {
  //biến lưu tùy chọn sắp xếp
  String _selectedSorting = AppString.newest;

  //biến lưu tùy chọn loọc thơời gian
  String _selectedOption = AppString.allTime;

  //Biến lưu tùy chọn hiển thị
  final _selectedDisplay = AppString.totalReturnAmount;

  //biến lưu thuộc tính hiển thị
  final _displayAttribute = AppAttribute.totalSaleValue;

  //biến lưu thời gian lọc
  DateTime? fromDate;
  DateTime? toDate;

  ReturnInvoiceController returnInvoiceController = ReturnInvoiceController();
  ReturnInvoiceFilter filter = ReturnInvoiceFilter();

  //controller trả hàng nhập
  final ReturnInvoiceController _controller = ReturnInvoiceController();

  //lưu dữ liệu ban đầu
  List<ReturnInvoiceReceipt>? _receipts;


  _ReturnInvoiceScreenState(this.filter);
  TimeFilterController timeFilterController = TimeFilterController();

  @override
  void initState() {
    super.initState();
    // _receiptsFuture = _controller.getData();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime?> timeRange =
    timeFilterController.getTimeRange(_selectedOption, fromDate, toDate);
    fromDate = timeRange[0]!;
    toDate = timeRange[1];
    if(widget.date != null) {
      fromDate = widget.date;
      toDate = widget.date;
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<ReturnInvoiceReceipt>>(
        future: returnInvoiceController.getReturnInvoiceList(filter, widget.customerId, fromDate, toDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // return const Center(child: Text(AppString.errorLoadingData));
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
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text(AppString.returnInvoice, style: TextStyle(color: Colors.white)),
      actions: [
        if(widget.date == null) IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            _openSearchScreen();
          },
        ),
        IconButton(
          icon: const Icon(Icons.sort, color: Colors.white),
          onPressed: () => _showSortingOptions(context),
        ),
        if(widget.date == null) IconButton(
          icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
          onPressed: () => _openFilterScreen(),
        ),
      ],
    );
  }

  Widget _buildEmptyView() {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(widget.date == null) TextButton.icon(
              icon: const Icon(Icons.calendar_today, color: Colors.black),
              label: Text(_selectedOption,
                  style: const TextStyle(color: Colors.black)),
              onPressed: () {
                _showTimeFilterOptions();
              },
            ),

            ///nút lọc hiển thị TODO: cần xử lý áp dụng
            Text(
              _selectedDisplay,
              style: const TextStyle(color: Colors.black),
            ),

            //tổng tiền theo hiển thị TODO: thay đổi theo tùy chọn
            const Text(
              '0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          '0 phiếu xuất hủy',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),

        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove_shopping_cart, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'Chưa có hóa đơn trả hàng',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildItemList(
      BuildContext context, List<ReturnInvoiceReceipt> receipts) {
    final groupedReceipts =
    groupBy(receipts, (item) => Helper.formatDate(item.createdAt));
    final totalDisplayValue = Helper.formatCurrency(
        _controller.getTotalDisplayValue(receipts,_displayAttribute));
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(widget.date == null) TextButton.icon(
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
          '${receipts.length} hóa đơn trả hàng',
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
                ReturnInvoiceReceiptCard(
                  displayValue: _displayAttribute,
                  receipt: receipt,
                  onTap: (id) {
                    return context.push('${AppPath.returnInvoice}/$id', extra: receipt);
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
              List<DateTime?> timeRange = timeFilterController.getTimeRange(_selectedOption, startDate, endDate);
              fromDate = timeRange[0]!;
              toDate = timeRange[1];
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
              'searchKey': AppAttribute.customer,
              'tag': AppString.customer,
              'hint': AppString.searchCustomerHint,
            },
          ],
          //chuyển sang map để tìm kiếm
          searchData: _controller.convertToJSON(_receipts),
          dataType: 'returnInvoice',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: AppString.searchReturnInvoice,
          itemBuilder: (item) {
            return ReturnInvoiceReceiptCard(
              displayValue: _displayAttribute,
              receipt: ReturnInvoiceReceipt.fromJson(item),
              //chuyển về object
              onTap: (id) => context.push('${AppPath.returnInvoice}/$id'),
            );
          },
        ),
      ),
    );
  }

  // Hàm này được gọi khi bạn trở lại từ trang lọc và nhận được kết quả
  Future<void> _openFilterScreen() async {
    final result = await context.push(AppPath.returnInvoiceFilter, extra: filter);
    // Đường dẫn đến trang lọc
    if (result != null && result is ReturnInvoiceFilter) {
      setState(() {
        filter = result;
      });
    }
  }
}
