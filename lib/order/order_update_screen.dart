import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/invoice/invoice_controller.dart';
import 'package:sales_management_application/invoice/invoice_receipt.dart';
import 'package:sales_management_application/order/order_controller.dart';
import 'package:sales_management_application/products/product_controller.dart';
import 'package:sales_management_application/products/product_filter.dart';
import '../config/constants.dart';
import '../customers/model/customer.dart';
import '../helper/helper.dart';
import '../order/order_detail.dart';
import '../order/overlay.dart';
import '../products/product.dart';
import '../views/widgets/dialogs/confirmation_dialog.dart';
import 'order.dart';

class UpdateOrderScreen extends StatefulWidget {
  final Order? existingOrder;

  const UpdateOrderScreen({super.key, this.existingOrder});

  @override
  UpdateOrderScreenState createState() => UpdateOrderScreenState();
}

class UpdateOrderScreenState extends State<UpdateOrderScreen> {
  // Danh sách tất cả sản phẩm có trong cửa hàng
  List<Product> _allProducts = [];
  late Future<List<Product>> _futureAllProducts;
  // Đối tượng order mới
  Order _order = Order.empty();

  // Danh sách các sản phẩm sau khi tìm kiếm
  List<Product> _filteredProducts = [];

  // Quản lý Overlay để hiển thị kết quả tìm kiếm
  OverlayEntry? _overlayEntry;

  // LayerLink để định vị Overlay
  final LayerLink _layerLink = LayerLink();

  // Controller cho TextField tìm kiếm
  final TextEditingController _searchController = TextEditingController();

  // Controller cho order
  final OrderController _orderController = OrderController();
  InvoiceController invoiceController = InvoiceController();
  final _productController = ProductController();

  // Trạng thái mở rộng của FloatingActionButton
  bool _isExpanded = false;
  ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();
    ProductFilter filter = ProductFilter();
    filter.isActive = true;
    filter.isInactive = false;
    _futureAllProducts = productController.getProductList(filter).then((products) {
      setState(() {
        _allProducts = products;
        //Kiểm tra có order truyền qua không?
        if (widget.existingOrder != null) {
          //lâý order để chỉnh sửa
          _order = widget.existingOrder!;
          // Lọc ra các ID sản phẩm đã có trong đơn hàng
          final existingProductIds = _order.details.map((detail) => detail.productId).toSet();

          // Loại bỏ các sản phẩm có ID trùng với sản phẩm trong đơn hàng ra khỏi _filteredProducts
          _allProducts.removeWhere((product) => existingProductIds.contains(product.id)); //Loại những product đã trong order ra khỏi danh sách tất cả product

        }
        _filterProducts(''); // Gọi hàm này sau khi lấy dữ liệu
      });
      return products; // Trả về để FutureBuilder hoạt động đúng
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
      // Thêm sản phẩm đã chọn vào danh sách _newOrder
      _order.details.add(
        OrderDetail(productId: product.id, product: product, quantity: 1),
      );
    });
  }

  // Hàm cập nhật số lượng sản phẩm trong đơn hàng
  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      // Nếu số lượng mới <= 0, thì loại bỏ sản phẩm khỏi đơn hàng
      if (newQuantity <= 0) {
        // Thêm lại sản phẩm vào danh sách _allProducts
        _allProducts.add(_order.details[index].product!);
        //Tìm kiếm lại danh sách
        _filterProducts('');
        // Xóa sản phẩm khỏi đơn hàng
        _order.details.removeAt(index);
      } else {
        // Cập nhật số lượng sản phẩm trong đơn hàng
        _order.details[index].quantity = newQuantity;
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
            .where((product) =>
        product.name.toLowerCase().contains(lowerCaseQuery) ||
            (product.sellingPrice.toString().contains(lowerCaseQuery)))
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

  // Hàm loại bỏ tất cả sản phẩm trong _newOrder
  void _clearOrderDetails() {
    setState(() {
      _allProducts.addAll(_order.details.map((e) => e.product!));
      _order.details.clear();
      _filterProducts(''); // Gọi _filterProducts để cập nhật UI
      _isExpanded = false;
    });
  }

  @override
  void dispose() {
    // Giải phóng resources khi widget không còn sử dụng
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: widget.existingOrder != null
            ? const Text('Tạo đơn đặt hàng')
            : const Text('Cập nhật đơn đặt hàng'),
      ),
      body: _buildBody(),
      persistentFooterButtons: [
        _buildPersistentFooterButtons(),
      ],
      floatingActionButton:
          _order.details.isNotEmpty ? _buildFloatingActionButtons() : null,
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }

  ///Hàm xây dựng body
  Widget _buildBody() {
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
          onChanged: (value) {
            _filterProducts(value);
          },
        ),
      ),
    );
  }

  /// Hàm xây dựng list product
  Widget _buildListView() {
    return Expanded(
      child: ListView.separated(
        itemCount: _order.details.length + _filteredProducts.length,
        separatorBuilder: (context, index) {
          if (index == _order.details.length - 1) {
            return const Divider();
          }
          return const SizedBox();
        },
        itemBuilder: (context, index) {
          if (index < _order.details.length) {
            final orderDetail = _order.details[index];
            final product = orderDetail.product!;
            return _buildSelectedProductCard(orderDetail, product, index);
          } else {
            final product = _filteredProducts[index - _order.details.length];
            return _buildProductCard(product);
          }
        },
      ),
    );
  }

  /// Hàm xây dựng hiển thị card hàng hóa chọn
  Widget _buildSelectedProductCard(
    OrderDetail orderDetail,
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
              orderDetail.quantity - 1,
            ),
          ),
          Text('${orderDetail.quantity}'),
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // orderDetail.quantity < product.quantity
                //     ?
                    _updateQuantity(
                        index,
                        orderDetail.quantity + 1,
                      );
                    // : _showSnackBar(
                    //     'Số lượng mặt hàng "${orderDetail.product!.name}" đã đạt tối đa!',
                    //     Colors.red,
                    //   );
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
                  _order.customer = result;
                  _order.customerId = result.id;
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
                _order.customerId.isNotEmpty
                    ? _order.customer!.name
                    : AppString.selectCustomer,
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
            'Tổng [${_order.totalQuantity}]  ${Helper.formatCurrency(_order.totalAmount)}'),
        if (_order.details.isNotEmpty)
          TextButton(
            onPressed: _clearOrderDetails,
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
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// xây dựng nút "+"
  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isExpanded)
          FloatingActionButton.extended(
            heroTag: "temp_btn",
            onPressed: () {
              _handleSaveTemporary();
              setState(() {
                _isExpanded = false;
              });
            },
            backgroundColor: Colors.white,
            label: const Text(AppString.saveTemporary,
                style: TextStyle(color: Colors.black)),
          ),
        if (_isExpanded)
          const SizedBox(
            height: 5,
          ),
        if (_isExpanded)
          FloatingActionButton.extended(
            heroTag: "pay_btn",
            onPressed: () {
              _handlePayment();
              setState(() {
                _isExpanded = false;
              });
            },
            backgroundColor: Colors.blue,
            label: const Text(AppString.pay,
                style: TextStyle(color: Colors.white)),
          ),
        FloatingActionButton(
          onPressed: () {
            _order.customer == null
                ? _showSnackBar(AppString.errorNoCustomer, Colors.red)
                : setState(() {
                    _isExpanded = !_isExpanded;
                  });

          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.check, color: Colors.white),
        ),
      ],
    );
  }

  /// xử lý khi nhấn lưu tạm
  void _handleSaveTemporary() {
    ConfirmationDialog.show(
      context: context,
      title: AppString.confirmTemporaryTitle,
      content: AppString.confirmTemporaryContent,
      onConfirm: () {
        final success = _orderController.saveTemporary(_order);
        if (success) {
          context.pop();
          _showSnackBar(AppString.successTemporary, Colors.green);
        } else {
          _showSnackBar(AppString.error, Colors.red);
        }
      },
    );
  }

  /// xử lý khi nhấn thanh toán
  void _handlePayment() {
    final check = _order.details.any((i) => i.quantity > i.product!.quantity);
    if (check) {
      _showSnackBar(
            'Số lượng tồn kho không đủ để thanh toán',
            Colors.red,
          );
    } else {
      var newInvoice = _orderController.createInvoiceBasedOnOrder(_order);
      context.push(AppPath.salePayment, extra: newInvoice).then(
            (result) {
          if (result != null && result is InvoiceReceipt) {
            //TODO: insert hóa đơn vào db, dùng invoice controller?
            _orderController.saveComplete(_order);
            invoiceController.saveReceipt(result);
            _productController.subAmount(result);
            context.pop();
          }
        },
      );
    }
  }
}
