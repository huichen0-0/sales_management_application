import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/suppliers/supplier_filter.dart';
import '../../../suppliers/supplier-controller.dart';
import '../../../search/searching_controller.dart';
import '../../../suppliers/supplier.dart';

class SupplierSelectionSceen extends StatefulWidget {
  final void Function(Supplier supplier)
      onSupplierTap; // Hàm xử lý khi chọn sản phẩm

  const SupplierSelectionSceen({
    super.key,
    required this.onSupplierTap,
  });

  @override
  State<SupplierSelectionSceen> createState() => _SupplierSelectionSceenState();
}

class _SupplierSelectionSceenState extends State<SupplierSelectionSceen> {
  //controller lấy input
  final TextEditingController _textController = TextEditingController();
  SupplierController supplierController = SupplierController();
  //controller tìm kiếm
  late SearchingController _searchingController;

//fake dữ liệu danh sách sản phẩm //sau lấy từ db rồi chuyển sang dạng map
  List<Map<String, dynamic>> suppliers = [ ];

  @override
  void initState() {
    super.initState();
    // Khởi tạo SearchingController với dữ liệu đầu vào
    _searchingController = SearchingController(
      searchData: suppliers,
      searchOptions: [
        {'searchKey': 'name', 'tag': '', 'hint': 'Chọn nhà cung cấp'}
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
    print('Đặt lại thanh tìm kiếm');
    _textController.clear();
  }

  // Hàm xử lý khi nhấn vào icon +
  void _onAddIconPressed() {
    print('Thêm hàng hóa');
    context.push('/suppliers/add');
  }

  @override
  Widget build(BuildContext context) {
    SupplierFilter filter = SupplierFilter();
    filter.isInactive = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Chọn nhà cung cấp'),
      ),
      body: FutureBuilder<List<Supplier>>(
        future: supplierController.getSupplierToSearch(filter), // Pass the Future function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle any error that occurs during data fetching
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            suppliers = supplierController.convertToJson(snapshot.data!);
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
                        itemCount: suppliers.length,
                        itemBuilder: (context, index) {
                          final supplier = suppliers[index];
                          return ListTile(
                            title: Text(supplier['name']),
                            leading: const Icon(Icons.image, size: 30),
                            trailing: Text(supplier['phone']),
                            onTap: () {
                              widget.onSupplierTap(Supplier.fromJson(supplier));
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
                                Supplier supplier = Supplier.fromJson(
                                    _searchingController.searchResults[index]);
                                return ListTile(
                                  // Hiển thị tên sản phẩm
                                  title: Text(supplier.name),
                                  leading: const Icon(
                                    Icons.image,
                                    size: 30,
                                  ),
                                  trailing: Text(supplier.phone),
                                  // Xử lý khi chọn sản phẩm
                                  onTap: () {
                                    widget.onSupplierTap(supplier);
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
