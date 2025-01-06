import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/sort/sorting_controller.dart';
import 'package:sales_management_application/customers/filter/customer_filter.dart';
import 'package:sales_management_application/time_filter/time_filter_controller.dart';
import 'package:sales_management_application/views/widgets/cards/customer_card.dart';
import 'package:sales_management_application/views/widgets/search_bar.dart';
import 'package:sales_management_application/views/widgets/sheets/display_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'package:sales_management_application/customers/controller/customer_controller.dart';
import 'package:sales_management_application/customers/model/customer.dart';

class CustomerScreen extends StatefulWidget {
  final CustomerFilter filter;
  CustomerScreen({super.key, required this.filter});

  @override
  _CustomerScreenState createState() => _CustomerScreenState(this.filter);
}

class _CustomerScreenState extends State<CustomerScreen> {
  final CustomerController _customerController = CustomerController();
  List<Customer> customers = [];
  List<Map<String, dynamic>> itemsToSearch = [];
  SortingController _sortingController = SortingController([]);
  CustomerFilter filter = CustomerFilter(fromDate: null, toDate: null,
                                                  fromSellAmount: null, toSellAmount: null, 
                                                  fromDebtAmount: null, toDebtAmount: null,
                                                  isMan: true, isWoman: true,
                                                  isActive: true, isInactive: false);
  String selectedSorting = AppString.newest; // Giá trị mặc định của sắp xếp
  String selectedDisplay = AppString.totalSale; // Giá trị mặc định của tổng mua
  String selectedOption = AppString.today; //giá trị mặc định của lọc thời gian
  double totalAmountSell = 0;
  double totalAmountReturn = 0;
  DateTime? fromDate;
  DateTime? toDate;
  TimeFilterController timeFilterController = TimeFilterController();
  CustomerController customerController = CustomerController();
  _CustomerScreenState(this.filter);

  //Hàm lấy thông tin khách hàng
  Future<void> _fetchCustomers() async {
    await _customerController.getDataListCustomers();
      
    setState(() {
      customers = _customerController.customers;
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
  Future<void> _filterListCustomers(CustomerFilter filterCustomer) async {
    await _customerController.filterCustomer(filterCustomer);
    setState(() {
      customers = _customerController.customers;
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
  Future<void> goToDetailCustomer(Customer customer) async {
    await context.push<String>('/customers/${customer.id}', extra: customer);
    setState(() {
      _fetchCustomers();
      _getListCustomersToSearch();
    });
  }

  //Hàm chuyển hướng đến giao diện lọc khách hàng
  Future<void> goToFilterCustomer() async {
    CustomerFilter? fc =  await context.push<CustomerFilter>('/customers/filter', extra: filter);
    if(fc != null){
      setState(() {
        filter = fc;
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
      totalAmountSell = customers.fold(0, (sum, item) => sum + item.amountSell);
      totalAmountReturn = customers.fold(0, (sum, item) => sum + item.amountReturn);
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
              _openSearchPage();
            },
          ),

          /// sắp xếp
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Mở Bottom Sheet để chọn sắp xếp
              _showSortingOptions(context);
            },
          ),

          /// lọc
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              goToFilterCustomer();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Customer>>(
        future: customerController.getCustomerList(filter, selectedOption, selectedDisplay, fromDate, toDate), // Pass the Future function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle any error that occurs during data fetching
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            customers = snapshot.data!;

            if (_sortingController!.currentData.isNotEmpty) {
              customers = customerController.convertToCustomers(_sortingController!.currentData);
            }
            return _buildItemList(context, customers);
          } else {
            return _buildEmptyView();
          }
        },
      ),
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
    return ListView(
        children: [
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
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.remove_shopping_cart, size: 100, color: Colors.blue),
                SizedBox(height: 20),
                Text(
                  'Chưa có phiếu xuất hủy',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ]
    );
  }

  // Widget hiển thị danh sách khách hàng
  Widget _buildItemList(
      BuildContext context, List<Customer> items) {
    // Tính tổng tiền từ danh sách khách hàng
    double totalPurchase = 0; 
    if(selectedDisplay == AppString.totalSale){
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
            onTap: (id) => goToDetailCustomer(item),
            amount: (selectedDisplay == AppString.totalSale) ? item.amountSell : item.amountReturn,
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
          }
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
              List<DateTime?> timeRange = timeFilterController.getTimeRange(selectedOption, startDate, endDate);
              fromDate = timeRange[0];
              toDate = timeRange[1];
            });
          },
        );
      },
    );
  }

  /// Hiển thị Bottom Sheet cho tùy chọn sắp xếp
  void _showSortingOptions(BuildContext context) {
    String amountOption = (selectedDisplay == AppString.totalSale) ? 'amountSell' : 'amountReturn';
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
              _sortingController = SortingController(_customerController.toMap(customers));
              if(_sortingController != null){ // Kiểm tra đã khởi tạo _sortingController thành công chưa
                _sortingController?.updateSorting(option, amountOption); // sortValue là tên cột của giá trị tiền muốn truyền vào
                customers = _customerController.fromMap(_sortingController!.currentData);
                setTotalAmount();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lỗi khi thực hiện sắp xếp, vui lòng thử lại sau!')),
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
          searchData: customerController.convertToJson(customers),
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
