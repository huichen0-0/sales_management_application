import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/search/searching_controller.dart';

import '../../../products/product.dart';

class ProductSearchBar extends StatefulWidget {
  final Widget backgroundWidget; // Widget nền (có thể tùy chỉnh)
  final void Function(Product product) onProductTap; // Hàm xử lý khi chọn sản phẩm
  List<Product> products = [];
  ProductSearchBar({
    super.key,
    required this.onProductTap,
    required this.backgroundWidget,
    required this.products
  });

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState(products);
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  //controller lấy input
  final TextEditingController _textController = TextEditingController();

  //controller tìm kiếm
  late SearchingController _searchingController;

//fake dữ liệu danh sách sản phẩm //sau lấy từ db rồi chuyển sang dạng map
  List<Map<String, dynamic>> products = [];

  _ProductSearchBarState(List<Product> productsList) {
    for (var i in productsList) {
      products.add(i.toJSON());
    }
  }

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

                        // Lấy từng đối tượng trong searchResults
                        String id =
                            _searchingController.searchResults[index]['id'].toString();
                        String name =
                            _searchingController.searchResults[index]['name'];
                        int quantity = _searchingController.searchResults[index]
                            ['quantity'];
                        num sellingPrice = _searchingController
                            .searchResults[index]['sellingPrice'];
                        num capitalPrice = _searchingController
                            .searchResults[index]['capitalPrice'];
                        String unit =
                            _searchingController.searchResults[index]['unit'];
                        num minLimit = _searchingController.searchResults[index]['minLimit'];
                        num maxLimit = _searchingController.searchResults[index]['maxLimit'];
                        Product product = Product(
                            id: id,
                            quantity: quantity,
                            name: name,
                            sellingPrice: sellingPrice,
                            capitalPrice: capitalPrice,
                            unit: unit,
                          minLimit: minLimit,
                          maxLimit: maxLimit, barcode: '', notes: '',
                        );

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
