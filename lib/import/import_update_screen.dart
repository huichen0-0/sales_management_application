import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/products/product.dart';
import 'package:sales_management_application/products/product_filter.dart';
import '../../../views/widgets/dialogs/confirmation_dialog.dart';
import '../helper/helper.dart';
import '../products/product_controller.dart';
import '../receipt/receipt.dart';
import '../receipt/receipt_detail.dart';
import '../suppliers/supplier.dart';
import 'import_controller.dart';
import '/views/widgets/search_bars/search_product.dart';
import 'import_receipt.dart';

class UpdateImportScreen extends StatefulWidget {
  final ImportReceipt? existingReceipt; // Tham số cho phiếu nhập hàng hiện có
  const UpdateImportScreen({super.key, this.existingReceipt});

  @override
  State<UpdateImportScreen> createState() => _UpdateImportScreenState();
}

class _UpdateImportScreenState extends State<UpdateImportScreen> {
  //phiếu nhập hàng
  ImportReceipt receipt = ImportReceipt.empty();
  List<Product> products = [];
  ProductController productController = ProductController();
  ProductFilter filter = ProductFilter();
  //nhập hàng controller
  final ImportController _controller = ImportController();

  @override
  void initState() {
    super.initState();
    filter.isInactive = false;
    filter.isActive = true;
    // Nếu đang cập nhật phiếu nhập hàng, gán dữ liệu vào `receipt`
    if (widget.existingReceipt != null) {
      receipt = widget.existingReceipt!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.existingReceipt == null
            ? AppString.createImportReceipt
            : AppString.updateImportReceipt),
      ),
      body: FutureBuilder<List<Product>>(
        future: productController.getProductList(filter), // Pass the Future function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle any error that occurs during data fetching
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            products = snapshot.data!;
            // TODO: loc thoi gian o day
            // selectedOption;}
            return SingleChildScrollView(
              child: ProductSearchBar(
                onProductTap: (product) {
                  //nhập hàng tra hàng hóa đã trong phiếu nhập hàng chưa
                  if (_controller.existDetail(receipt, product.id)) {
                    // rồi sẽ lấy ra tiếp tục nhập hàng
                    final detail = _controller.getDetailByProductId(receipt, product.id);
                    _showReceiptDetailDialog(detail, false);
                  } else {
                    //chưa sẽ tạo hàng nhập
                    // àng mới
                    final detail = ReceiptDetail(
                        product: product,
                        quantity: 1,
                        productId: product.id); //TODO: min = 1
                    _showReceiptDetailDialog(detail, true);
                  }
                },
                backgroundWidget: Column(
                  children: [
                    // Giao diện chọn nhà cung cấp
                    GestureDetector(
                      onTap: () async {
                        context.push(AppPath.supplierSelection).then((result) {
                          if (result != null && result is Supplier) {
                            setState(() {
                              receipt.supplier = result;
                              receipt.partnerId = result.id;
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              receipt.partnerId != ''
                                  ? '${AppString.supplier}: ${receipt.supplier!.name}'
                                  : AppString.selectSupplier,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    receipt.details.isNotEmpty
                        ? _buildTableView()
                        : _buildEmptyView(),
                  ],
                ), products: products,
              ),
            );
          } else {
            return _buildEmptyView();
          }
        },
      ),
      bottomNavigationBar:
          receipt.details.isNotEmpty ? _buildBottomNavigationBar() : null,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (receipt.partnerId != '') {
            context.push(AppPath.payment, extra: receipt).then((result) {
              if (result != null && result is Receipt) {
                _controller.saveReceipt(receipt);
                productController.addAmount(receipt);
                context.pop();
              }
            });
          } else {
            //TODO: dùng snackbar thông báo
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(AppString.errorNoSupplier),
                duration: const Duration(seconds: 2),
                // Thời gian hiển thị 2 giây
                backgroundColor: Colors.red,
                // Màu nền đỏ
                action: SnackBarAction(
                  // Thêm hành động
                  label: AppString.ok,
                  onPressed: () {  },
                ),
              ),
            );
          }
        }, // TODO: xử lý nút
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: const Text(AppString.pay),
      ),
    );
  }

  // hiển thị danh sách trống
  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 64,
          ),
          Icon(Icons.remove_shopping_cart, size: 80, color: Colors.grey),
          SizedBox(
            height: 16,
          ),
          Text(AppString.emptyProductInReceipt),
        ],
      ),
    );
  }

  Widget _buildTableView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false, // Ẩn ô vuông chọn
        columns: const [
          DataColumn(
            label: Text(
              AppString.importedProduct,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              AppString.quantity,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            numeric: true, // Đánh dấu cột là kiểu số
          ),
          DataColumn(
            label: Text(
              AppString.amount,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            numeric: true, // Đánh dấu cột là kiểu số
          ),
        ],
        rows: [
          // Thêm một hàng để hiển thị tổng
          DataRow(
            cells: [
              DataCell(
                Text(
                  '${receipt.details.length} mặt hàng',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(
                Text(
                  Helper.formatCurrency(receipt.totalQuantity),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(
                Text(
                  Helper.formatCurrency(receipt.totalImportValue),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          for (var detail in receipt.details) _buildDataRow(detail),
        ],
      ),
    );
  }

  DataRow _buildDataRow(ReceiptDetail detail) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            children: [
              Text(
                detail.product!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                Helper.formatCurrency(detail.product!.capitalPrice),
              )
            ],
          ),
        ),
        DataCell(Text('${Helper.formatCurrency(detail.quantity)} '
            '${detail.product!.unit}')),
        DataCell(Text(Helper.formatCurrency(detail.capitalValue))),
      ],
      // Thay thế onLongPress bằng onSelectChanged để xử lý khi nhấp vào hàng
      onSelectChanged: (selected) {
        if (selected != null && selected) {
          _showReceiptDetailDialog(detail, false);
        }
      },
    );
  }

  // Hàm hiển thị dialog chi tiết hàng hóa
  void _showReceiptDetailDialog(ReceiptDetail detail, bool isNew) {
    // Controller cho TextField để nhập số lượng nhập hàng
    final quantityController = TextEditingController(
      text: detail.quantity.toString(),
    );

    // Hiển thị dialog
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) {
        // Biến lưu trữ giá trị "Thành tiền"
        num totalPrice = detail.quantity * detail.product!.capitalPrice;
        // Hàm cập nhật số lượng đã nhập hàng
        void updateImportQuantity(num newValue) {
          setState(() {
            detail.quantity = newValue;
            quantityController.text = newValue.toString();
            totalPrice = detail.quantity * detail.product!.capitalPrice;
          });
        }

        return AlertDialog(
          backgroundColor: Colors.black87,
          // Nền tối cho dialog
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(16),
          title: _buildDialogTitle(detail, isNew),
          // Tiêu đề dialog
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hiển thị thông tin về hàng hóa
              _buildProductInfoRow(
                  AppString.inventory, detail.product!.quantity),
              _buildProductInfoRow(
                  AppString.unitPrice, detail.product!.capitalPrice),
              _buildProductInfoRow(AppString.totalPrice, totalPrice),
              const SizedBox(height: 20),
              // Thành phần điều chỉnh số lượng đã nhập hàng
              _buildQuantityAdjuster(
                  quantityController, detail, updateImportQuantity),
              const SizedBox(height: 20),
              // Nút hành động (Thoát, Xong)
              _buildDialogActions(context, detail, quantityController),
            ],
          ),
        );
      }),
    );
  }

// Tiêu đề của dialog, bao gồm tên hàng hóa và nút xóa
  Widget _buildDialogTitle(ReceiptDetail detail, bool isNew) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          child: Text(
            detail.product!.name[0].toUpperCase(),
            // Chữ cái đầu tên sản phẩm
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        // Tên sản phẩm
        Expanded(
          child: Text(
            detail.product!.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        // Nút xóa sản phẩm khỏi phiếu
        if (!isNew)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog hiện tại
              _handleRemoveProduct(detail); // Mở dialog xác nhận xóa
            },
          ),
      ],
    );
  }

// Hiển thị một hàng thông tin về sản phẩm (nhãn và giá trị)
  Widget _buildProductInfoRow(String label, num value,
      {Color? highlightColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)), // Nhãn
          Text(
            Helper.formatCurrency(value), // Giá trị
            style:
                TextStyle(color: highlightColor ?? Colors.white), // Màu nếu cần
          ),
        ],
      ),
    );
  }

// Thành phần điều chỉnh số lượng nhập hàng (gồm giảm, nhập số, tăng)
  Widget _buildQuantityAdjuster(
      TextEditingController controller,
      ReceiptDetail detail,
      void Function(num) updateImportQuantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(AppString.quantity, style: TextStyle(color: Colors.grey)),
        // Nhãn
        Row(
          children: [
            // Nút giảm số lượng
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: () {
                if (detail.quantity > AppNum.one) {
                  //TODO: min = 1
                  updateImportQuantity(detail.quantity.toInt() - AppNum.one);
                }
              },
            ),
            // Trường nhập số lượng
            SizedBox(
              width: 100,
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // // Chỉ cho phép nhập số
                  // ThousandsFormatter(),
                ],
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  //chuyển text nhập thành số
                  num? parsedValue = num.tryParse(value);
                  //check điều kiện: <1 set mặc định = 1
                  if (parsedValue == null || parsedValue < AppNum.one) {
                    parsedValue = AppNum.one;
                  }
                  //cập nhật số lượng nhập
                  updateImportQuantity(parsedValue);
                  //cập nhật vị trí con trỏ
                  String valueString = parsedValue.toString();
                  controller.value = TextEditingValue(
                    text: valueString,
                    selection: TextSelection.collapsed(
                      offset: valueString.length, // Vị trí con trỏ
                    ),
                  );
                },
              ),
            ),
            // Nút tăng số lượng
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                updateImportQuantity(detail.quantity.toInt() + AppNum.one);
              },
            ),
          ],
        ),
      ],
    );
  }

// Hành động phía dưới dialog (Thoát, Xong)
  Widget _buildDialogActions(
    BuildContext context,
    ReceiptDetail detail,
    TextEditingController controller,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Nút Thoát
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child:
              const Text(AppString.exit, style: TextStyle(color: Colors.blue)),
        ),
        // Nút Xong
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            setState(() {
              // Cập nhật số lượng nhập hàng
              detail.quantity = num.tryParse(controller.text) ?? AppNum.one;
              // Cập nhật detail trong receipt
              _controller.updateDetail(receipt, detail);
            });
            Navigator.of(context).pop(); // Đóng dialog
          },
          child: const Text('XONG'),
        ),
      ],
    );
  }
  /// Hàm hiển thị hộp thoại xác nhận hủy phiếu
  void _handleRemoveProduct(ReceiptDetail detail) {
    ConfirmationDialog.show(
      context: context,
      title: AppString.removeProductTitle,
      content: AppString.removeProductContent,
      onConfirm: () {
        _controller.removeDetail(receipt, detail);
      },
    );
  }

}
