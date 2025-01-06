import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../customers/controller/customer_controller.dart';
import '../../../customers/filter/customer_filter.dart';
import '../../../customers/model/customer.dart';
import '../../../search/searching_controller.dart';

class CustomerSelectionSceen extends StatefulWidget {
  final void Function(Customer customer)
  onCustomerTap; // Hàm xử lý khi chọn sản phẩm

  const CustomerSelectionSceen({
    super.key,
    required this.onCustomerTap,
  });

  @override
  State<CustomerSelectionSceen> createState() => _CustomerSelectionSceenState();
}

class _CustomerSelectionSceenState extends State<CustomerSelectionSceen> {
  //controller lấy input
  final TextEditingController _textController = TextEditingController();
  CustomerController customerController = CustomerController();
  //controller tìm kiếm
  late SearchingController _searchingController;
  CustomerFilter filter = CustomerFilter.empty();

//fake dữ liệu danh sách sản phẩm //sau lấy từ db rồi chuyển sang dạng map
  List<Map<String, dynamic>> customers = [ ];

  @override
  void initState() {
    super.initState();
    filter.isInactive = false;
    // Khởi tạo SearchingController với dữ liệu đầu vào
    _searchingController = SearchingController(
      searchData: customers,
      searchOptions: [
        {'searchKey': 'name', 'tag': '', 'hint': 'Chọn khách hàng'}
      ],
    );

    // Đặt listener cho TextField để cập nhật kết quả tìm kiếm
    _textController.addListener(() {
      _searchingController.updateSearchResults(_textController.text);
      setState(() {}); // Cập nhật UI khi có thay đổi kết quả
    });
  }

  // Hàm xử lý khi nhấn vào icon x
  void _onCancelIconPressed() {
    _textController.clear();
  }

  // Hàm xử lý khi nhấn vào icon +
  void _onAddIconPressed() {
    context.push('/customers/add');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Chọn nhà cung cấp'),
      ),
      body: FutureBuilder<List<Customer>>(
        future: customerController.getCustomerListToSearch(filter), // Pass the Future function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle any error that occurs during data fetching
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            customers = customerController.convertToJson(snapshot.data!);
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: _searchingController.currentHintText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_textController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: _onCancelIconPressed,
                            ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _onAddIconPressed,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          final customer = customers[index];
                          return ListTile(
                            title: Text(customer['name']),
                            leading: const Icon(Icons.image, size: 30),
                            trailing: Text(customer['phoneNumber']),
                            onTap: () {
                              widget.onCustomerTap(Customer.fromJson(customer));
                              _onCancelIconPressed();
                            },
                          );
                        },
                      ),
                      // Kết quả tìm kiếm (lớp trên cùng)
                      if (_searchingController.searchResults.isNotEmpty)
                        Positioned.fill(
                          child: Container(
                            color: Colors.white.withOpacity(0.9),
                            // Màu nền mờ để che giao diện bên dưới
                            child: ListView.builder(
                              // Số lượng kết quả tìm kiếm
                              itemCount: _searchingController.searchResults.length,
                              itemBuilder: (context, index) {
                                Customer customer = Customer.fromJson(
                                    _searchingController.searchResults[index]);
                                return ListTile(
                                  // Hiển thị tên sản phẩm
                                  title: Text(customer.name),
                                  leading: const Icon(
                                    Icons.image,
                                    size: 30,
                                  ),
                                  trailing: Text(customer.phoneNumber),
                                  // Xử lý khi chọn sản phẩm
                                  onTap: () {
                                    widget.onCustomerTap(customer);
                                    // context.pop(true);
                                    _onCancelIconPressed();
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
