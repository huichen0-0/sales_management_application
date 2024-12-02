import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/controllers/sorting_controller.dart';
import 'package:sales_management_application/views/widgets/cards/custom_card.dart';
import 'package:sales_management_application/views/widgets/search_bar.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'package:sales_management_application/config/constants.dart';
class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  SortingController? _sortingController;
  String selectedSorting = AppSort.newest; // Giá trị mặc định của sắp xếp
  String selectedDisplay = AppDisplay.totalSale; // Giá trị mặc định của tổng mua
  String selectedOption = AppTime.today; //giá trị mặc định của lọc thời gian
  ///fake dữ liệu
  final List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'name': 'ABC1',
      'phone': '0987654321',
      'sex': 'Nam',
      'amount': 1000000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'kh@example.com',
      'notes': 'KH vip',
      'isActived': true,
    },
    {
      'id': 1,
      'name': 'ABC11',
      'phone': '0987654321',
      'sex': 'Nam',
      'amount': 1100000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'kh@example.com',
      'notes': 'KH vip',
      'isActived': true,
    },
    {
      'id': 1,
      'name': 'ABC12',
      'phone': '0987654321',
      'sex': 'Nam',
      'amount': 1200000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'kh@example.com',
      'notes': 'KH vip',
      'isActived': true,
    },
    {
      'id': 1,
      'name': 'ABC21',
      'phone': '0987654321',
      'sex': 'Nam',
      'amount': 100000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'kh@example.com',
      'notes': 'KH vip',
      'isActived': true,
    },
    {
      'id': 1,
      'name': 'BC1',
      'phone': '0987654321',
      'sex': 'Nam',
      'amount': 4000000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'kh@example.com',
      'notes': 'KH vip',
      'isActived': true,
    },
    {
      'id': 1,
      'name': 'A1',
      'phone': '0987654321',
      'sex': 'Nam',
      'amount': 10000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'kh@example.com',
      'notes': 'KH vip',
      'isActived': true,
    },
    {
      'id': 1,
      'name': 'C1',
      'phone': '0987654321',
      'sex': 'Nam',
      'amount': 10050,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'kh@example.com',
      'notes': 'KH vip',
      'isActived': true,
    },
    {
      'id': 1,
      'name': 'AB4C1',
      'phone': '0987654321',
      'sex': 'Nam',
      'amount': 10023,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'kh@example.com',
      'notes': 'KH vip',
      'isActived': true,
    },
    {
      'id': 1,
      'name': 'ABC1',
      'phone': '0987654321',
      'sex': 'Nam',
      'amount': 12000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'kh@example.com',
      'notes': 'KH vip',
      'isActived': true,
    },
    {
      'id': 1,
      'name': 'ABC1',
      'phone': '0987654321',
      'sex': 'Nam',
      'amount': 1000000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'kh@example.com',
      'notes': 'KH vip',
      'isActived': true,
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
        title: const Text('Khách hàng'),
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
              context.push('/customers/filter');
            },
          ),
        ],
      ),
      body:
      items!.isNotEmpty ? _buildItemList(context, items) : _buildEmptyView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/customers/add');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget hiển thị khi không có khách hàng
  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Chưa có khách hàng',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị danh sách khách hàng
  Widget _buildItemList(
      BuildContext context, List<Map<String, dynamic>> items) {
    // Tính tổng mua từ danh sách khách hàng TODO: thực hiện ở tầng logic
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
          '${items.length} khách hàng',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ///hiển thị danh sách khách hàng
        for (var item in items)
          CustomerCard(
            customer: item,
            onTap: (id) => context.push('/customers/$id'),
          ),
      ],
    );
  }

  /// Hiển thị Bottom Sheet cho tùy chọn hiển thị theo
  void _showDisplayOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DisplayCustomerBottomSheet(
          selectedDisplay: selectedDisplay,
          onSelectDisplay: (option) {
            setState(() {
              selectedDisplay = option;
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
          selectedOption: selectedOption,
          onOptionSelected: (option, startDate, [endDate]) {
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
          dataType: 'customers',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: 'Tìm kiếm khách hàng',
        ),
      ),
    );
  }
}
