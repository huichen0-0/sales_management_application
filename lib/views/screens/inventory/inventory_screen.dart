import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/views/widgets/cards/inventory_note_card.dart';
import 'package:sales_management_application/views/widgets/search_bar.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/time_filter_bottom_sheet.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String selectedSorting = AppSort.newest; // Giá trị mặc định của sắp xếp
  String selectedOption = AppTime.thisMonth; //giá trị mặc định của lọc thời gian
  ///fake dữ liệu
  final List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'products': [
        {
          'id': 1,
          'name': 'Giò heo lợn nạc 1',
          'selling_price': 200000,
          'capital_price': 100000,
          'quantity': 400,
          'unit': 'Kg',
          'checked_quantity': 399,
        },
        {
          'id': 2,
          'name': 'Giò bò Tây ban nha HDQ',
          'selling_price': 300000,
          'capital_price': 150000,
          'quantity': 400,
          'unit': 'Kg',
          'checked_quantity': 401,
        },
        {
          'id': 3,
          'name': 'Giò gà Tây ban nha HDAQQ',
          'selling_price': 100000,
          'capital_price': 60000,
          'quantity': 400,
          'unit': 'Kg',
          'checked_quantity': 401,
        },
        {
          'id': 4,
          'name': 'Giò gà Tây ban nha HHHDQ',
          'selling_price': 100000,
          'capital_price': 60000,
          'quantity': 400,
          'unit': 'Kg',
          'checked_quantity': 401,
        },
        {
          'id': 5,
          'name': 'Giò gà Tây ban nha HDQTU',
          'selling_price': 100000,
          'capital_price': 60000,
          'quantity': 400,
          'unit': 'Kg',
          'checked_quantity': 401,
        },
        {
          'id': 6,
          'name': 'Giò gà Tây ban nha HDQ',
          'selling_price': 100000,
          'capital_price': 60000,
          'quantity': 400,
          'unit': 'Kg',
          'checked_quantity': 401,
        },

      ],
      'status': 'Đã cân bằng',
      'created_at': DateTime.now(),
    },
    {
      'id': 2,
      'products': [
        {
          'id': 2,
          'name': 'Giò bò',
          'selling_price': 300000,
          'capital_price': 150000,
          'quantity': 400,
          'unit': 'Kg',
          'checked_quantity': 400,
        },
      ],
      'status': 'Phiếu tạm',
      'created_at': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  /// Hàm format số tiền
  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Kiểm kho'),
        actions: [
          /// tìm kiếm
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.push('/inventory/search');
            },
          ),

          /// sắp xếp
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Xử lý sắp xếp
              // Mở Bottom Sheet để chọn sắp xếp
              _showSortingOptions(context);
            },
          ),

          /// lọc
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              // TODO: Xử lý lọc
              context.push('/inventory/filter');
            },
          ),
        ],
      ),
      body:
      items.isNotEmpty ? _buildItemList(context, items) : _buildEmptyView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/inventory/add');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget hiển thị khi không có phiếu kiểm kho
  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Chưa có phiếu kiểm kho',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị danh sách phiếu kiểm kho
  Widget _buildItemList(
      BuildContext context, List<Map<String, dynamic>> items) {
    // Nhóm danh sách theo ngày
    final groupedItems = groupBy(items, (item) {
      // Chuyển `DateTime` thành chuỗi định dạng ngày
      return DateFormat('yyyy/MM/dd').format(item['created_at']);
    });
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
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${items.length} phiếu kiểm kho',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        for (var group in groupedItems.entries)
          Column(
            children: [
              Text(group.key, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              //hiển thị danh sách phiếu kiểm kho nhóm theo ngày
              for (var item in group.value)
                InventoryNoteCard(
                  inventoryNote: item,
                  onTap: (id) => context.push('/inventory/$id'),
                ),
            ],
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
            // String formattedDate = endDate != null
            //     ? '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}'
            //     : DateFormat('dd/MM/yyyy').format(startDate);
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
            });
          },
        );
      },
    );
  }
  // // Hàm mở trang tìm kiếm
  // Future<void> _openSearchPage() async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SearchBarScreen(
  //         searchOptions: const [
  //           {'searchKey': 'name', 'tag': 'Tên', 'hint': 'Tìm theo tên'},
  //           {'searchKey': 'phone', 'tag': 'SĐT', 'hint': 'Tìm theo SĐT'},
  //           {'searchKey': 'email', 'tag': 'Email', 'hint': 'Tìm theo email'},
  //           {'searchKey': 'notes', 'tag': 'Ghi chú', 'hint': 'Tìm theo ghi chú'},
  //         ],
  //         searchData: items,
  //         dataType: 'suppliers',
  //         onCancel: () {
  //           // Hủy tìm kiếm và đóng trang tìm kiếm
  //           Navigator.pop(context);
  //         },
  //         title: 'Tìm kiếm sản phẩm',
  //       ),
  //     ),
  //   );
  // }
}
