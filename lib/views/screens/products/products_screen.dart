import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/controllers/sorting_controller.dart';
import 'package:sales_management_application/views/widgets/cards/custom_card.dart';
import 'package:sales_management_application/views/widgets/search_bar.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedSorting = AppSort.newest;

  // Giá trị mặc định của sắp xếp
  String selectedDisplay = AppDisplay.sellingPrice;
  SortingController? _sortingController;
  ///fake dữ liệu
  List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'name': 'Giò heo 1KG',
      'price': 1021000,
      'quantity': 1000,
      'unit': 'Kg',
      'created_at': DateTime.now().subtract(const Duration(seconds: 5)),
    },
    {
      'id': 2,
      'name': 'Giò heo 500g',
      'price': 1031000,
      'quantity': 500,
      'unit': 'Kg',
      'created_at': DateTime.now().subtract(const Duration(seconds: 4)),
    },
    {
      'id': 3,
      'name': 'Giò bò 500g',
      'price': 2033000,
      'quantity': 400,
      'unit': 'Kg',
      'created_at': DateTime.now().subtract(const Duration(seconds: 1)),
    },
    {
      'id': 4,
      'name': 'Giò bò 1kg',
      'price': 2034000,
      'quantity': 300,
      'unit': 'Kg',
      'created_at': DateTime.now().subtract(const Duration(seconds: 3)),
    },
    {
      'id': 5,
      'name': 'Chả heo',
      'price': 203200,
      'quantity': 200,
      'unit': 'Kg',
      'created_at': DateTime.now().subtract(const Duration(seconds: 2)),
    },
  ];
  /// Hàm format số tiền
  String formatCurrency(num amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

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
        title: const Text("Hàng hoá"),
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
              // TODO: Xử lý tìm kiếm
              _openSearchPage();
            },
          ),

          /// sắp xếp
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Xử lý sắp xếp
              // Mở Bottom Sheet để chọn sắp xếp
              _showSortingOptions();
            },
          ),

          /// lọc
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              // TODO: Xử lý lọc
              context.push('/products/filter');
            },
          ),
        ],
      ),
      body: items!.isNotEmpty
          ? _buildListView(context, items)
          : _buildEmptyView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/products/add');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// widget hiển thị khi không có hàng hóa
  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Chưa có hàng hóa',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// widget hiển thị khi có hàng hóa
  Widget _buildListView(
      BuildContext context, List<Map<String, dynamic>> items) {
// Tính tổng mua từ danh sách hàng hóa TODO: thực hiện ở tầng logic
    num totalQuantity = items.fold(0, (sum, item) => sum + item['quantity']);
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///nút lọc hiển thị TODO: cần xử lý áp dụng
            TextButton.icon(
              onPressed: () {
                // Mở Bottom Sheet để chọn hiển thị
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
            const Spacer(),

            //tổng tồn theo hiển thị TODO: thay đổi theo tùy chọn
            Text(
              'Tổng tồn: ${formatCurrency(totalQuantity)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${items.length} hàng hóa',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ///hiển thị danh sách hàng hóa
        for (var item in items)
          ProductCard(
            product: item,
            onTap: (id) => context.push('/products/$id'),
          ),
      ],
    );
  }

  /// Hiển thị Bottom Sheet cho tùy chọn hiển thị theo
  void _showDisplayOptions(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DisplayProductBottomSheet(
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

  /// Hiển thị Bottom Sheet cho tùy chọn sắp xếp
  void _showSortingOptions() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SortingBottomSheet(
          selectedSorting: selectedSorting,
          onSelectSorting: (option) {
            setState(() {
              selectedSorting = option;
              // 'price' ở đây biểu thị cho giá trị hiển thị
              _sortingController?.updateSorting(option, 'price');
            });
          },
        );
      },
    );
  }
  // Hàm mở trang tìm kiếm
  Future<void> _openSearchPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchBarScreen(
          searchOptions: const [
            {'searchKey': 'name', 'tag': 'Tên', 'hint': 'Tên hàng hóa'},
          ],
          searchData: items,
          dataType: 'products',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: 'Tìm kiếm sản phẩm',
        ),
      ),
    );
  }
}
