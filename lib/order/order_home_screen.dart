import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/order/order_filter.dart';
import 'package:sales_management_application/time_filter/time_filter_controller.dart';
import '../../../search/search_note_screen.dart';
import '../helper/helper.dart';
import '/config/constants.dart';
import '/views/widgets/sheets/sorting_bottom_sheet.dart';
import '/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'order.dart';
import 'order_card.dart';
import 'order_controller.dart';

class OrderScreen extends StatefulWidget {
  String? customerId;
  OrderFilter filter = OrderFilter();

  OrderScreen({super.key, required this.filter, this.customerId});

  @override
  OrderScreenState createState() => OrderScreenState(this.filter);
}

class OrderScreenState extends State<OrderScreen> {
  //biến lưu tùy chọn sắp xếp
  String _selectedSorting = AppString.newest;

  //biến lưu tùy chọn loọc thơời gian
  String _selectedOption = AppString.today;

  //biến lưu thời gian lọc
  DateTime? fromDate;
  DateTime? toDate;

  // controller hóa đơn
  final OrderController _controller = OrderController();

  //dữ liệu sau khi lấy
  List<Order>? _orders;

  OrderFilter filter = OrderFilter();
  TimeFilterController timeFilterController = TimeFilterController();

  OrderScreenState(this.filter);

  @override
  void initState() {
    super.initState();
    // _ordersFuture = _controller.getData();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime?> timeRange =
        timeFilterController.getTimeRange(_selectedOption, fromDate, toDate);
    fromDate = timeRange[0]!;
    toDate = timeRange[1];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<Order>>(
        future: _controller.getData(filter, widget.customerId, fromDate, toDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return _buildEmptyView();
          } else {
            _orders = snapshot.data;
            //sắp xếp
            _orders = _controller.sortOrders(_orders!, _selectedSorting);
            return _buildItemList(context, _orders!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppPath.orderAdd).then((result){
            setState(() {
          });
        }),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text(AppString.order, style: TextStyle(color: Colors.white)),
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
            const Column(
              children: [
                Text(
                  AppString.totalAmount,
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  '0',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          '0 đơn đặt hàng',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 60),

        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove_shopping_cart, size: 100, color: Colors.blue),
              SizedBox(height: 30),
              Text(
                AppString.emptyOrder,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildItemList(BuildContext context, List<Order> orders) {
    final groupedOrders =
        groupBy(orders, (item) => Helper.formatDate(item.createdAt));
    final totalDisplayValue =
        Helper.formatCurrency(_controller.getTotalDisplayValue(orders));
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
            Column(
              children: [
                const Text(
                  AppString.totalAmount,
                  style: TextStyle(color: Colors.black),
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
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${orders.length} hóa đơn',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        for (var group in groupedOrders.entries)
          Column(
            children: [
              Text(group.key,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              for (var order in group.value)
                OrderCard(
                  order: order,
                  onTap: (id) {
                    context.push('${AppPath.order}/$id', extra: order);
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
              List<DateTime?> timeRange = timeFilterController.getTimeRange(
                  _selectedOption, startDate, endDate);
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
          // showAscendingValue: false,
          // showDescendingValue: false,
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
              'hint': AppString.searchCustomerHint
            },
          ],
          //chuyển sang map để tìm kiếm
          searchData: _controller.convertToJSON(_orders),
          dataType: 'order',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: AppString.searchOrder,
          itemBuilder: (item) {
            return OrderCard(
              order: Order.fromJson(item), //chuyển về object
              onTap: (id) => context.push('${AppPath.order}/$id', extra: Order.fromJson(item)),
            );
          },
        ),
      ),
    );
  }

  // Hàm này được gọi khi bạn trở lại từ trang lọc và nhận được kết quả
  Future<void> _openFilterScreen() async {
    final result = await context.push(AppPath.orderFilter, extra: filter);
    // Đường dẫn đến trang lọc
    if (result != null && result is OrderFilter) {
      setState(() {
        filter = result;
      });
    }
  }
}
