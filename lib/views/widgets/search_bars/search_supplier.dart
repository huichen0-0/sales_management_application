import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/controllers/searching_controller.dart';
import '../../../models/supplier.dart';

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

  //controller tìm kiếm
  late SearchingController _searchingController;

//fake dữ liệu danh sách sản phẩm //sau lấy từ db rồi chuyển sang dạng map
  List<Map<String, dynamic>> suppliers = [
    {
      'id': "1",
      'name': 'Anh An',
      'phone': '099999999',
      'amount': 120000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'note': 'NCC vip 5',
      'isDeleted': false,
      'isActive': true,
      'uid': 'dnaa',
    },
    {
      'id': "2",
      'name': 'Vinmart',
      'phone': '0966666666',
      'amount': 120000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'note': 'NCC vip 5',
      'isDeleted': false,
      'isActive': true,
      'uid': 'dnaa',
    },
    {
      'id': "3",
      'name': 'BBQ',
      'phone': '0955555555',
      'amount': 120000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'note': 'NCC vip 5',
      'isDeleted': false,
      'isActive': true,
      'uid': 'dnaa',
    },
    {
      'id': "4",
      'name': 'bxs',
      'phone': '0955555555',
      'amount': 120000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'note': 'NCC vip 5',
      'isDeleted': false,
      'isActive': true,
      'uid': 'dnaa',
    },
    {
      'id': "5",
      'name': 'saa',
      'phone': '0955555555',
      'amount': 120000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'note': 'NCC vip 5',
      'isDeleted': false,
      'isActive': true,
      'uid': 'dnaa',
    },
    {
      'id': '6',
      'name': 'htt',
      'phone': '0955555555',
      'amount': 120000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'note': 'NCC vip 5',
      'isDeleted': false,
      'isActive': true,
      'uid': 'dnaa',
    },
    {
      'id': "7",
      'name': 'BcsQ',
      'phone': '0955555555',
      'amount': 120000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'note': 'NCC vip 5',
      'isDeleted': false,
      'isActive': true,
      'uid': 'dnaa',
    },
    {
      'id': "8",
      'name': 'BaQ',
      'phone': '0955555555',
      'amount': 120000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'note': 'NCC vip 5',
      'isDeleted': false,
      'isActive': true,
      'uid': 'dnaa',
    },
    {
      'id': "9",
      'name': 'ABBQ',
      'phone': '0955555555',
      'amount': 120000,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'email': 'ncc@example.com',
      'note': 'NCC vip 5',
      'isDeleted': false,
      'isActive': true,
      'uid': 'dnaa',
    },
  ];

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Chọn nhà cung cấp'),
      ),
      body: SingleChildScrollView(
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
                            //TODO: đã rút gọn
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
      ),
    );
  }
}
