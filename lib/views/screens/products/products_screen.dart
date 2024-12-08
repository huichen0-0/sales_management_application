import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/controllers/sorting_controller.dart';
import 'package:sales_management_application/models/product.dart';
import 'package:sales_management_application/services/ProductService.dart';
import 'package:sales_management_application/services/filter/ProductFilter.dart';
import 'package:sales_management_application/views/widgets/cards/custom_card.dart';
import 'package:sales_management_application/views/widgets/search_bar.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';

class ProductScreen extends StatefulWidget {
  ProductFilter filter = ProductFilter();
  ProductScreen(this.filter);

  @override
  State<ProductScreen> createState() => _ProductScreenState(this.filter);
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedSorting = AppSort.newest;
  String selectedDisplay = AppDisplay.sellingPrice;
  SortingController _sortingController = SortingController([]);
  ProductService productService = ProductService();
  List<Product> products = [];
  List<Map<String, dynamic>> items = [];
  ProductFilter filter = ProductFilter();

  _ProductScreenState(this.filter);

  /// Hàm format số tiền
  String formatCurrency(num amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    print('here3');
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
              if (items.isEmpty) {
                items = productService.convertToJson(products);
              }
              _openSearchPage();
            },
          ),

          /// sắp xếp
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Mở Bottom Sheet để chọn sắp xếp
              _showSortingOptions();
            },
          ),

          /// lọc
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              context.push('/products/filter', extra: this.filter);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: productService.getProductList(filter), // Pass the Future function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle any error that occurs during data fetching
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            products = snapshot.data!;
            if (_sortingController.currentData.isNotEmpty) {
              products = productService.convertToProduct(
                  _sortingController.currentData);
            }
            return _buildItemList(context, products);
          } else {
            return _buildEmptyView();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/products/add');
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
  Widget _buildItemList(
      BuildContext context, List<Product> items) {
// Tính tổng mua từ danh sách hàng hóa
    num totalQuantity = items.fold(0, (sum, item) => sum + item.quantity);
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///nút lọc hiển thị
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

            //tổng tồn theo hiển thị
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
            onTap: (id) {
              context.push('/products/${item.id}', extra: [item.id, item.toJSON()]);
            },
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
              items = productService.convertToJson(products);
              _sortingController = SortingController(items);
              if (selectedDisplay == AppDisplay.sellingPrice) {
                _sortingController.updateSorting(option, 'sellingPrice');
              } else if (selectedDisplay == AppDisplay.capitalPrice) {
                _sortingController.updateSorting(option, 'capitalPrice');
              }
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
