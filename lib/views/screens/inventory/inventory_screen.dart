import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/controllers/inventory_controller.dart';
import 'package:sales_management_application/controllers/sorting_controller.dart';
import 'package:sales_management_application/models/inventory_note.dart';
import 'package:sales_management_application/views/widgets/cards/inventory_note_card.dart';
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
  //controller sắp xếp
  SortingController? _sortingController;
  //kiểm kho controller
  final InventoryController _controller = InventoryController();


  /// Hàm format số tiền
  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }
  //khởi tạo
  @override
  void initState() {
    super.initState();
    _loadData();
    _sortingController = SortingController(_controller.getJSON());
  }

  Future<void> _loadData() async {
    await _controller.getData();
    setState(() {}); // Cập nhật lại giao diện sau khi có dữ liệu
  }

  @override
  Widget build(BuildContext context) {
    //dữ liệu sau khi sắp xếp ở dạng map
    final sortedMap = _sortingController?.currentData;
    //chuyển qua object
    final items = _controller.toObjects(sortedMap!);
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
              _controller.openSearchScreen(context);
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
          _goToAddingScreen();
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
      BuildContext context, List<InventoryNote> items) {
    // Nhóm danh sách theo ngày
    final groupedItems = groupBy(items, (item) {
      // Chuyển `DateTime` thành chuỗi định dạng ngày
      return DateFormat('yyyy/MM/dd').format(item.createdAt!);
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
                  onTap: (id) {
                    print(id);
                    return context.push('/inventory/$id');
                  },
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
              //cập nhật ui đã sắp xếp
              _sortingController?.updateSorting(option);
            });
          },
        );
      },
    );
  }
  ///các hàm gọi chuyển hướng
  Future<void> _goToAddingScreen() async{
    final check = await context.push<bool>('/inventory/add');
    if(check!) {
      setState(() {
        _loadData();
      });
    }
  }
}
