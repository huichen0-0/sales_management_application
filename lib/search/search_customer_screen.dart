import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async'; // import lib async cho timer

import '../customers/controller/customer_controller.dart';
import '../customers/filter/customer_filter.dart';
import '../customers/model/customer.dart';

class CustomerSelectionSceen extends StatefulWidget {
  final void Function(Customer customer) onCustomerTap;
  // func xử lý khi chọn KH

  const CustomerSelectionSceen({super.key, required this.onCustomerTap});

  @override
  State<CustomerSelectionSceen> createState() => _CustomerSelectionSceenState();
}

class _CustomerSelectionSceenState extends State<CustomerSelectionSceen> {
  final TextEditingController _textController = TextEditingController();
  // ctrl cho việc nhập liệu

  final CustomerController customerController = CustomerController();
  // ctrl để lấy dữ liệu KH

  final CustomerFilter filter = CustomerFilter.empty()..isInactive = false;
  // bộ lọc KH, mặc định ko bao gồm KH ko hoạt động

  List<Customer> _allCustomers = [];
  // DS tất cả KH đc tải về

  final ValueNotifier<List<Customer>> _searchResults = ValueNotifier([]);
  // thông báo thay đổi trong kq tìm kiếm

  Timer? _debounceTimer;
  // timer để trì hoãn việc tìm kiếm

  @override
  void initState() {
    super.initState();
    // gọi khi widget đc khởi tạo
    _loadCustomers();
    // tải DS KH ban đầu
    _textController.addListener(_onSearchTextChanged);
    // lắng nghe thay đổi trong text field
  }

  @override
  void dispose() {
    // gọi khi widget bị hủy
    _textController.dispose();
    // giải phóng ctrl của text field
    _debounceTimer?.cancel();
    // hủy timer nếu đang hoạt động
    _searchResults.dispose();
    // giải phóng value notifier
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    // func tải DS KH từ ctrl
    final customers = await customerController.getCustomerListToSearch(filter);
    // gọi api để lấy DS KH theo bộ lọc
    setState(() {
      // update UI khi dữ liệu đc tải xong
      _allCustomers = customers;
      // gán DS KH đã tải
      _searchResults.value = customers;
      // hiển thị tất cả KH ban đầu
    });
  }

  void _onSearchTextChanged() {
    // func xử lý khi text trong ô tìm kiếm thay đổi
    _debounceTimer?.cancel();
    // hủy timer cũ nếu có
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      // tạo timer mới để trì hoãn việc tìm kiếm
      final searchText = _textController.text.toLowerCase();
      // lấy nội dung tìm kiếm và chuyển về chữ thường
      if (searchText.isEmpty) {
        // nếu ko có nội dung tìm kiếm
        _searchResults.value = _allCustomers;
        // hiển thị lại tất cả KH
      } else {
        // nếu có nội dung tìm kiếm
        _searchResults.value = _allCustomers
            .where((customer) =>
        customer.name.toLowerCase().contains(searchText) ||
            customer.phoneNumber.contains(searchText))
            .toList();
        // lọc DS KH dựa trên tên hoặc sđt
      }
    });
  }

  void _onCancelIconPressed() {
    // func xử lý khi nhấn icon cancel
    _textController.clear();
    // xóa nội dung trong text field
    _searchResults.value = _allCustomers;
    // hiển thị lại tất cả KH
  }

  void _onAddIconPressed() {
    // func xử lý khi nhấn icon add
    context.push('/customers/add');
    // điều hướng đến màn hình thêm KH
  }

  @override
  Widget build(BuildContext context) {
    // pthức xây dựng giao diện người dùng
    return Scaffold(
      appBar: AppBar(
        // app bar của màn hình
        backgroundColor: Colors.blue,
        // màu nền của app bar
        title: const Text('chọn nhà cung cấp'),
        // tiêu đề của app bar
      ),
      body: SingleChildScrollView(
        // cho phép cuộn nếu nội dung vượt quá màn hình
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // padding xung quanh nội dung
          child: Column(
            // sắp xếp các widget theo chiều dọc
            children: [
              TextField(
                // ô nhập liệu để tìm kiếm
                controller: _textController,
                // liên kết với ctrl
                decoration: InputDecoration(
                  // trang trí cho ô nhập liệu
                  hintText: 'tìm kiếm khách hàng',
                  // gợi ý cho người dùng
                  border: OutlineInputBorder(
                    // viền ngoài
                    borderRadius: BorderRadius.circular(8.0),
                    // bo tròn góc
                    borderSide: BorderSide.none,
                    // ko có đường viền
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  suffixIcon: Row(
                    // các icon ở cuối ô nhập liệu
                    mainAxisSize: MainAxisSize.min,
                    // kích thước vừa đủ nội dung
                    children: [
                      if (_textController.text.isNotEmpty)
                      // hiển thị icon cancel nếu có text
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          // icon cancel
                          onPressed: _onCancelIconPressed,
                          // gọi func khi nhấn
                        ),
                      IconButton(
                        // icon add
                        icon: const Icon(Icons.add),
                        // icon add
                        onPressed: _onAddIconPressed,
                        // gọi func khi nhấn
                      ),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder<List<Customer>>(
                // widget xây dựng lại khi _searchResults thay đổi
                valueListenable: _searchResults,
                // lắng nghe _searchResults
                builder: (context, customers, child) {
                  // func xây dựng DS KH
                  if (_allCustomers.isEmpty) {
                    // nếu DS KH chưa đc tải
                    return const Center(child: CircularProgressIndicator());
                    // hiển thị indicator tải
                  }
                  if (customers.isEmpty) {
                    // nếu ko tìm thấy KH nào
                    return const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      // padding phía trên
                      child: Center(child: Text('Không tìm thấy khách hàng')),
                      // hiển thị thông báo
                    );
                  }
                  return ListView.builder(
                    // widget hiển thị DS có thể cuộn
                    shrinkWrap: true,
                    // thu gọn kích thước theo nội dung
                    physics: const NeverScrollableScrollPhysics(),
                    // vô hiệu hóa cuộn bên trong listview
                    itemCount: customers.length,
                    // số lượng mục trong DS
                    itemBuilder: (context, index) {
                      // xây dựng từng mục trong DS
                      final customer = customers[index];
                      // lấy KH tại index
                      return ListTile(
                        // hiển thị thông tin KH
                        title: Text(customer.name),
                        // hiển thị tên KH
                        leading: const Icon(Icons.person, size: 30),
                        // icon đại diện
                        trailing: Text(customer.phoneNumber),
                        // hiển thị sđt
                        onTap: () {
                          // xử lý khi nhấn vào 1 KH
                          widget.onCustomerTap(customer);
                          // gọi func callback từ widget cha
                          _onCancelIconPressed();
                          // xóa nội dung tìm kiếm
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}