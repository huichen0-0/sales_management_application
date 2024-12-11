import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/controllers/searching_controller.dart';
import 'package:sales_management_application/models/product.dart';

class ProductSearchBar extends StatefulWidget {
  final Widget backgroundWidget; // Widget nền (có thể tùy chỉnh)
  final void Function(Product product)
      onProductTap; // Hàm xử lý khi chọn sản phẩm

  const ProductSearchBar({
    super.key,
    required this.onProductTap,
    required this.backgroundWidget,
  });

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  //controller lấy input
  final TextEditingController _textController = TextEditingController();

  //controller tìm kiếm
  late SearchingController _searchingController;

//fake dữ liệu danh sách sản phẩm //sau lấy từ db rồi chuyển sang dạng map
  List<Map<String, dynamic>> products = [
    {
      'id': "1",
      'name': 'Giò heo',
      'sellingPrice': 2000000,
      'capitalPrice': 1000000,
      'quantity': 400,
      'unit': 'Kg',
      'minLimit': 10,
      'maxLimit': 1000,
      'barcode': '1314124212',
      'description': '100% thịt heo rừng',
      'notes': 'hàng vip',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(seconds: 5)),
    },
    {
      'id': '2',
      'name': 'Giò heo X',
      'sellingPrice': 2010000,
      'capitalPrice': 1000000,
      'quantity': 100,
      'unit': 'Kg',
      'minLimit': 10,
      'maxLimit': 1000,
      'barcode': '1314124212',
      'description': '100% thịt heo rừng',
      'notes': 'hàng vip',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(seconds: 15)),
    },
    {
      'id': 3,
      'name': 'Giò heo Y',
      'sellingPrice': 2110000,
      'capitalPrice': 1000000,
      'quantity': 200,
      'unit': 'Kg',
      'minLimit': 10,
      'maxLimit': 1000,
      'barcode': '1314124212',
      'description': '100% thịt heo rừng',
      'notes': 'hàng vip',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(seconds: 25)),
    },
    {
      'id': '4',
      'name': 'Giò heo Z',
      'sellingPrice': 201000,
      'capitalPrice': 102000,
      'quantity': 800,
      'unit': 'Kg',
      'minLimit': 10,
      'maxLimit': 1000,
      'barcode': '1314124212',
      'description': '100% thịt heo rừng',
      'notes': 'hàng vip',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(seconds: 55)),
    },
    {
      'id': '5',
      'name': 'Giò hổ',
      'sellingPrice': 201000,
      'capitalPrice': 102000,
      'quantity': 800,
      'unit': 'Kg',
      'minLimit': 10,
      'maxLimit': 1000,
      'barcode': '1314124212',
      'description': '100% thịt heo rừng',
      'notes': 'hàng vip',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(seconds: 55)),
    },
    {
      'id': '6',
      'name': 'Giò hổ VN',
      'sellingPrice': 201000,
      'capitalPrice': 102000,
      'quantity': 800,
      'unit': 'Kg',
      'minLimit': 10,
      'maxLimit': 1000,
      'barcode': '1314124212',
      'description': '100% thịt heo rừng',
      'notes': 'hàng vip',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(seconds: 55)),
    },
    {
      'id': '7',
      'name': 'Giò hổ US',
      'sellingPrice': 201000,
      'capitalPrice': 102000,
      'quantity': 800,
      'unit': 'Kg',
      'minLimit': 10,
      'maxLimit': 1000,
      'barcode': '1314124212',
      'description': '100% thịt heo rừng',
      'notes': 'hàng vip',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(seconds: 55)),
    },
    {
      'id': '8',
      'name': 'Giò bò UK',
      'sellingPrice': 201000,
      'capitalPrice': 102000,
      'quantity': 800,
      'unit': 'Kg',
      'minLimit': 10,
      'maxLimit': 1000,
      'barcode': '1314124212',
      'description': '100% thịt heo rừng',
      'notes': 'hàng vip',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(seconds: 55)),
    },
    {
      'id': '9',
      'name': 'Giò bò Ấn Độ',
      'sellingPrice': 201000,
      'capitalPrice': 102000,
      'quantity': 800,
      'unit': 'Kg',
      'minLimit': 10,
      'maxLimit': 1000,
      'barcode': '1314124212',
      'description': '100% thịt heo rừng',
      'notes': 'hàng vip',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(seconds: 55)),
    },
    {
      'id': '10',
      'name': 'Giò gà China',
      'sellingPrice': 201000,
      'capitalPrice': 102000,
      'quantity': 800,
      'unit': 'Kg',
      'minLimit': 10,
      'maxLimit': 1000,
      'barcode': '1314124212',
      'description': '100% thịt heo rừng',
      'notes': 'hàng vip',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(seconds: 55)),
    },
    {
      'id': '11',
      'name': 'Chả lụa',
      'sellingPrice': 201000,
      'capitalPrice': 102000,
      'quantity': 800,
      'unit': 'Kg',
      'minLimit': 10,
      'maxLimit': 1000,
      'barcode': '1314124212',
      'description': '100% thịt heo rừng',
      'notes': 'hàng vip',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(seconds: 55)),
    },
  ];

  @override
  void initState() {
    super.initState();
    // Khởi tạo SearchingController với dữ liệu đầu vào
    _searchingController = SearchingController(
      searchData: products,
      searchOptions: [
        {'searchKey': 'name', 'tag': '', 'hint': 'Chọn hàng hóa kiểm'}
      ],
    );

    // Đặt listener cho TextField để cập nhật kết quả tìm kiếm
    _textController.addListener(() {
      _searchingController.updateSearchResults(_textController.text);
      setState(() {}); // Cập nhật UI khi có thay đổi kết quả
    });
  }

  // Hàm xử lý khi nhấn vào icon quét mã vạch
  void _onBarcodeScanPressed() {
    print('Quét mã vạch');
    // TODO: Thêm mã quét mã vạch thực tế ở đây
  }

  // Hàm xử lý khi nhấn vào icon x
  void _onCancelIconPressed() {
    print('Đặt lại thanh tìm kiếm');
    _textController.clear();
    setState(() {});
  }

  // Hàm xử lý khi nhấn vào icon +
  void _onAddIconPressed() {
    print('Thêm hàng hóa');
    context.push('/products/add');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: _onBarcodeScanPressed,
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: [
              // Giao diện nền tùy chỉnh
              widget.backgroundWidget,
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
                        Product product = Product.fromJSON(_searchingController.searchResults[index]);
                        return ListTile(
                          // Hiển thị tên sản phẩm
                          title: Text(product.name),
                          leading: const Icon(
                            Icons.image,
                            size: 30,
                          ),
                          // Xử lý khi chọn sản phẩm
                          onTap: () {
                            widget.onProductTap(product);
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
    );
  }
}
