import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/controllers/sorting_controller.dart';
import 'package:sales_management_application/models/FilterCustomer.dart';
import 'package:sales_management_application/views/widgets/cards/custom_card.dart';
import 'package:sales_management_application/views/widgets/search_bar.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/controllers/customer_controller.dart';
import 'package:sales_management_application/models/Customer.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final CustomerController _customerController = CustomerController();
  List<Customer> items = [];
  List<Map<String, dynamic>> itemsToSearch = [];
  SortingController? _sortingController;
  FilterCustomer _filterCustomer = FilterCustomer(fromDate: null, toDate: null, 
                                                  fromSellAmount: null, toSellAmount: null, 
                                                  fromReturnAmount: null, toReturnAmount: null, 
                                                  isMan: true, isWoman: false, 
                                                  isActive: true, isInactive: false);
  String selectedSorting = AppSort.newest; // Giá trị mặc định của sắp xếp
  String selectedDisplay = AppDisplay.totalSale; // Giá trị mặc định của tổng mua
  String selectedOption = AppTime.today; //giá trị mặc định của lọc thời gian
  double totalAmountSell = 0;
  double totalAmountReturn = 0;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    _getListCustomersToSearch();
    _sortingController = SortingController(_customerController.toMap(items));
  }

  //Hàm lấy thông tin khách hàng
  Future<void> _fetchCustomers() async {
    await _customerController.getDataListCustomers();
      
    setState(() {
      items = _customerController.customers;
      setTotalAmount();
    });
  }

  //Hàm lấy danh sách khách hàng dùng cho tìm kiếm
  Future<void> _getListCustomersToSearch() async {
    await _customerController.getListCustomerToSearch();
    setState(() {
      List<Customer> customerToSearch = _customerController.listCustomersToSearch;
      itemsToSearch = _customerController.toMap(customerToSearch);
    });
  }

  //Hàm lọc danh sách khách hàng
  Future<void> _filterListCustomers(FilterCustomer filterCustomer) async {
    await _customerController.filterCustomer(filterCustomer);
    setState(() {
      items = _customerController.customers;
      setTotalAmount();
    });
  }

  //Hàm chuyển hướng đến giao diện thêm khách hàng
  Future<void> goToAddCustomer() async {
    final check = await context.push<String>('/customers/add');
    if (check != null) {
      setState(() {
        _fetchCustomers();
        _getListCustomersToSearch();
      });
    }
  }

  //Hàm chuyển hướng đến giao diện thông tin chi tiết khách hàng
  Future<void> goToDetailCustomer(String id) async {
    await context.push<String>('/customers/$id');
    setState(() {
      _fetchCustomers();
      _getListCustomersToSearch();
    });
  }

  //Hàm chuyển hướng đến giao diện lọc khách hàng
  Future<void> goToFilterCustomer() async {
    FilterCustomer? fc =  await context.push<FilterCustomer>('/customers/filter', extra: _filterCustomer);
    if(fc != null){
      setState(() {
        _filterCustomer = fc;
        _filterListCustomers(fc);
      });
    }
  }

  /// Hàm format số tiền
  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  void setTotalAmount(){
    setState(() {
      totalAmountSell = items.fold(0, (sum, item) => sum + item.amountSell);
      totalAmountReturn = items.fold(0, (sum, item) => sum + item.amountReturn);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              // TODO: Xử lý tìm kiếm (DONE)
              _openSearchPage();
            },
          ),

          /// sắp xếp
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Xử lý sắp xếp (gần DONE, chờ module khác xong)
              // Mở Bottom Sheet để chọn sắp xếp
              _showSortingOptions(context);
            },
          ),

          /// lọc
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              // TODO: Xử lý lọc (gần DONE, chờ module khác xong)
              goToFilterCustomer();
            },
          ),
        ],
      ),
      body:
      items.isNotEmpty ? _buildItemList(context, items) : _buildEmptyView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToAddCustomer();
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
      BuildContext context, List<Customer> items) {
    // Tính tổng tiền từ danh sách khách hàng
    double totalPurchase = 0; 
    if(selectedDisplay == AppDisplay.totalSale){
      totalPurchase = totalAmountSell;
    } else {
      totalPurchase = totalAmountReturn;
    }
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

            ///nút lọc hiển thị TODO: cần xử lý áp dụng (DONE)
            TextButton.icon(
              onPressed: () {
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

            //tổng tiền theo hiển thị TODO: thay đổi theo tùy chọn (DONE)
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
            onTap: (id) => goToDetailCustomer(id),
            amount: (selectedDisplay == AppDisplay.totalSale) ? item.amountSell : item.amountReturn,
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
          totalAmountSell: formatCurrency(totalAmountSell),
          totalAmountReturn: formatCurrency(totalAmountReturn),
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
    String amountOption = (selectedDisplay == AppDisplay.totalSale) ? 'amountSell' : 'amountReturn';
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
              _sortingController = SortingController(_customerController.toMap(items));
              if(_sortingController != null){ // Kiểm tra đã khởi tạo _sortingController thành công chưa
                _sortingController?.updateSorting(option, amountOption); // sortValue là tên cột của giá trị tiền muốn truyền vào
                items = _customerController.fromMap(_sortingController!.currentData);
                setTotalAmount();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi khi thực hiện sắp xếp, vui lòng thử lại sau!')),
                );
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
            {'searchKey': 'name', 'tag': 'Tên', 'hint': 'Tìm theo tên'},
            {'searchKey': 'phoneNumber', 'tag': 'SĐT', 'hint': 'Tìm theo SĐT'},
            {'searchKey': 'email', 'tag': 'Email', 'hint': 'Tìm theo email'},
            {'searchKey': 'address', 'tag': 'Địa chỉ', 'hint': 'Tìm theo địa chỉ'},
            {'searchKey': 'note', 'tag': 'Ghi chú', 'hint': 'Tìm theo ghi chú'},
          ],
          searchData: itemsToSearch,
          dataType: 'customers',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: 'Tìm kiếm khách hàng',
        ),
      ),
    );
    setState(() {
      _fetchCustomers();
      _getListCustomersToSearch();
    });
  }
}
