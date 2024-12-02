import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/controllers/sorting_controller.dart';
import 'package:sales_management_application/views/widgets/cards/custom_card.dart';
import 'package:sales_management_application/views/widgets/search_bar.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/time_filter_bottom_sheet.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  SortingController? _sortingController;
  String selectedSorting = AppSort.newest; // Giá trị mặc định của sắp xếp
  String selectedDisplay = AppDisplay.totalPurchase; // Giá trị mặc định của tổng mua
  String selectedOption = AppTime.today; //giá trị mặc định của lọc thời gian
  ///fake dữ liệu
  final List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'name': 'ABC555',
      'phone': '0955555',
      'amount': 120000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'notes': 'NCC vip 5',
      'isActive': true,
    },
    {
      'id': 6,
      'name': 'ABC66666',
      'phone': '0666666666',
      'amount': 10020,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'notes': 'NCC vip 6',
      'isActive': true,
    },
    {
      'id': 7,
      'name': 'ABC7777777',
      'phone': '09777777',
      'amount': 1020,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'notes': 'NCC vip 7',
      'isActive': true,
    },
    {
      'id': 8,
      'name': 'ABC888',
      'phone': '09888888888',
      'amount':200,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'notes': 'NCC vip 8',
      'isActive': true,
    },
    {
      'id': 9,
      'name': 'ABC9',
      'phone': '09090909',
      'amount': 1000000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'notes': 'NCC vip 9',
      'isActive': true,
    },
    {
      'id': 10,
      'name': 'ABC1010',
      'phone': '1010101010',
      'amount': 1000000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'notes': 'NCC vip 10',
      'isActive': false,
    },
    {
      'id': 11,
      'name': 'A11111',
      'phone': '1111111111',
      'amount': 1000000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'notes': 'NCC vip 11',
      'isActive': false,
    },
  ];

  /// Hàm format số tiền
  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }
  //khởi tạo
  @override
  void initState() {
    super.initState();
    _sortingController = SortingController(items);
  }
  @override
  Widget build(BuildContext context) {
    final items = _sortingController?.currentData;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Nhà cung cấp"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
        actions: [
          /// tìm kiếm
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _openSearchPage();
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
              context.push('/suppliers/filter');
            },
          ),
        ],
      ),
      body:
          items!.isNotEmpty ? _buildListView(context, items) : _buildEmptyView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/suppliers/add');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget hiển thị khi không có nhà cung cấp
  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Chưa có nhà cung cấp',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị danh sách nhà cung cấp
  Widget _buildListView(
      BuildContext context, List<Map<String, dynamic>> items) {
    // Tính tổng mua từ danh sách nhà cung cấp TODO: thực hiện ở tầng logic
    double totalPurchase = items.fold(0, (sum, item) => sum + item['amount']);
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

            ///nút lọc hiển thị TODO: cần xử lý áp dụng
            TextButton.icon(
              onPressed: () {
                // Mở Bottom Sheet để chọn Tổng mua
                _showDisplayOptions(context);
              },
              label: Text(
                selectedDisplay,
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
              formatCurrency(totalPurchase),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${items.length} nhà cung cấp',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ///hiển thị danh sách nhà cung cấp
        for (var item in items)
          SupplierCard(
            supplier: item,
            onTap: (id) => context.push('/suppliers/$id'),
          ),
      ],
    );
  }

  /// Hiển thị Bottom Sheet cho tùy chọn hiển thị theo
  void _showDisplayOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DisplaySupplierBottomSheet(
          selectedDisplay: selectedDisplay,
          onSelectDisplay: (option) {
            setState(() {
              selectedDisplay = option;
              _sortingController?.updateSorting(option, 'amount');
            });
          },
        );
      },
    );
  }

  /// hiển thị Bottom Sheet cho tùy chọn lọc thời gian
  void _showTimeFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TimeFilterBottomSheet(
          onOptionSelected: (option, startDate, [endDate]) {
            // String formattedDate = endDate != null
            //     ? '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}'
            //     : DateFormat('dd/MM/yyyy').format(startDate);
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
          //đang tắt mới, cũ nhất
          showNewest: false,
          showOldest: false,
          selectedSorting: selectedSorting,
          onSelectSorting: (option) {
            setState(() {
              selectedSorting = option;
              //cập nhật ui đã sắp xếp
              _sortingController?.updateSorting(option, 'amount');
            });
          },
        );
      },
    );
  }
  // Hàm mở trang tìm kiếm //TODO: đem vào controller?
  Future<void> _openSearchPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchBarScreen(
          searchOptions: const [
            {'searchKey': 'name', 'tag': 'Tên', 'hint': 'Tìm theo tên'},
            {'searchKey': 'phone', 'tag': 'SĐT', 'hint': 'Tìm theo SĐT'},
            {'searchKey': 'email', 'tag': 'Email', 'hint': 'Tìm theo email'},
            {'searchKey': 'address', 'tag': 'Địa chỉ', 'hint': 'Tìm theo địa chỉ'},
            {'searchKey': 'notes', 'tag': 'Ghi chú', 'hint': 'Tìm theo ghi chú'},
          ],
          searchData: items,
          dataType: 'suppliers',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: 'Tìm kiếm nhà cung cấp',
        ),
      ),
    );
  }
}
