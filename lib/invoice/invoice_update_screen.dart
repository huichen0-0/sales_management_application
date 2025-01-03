import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/invoice/invoice_controller.dart';
import 'package:sales_management_application/invoice/invoice_receipt.dart';
import 'package:sales_management_application/products/product_controller.dart';
import '../config/constants.dart';
import '../customers/customer.dart';
import '../helper/helper.dart';
import '../order/overlay.dart';
import '../products/product.dart';
import '../products/product_filter.dart';
import '../receipt/receipt_detail.dart';
import '../views/widgets/dialogs/confirmation_dialog.dart';

class UpdateInvoiceScreen extends StatefulWidget {
  final InvoiceReceipt? existingInvoice;

  const UpdateInvoiceScreen({super.key, this.existingInvoice});

  @override
  UpdateInvoiceScreenState createState() => UpdateInvoiceScreenState();
}

class UpdateInvoiceScreenState extends State<UpdateInvoiceScreen> {
  // Danh sách tất cả sản phẩm có trong cửa hàng
  List<Product> _allProducts = [  ];

  // Đối tượng invoice mới
  InvoiceReceipt _invoice = InvoiceReceipt.empty();

  // Danh sách các sản phẩm sau khi tìm kiếm
  List<Product> _filteredProducts = [];

  // Quản lý Overlay để hiển thị kết quả tìm kiếm
  OverlayEntry? _overlayEntry;

  // LayerLink để định vị Overlay
  final LayerLink _layerLink = LayerLink();

  // Controller cho TextField tìm kiếm
  final TextEditingController _searchController = TextEditingController();

  // Timer để debounce (trì hoãn) việc tìm kiếm
  Timer? _debounce;
  ProductController productController = ProductController();
  late Future<List<Product>> _futureAllProducts;
  InvoiceController invoiceController = InvoiceController();

  @override
  void initState() {
    super.initState();
    ProductFilter filter = ProductFilter();
    filter.isActive = true;
    filter.isInactive = false;
    _futureAllProducts = productController.getProductList(filter);
    //Kiểm tra có invoice truyền qua không?
    if (widget.existingInvoice != null) {
      //lâý invoice để chỉnh sửa
      _invoice = widget.existingInvoice!;
      //Loại những product đã trong invoice ra khỏi danh sách tất cả product
      for (var detail in _invoice.details) {
        _allProducts.remove(detail.product);
      }
    }
    // Khởi tạo danh sách _filteredProducts bằng danh sách _allProducts
    _filteredProducts = List.from(_allProducts);
  }

  // Hàm xử lý sự kiện khi người dùng nhập vào TextField tìm kiếm
  void _onSearch(String query) {
    // Nếu có debounce đang chạy, hủy nó
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    // Tạo một Timer mới, sau 500ms sẽ gọi hàm filterProducts
    _debounce = Timer(const Duration(milliseconds: 200), () {
      _filterProducts(query);
    });
  }

  // Hàm xử lý khi người dùng chọn một sản phẩm
  void _selectProduct(Product product) {
    setState(() {
      // Xóa sản phẩm đã chọn khỏi danh sách _allProducts
      _allProducts.remove(product);
      // Cập nhật lại danh sách _filteredProducts để không còn sản phẩm vừa chọn
      _filteredProducts = List.from(_allProducts);
      // Ẩn overlay kết quả tìm kiếm
      _removeOverlay();
      // Xóa text trong TextField tìm kiếm
      _searchController.clear();
      // Thêm sản phẩm đã chọn vào danh sách _newInvoice
      _invoice.details.add(
        ReceiptDetail(productId: product.id!, product: product, quantity: 1),
      );
    });
  }

  // Hàm cập nhật số lượng sản phẩm trong đơn hàng
  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      // Nếu số lượng mới <= 0, thì loại bỏ sản phẩm khỏi đơn hàng
      if (newQuantity <= 0) {
        // Thêm lại sản phẩm vào danh sách _allProducts
        _allProducts.add(_invoice.details[index].product!);
        //Tìm kiếm lại danh sách
        _filterProducts('');
        // Xóa sản phẩm khỏi đơn hàng
        _invoice.details.removeAt(index);
      } else {
        // Cập nhật số lượng sản phẩm trong đơn hàng
        _invoice.details[index].quantity = newQuantity;
      }
    });
  }

  // Hàm lọc danh sách sản phẩm dựa trên từ khóa tìm kiếm
  void _filterProducts(String query) {
    setState(() {
      // Nếu query rỗng, thì hiển thị lại toàn bộ danh sách
      if (query.isEmpty) {
        _filteredProducts = List.from(_allProducts);
        // Ẩn overlay tìm kiếm
        _removeOverlay();
      } else {
        // Chuyển query về chữ thường
        final lowerCaseQuery = query.toLowerCase();
        // Lọc danh sách _allProducts dựa trên từ khóa
        _filteredProducts = _allProducts
            .where(
                (product) => product.toJSON().toString().contains(lowerCaseQuery))
            .toList();
        // Hiển thị overlay kết quả tìm kiếm
        _showOverlay();
      }
    });
  }

  // Hàm hiển thị Overlay kết quả tìm kiếm
  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        child: OverlaySearchResult(
          products: _filteredProducts,
          onProductSelected: _selectProduct,
          layerLink: _layerLink,
        ),
      ),
    );
    // Thêm overlay vào view
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Hàm ẩn Overlay kết quả tìm kiếm
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Hàm clear text field tìm kiếm
  void _clearSearch() {
    _searchController.clear();
    _filterProducts(''); // Gọi _filterProducts để cập nhật UI
  }

  // Hàm loại bỏ tất cả sản phẩm trong _newReceipt
  void _clearReceiptDetails() {
    setState(() {
      _allProducts.addAll(_invoice.details.map((e) => e.product!));
      _invoice.details.clear();
      _filterProducts(''); // Gọi _filterProducts để cập nhật UI
    });
  }

  @override
  void dispose() {
    // Giải phóng resources khi widget không còn sử dụng
    _searchController.dispose();
    _debounce?.cancel();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Bán hàng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // context.go('/suppliers');
            context.pop();
          },
        ),
      ),
      body: _buildBody(),
      persistentFooterButtons: [
        _buildPersistentFooterButtons(),
      ],
      floatingActionButton:
          _invoice.details.isNotEmpty ? _buildFloatingActionButtons() : null,
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }

  ///Hàm xây dựng body
  Widget _buildBody() {
    ProductFilter filter = ProductFilter();
    filter.isActive = true;
    filter.isInactive = false;
    return FutureBuilder<List<Product>>(
      future: _futureAllProducts, // Pass the Future function here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle any error that occurs during data fetching
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          _allProducts = snapshot.data!;
        }
        return Stack(
          children: [
            Column(
              children: [
                _buildSearchBar(),
                _buildListView(),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Hàm xây dựng thanh tìm kiếm
  Widget _buildSearchBar() {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm sản phẩm...',
            prefixIcon: const Icon(Icons.add),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : null,
            border: const OutlineInputBorder(),
          ),
          onChanged: _onSearch,
        ),
      ),
    );
  }

  /// Hàm xây dựng list product
  Widget _buildListView() {
    return Expanded(
      child: ListView.separated(
        itemCount: _invoice.details.length + _filteredProducts.length,
        separatorBuilder: (context, index) {
          if (index == _invoice.details.length - 1) {
            return const Divider();
          }
          return const SizedBox();
        },
        itemBuilder: (context, index) {
          if (index < _invoice.details.length) {
            final invoiceDetail = _invoice.details[index];
            final product = invoiceDetail.product!;
            return _buildSelectedProductCard(invoiceDetail, product, index);
          } else {
            final product = _filteredProducts[index - _invoice.details.length];
            return _buildProductCard(product);
          }
        },
      ),
    );
  }

  /// Hàm xây dựng hiển thị card hàng hóa chọn
  Widget _buildSelectedProductCard(
    ReceiptDetail invoiceDetail,
    Product product,
    int index,
  ) {
    return ListTile(
      title: Text(product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SL: ${product.quantity} ${product.unit}'),
          Text('${Helper.formatCurrency(product.sellingPrice)} VND'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => _updateQuantity(
              index,
              invoiceDetail.quantity.toInt() - 1,
            ),
          ),
          Text('${invoiceDetail.quantity}'),
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                invoiceDetail.quantity < product.quantity
                    ? _updateQuantity(
                        index,
                        invoiceDetail.quantity.toInt() + 1,
                      )
                    : _showSnackBar(
                        'Số lượng mặt hàng "${invoiceDetail.product!.name}" đã đạt tối đa!',
                        Colors.red,
                      );
              }),
        ],
      ),
    );
  }

  ///Hàm xây dựng card hàng hóa chưa chọn
  Widget _buildProductCard(Product product) {
    return ListTile(
      title: Text(product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SL: ${product.quantity} ${product.unit}'),
          Text('${Helper.formatCurrency(product.sellingPrice)} VND'),
        ],
      ),
      onTap: () => _selectProduct(product),
    );
  }

  /// Hàm xây dựng vùng bottom
  Widget _buildPersistentFooterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () async {
            context.push(AppPath.customerSelection).then((result) {
              if (result != null && result is Customer) {
                setState(() {
                  _invoice.customer = result;
                  _invoice.partnerId = result.id;
                });
              }
            });
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _invoice.partnerId.isNotEmpty
                    ? _invoice.customer!.name
                    : AppString.retailCustomer,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        Text(
            'Tổng [${_invoice.totalQuantity}]  ${Helper.formatCurrency(_invoice.totalSaleValue)}'),
        if (_invoice.details.isNotEmpty)
          TextButton(
            onPressed: _clearReceiptDetails,
            child: const Text('Bỏ chọn', style: TextStyle(color: Colors.blue)),
          ),
      ],
    );
  }

  /// Hàm hiển thị thông báo
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// xây dựng nút "+"
  Widget _buildFloatingActionButtons() {
    return FloatingActionButton(
      onPressed: () {
         context.push(AppPath.salePayment, extra: _invoice).then(
          (result) {
            if (result != null && result is InvoiceReceipt) {
              invoiceController.saveReceipt(_invoice);
              context.pop();
            }
          },
        );
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.check, color: Colors.white),
    );
  }

/// xử lý khi nhấn lưu tạm
// void _handleSaveTemporary() {
//   ConfirmationDialog.show(
//     context: context,
//     title: AppString.confirmTemporaryTitle,
//     content: AppString.confirmTemporaryContent,
//     onConfirm: () {
//       final success = _invoiceController.saveTemporary(_invoice);
//       if (success) {
//         context.pop();
//         _showSnackBar(AppString.successTemporary, Colors.green);
//       } else {
//         _showSnackBar(AppString.error, Colors.red);
//       }
//     },
//   );
// }

// /// xử lý khi nhấn thanh toán
// void _handlePayment() {
//   var newInvoice = _invoiceController.createInvoiceBasedOnReceipt(_invoice);
//   context.push(AppPath.salePayment, extra: newInvoice).then(
//         (result) {
//       if (result != null && result is InvoiceReceipt) {
//         //TODO: insert hóa đơn vào db, dùng invoice controller?
//         context.pop();
//       }
//     },
//   );
// }
}
