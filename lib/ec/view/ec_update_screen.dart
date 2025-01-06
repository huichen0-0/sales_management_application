import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/authentication/forgot_password_screen.dart';
import 'package:sales_management_application/products/product.dart';
import 'package:sales_management_application/ec/ec_filter.dart';
import 'package:sales_management_application/products/product_filter.dart';
import '../../helper/helper.dart';
import '../../views/widgets/dialogs/confirmation_dialog.dart';
import '../controller/ec_controller.dart';
import '../../products/product_controller.dart';
import '../export_receipt.dart';
import 'export_receipt_detail.dart';
import '/views/widgets/search_bars/search_product.dart';
import 'ec_home_screen.dart';

class UpdateExportCancellationScreen extends StatefulWidget {
  final ExportCancellationReceipt? receipt; // Tham số cho phiếu xuất hủy hiện có
  final String id;
  const UpdateExportCancellationScreen({super.key, required this.id, required this.receipt});

  @override
  State<UpdateExportCancellationScreen> createState() => _UpdateExportCancellationScreenState(id, receipt);
}

class _UpdateExportCancellationScreenState extends State<UpdateExportCancellationScreen> {

  ExportCancellationReceipt? receipt = ExportCancellationReceipt.empty();
  final ExportCancellationController _controller = ExportCancellationController();
  ProductController productController = ProductController();// Tham số cho phiếu xuất hủy hiện có
  String? id;
  List<Product> products = [];

  _UpdateExportCancellationScreenState(this.id, this.receipt);

  @override
  void initState() {
    super.initState();
    if (widget.receipt != null) {
      receipt = widget.receipt!;
    }
  }

  @override
  Widget build(BuildContext context) {
    ProductFilter filter = ProductFilter();
    filter.isInactive = false;
    filter.isAvailable = true;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.receipt == null
            ? 'Tạo phiếu xuất hủy'
            : 'Cập nhật phiếu xuất hủy'),
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
            return SingleChildScrollView(
              child: ProductSearchBar(
                onProductTap: (product) {
                  //kiểm tra hàng hóa đã trong phiếu kiểm chưa
                  if (_controller.existDetail(receipt!, product.id)) {
                    // rồi sẽ lấy ra tiếp tục kiểm
                    final detail =
                    _controller.getDetailByProductId(receipt!, product.id);
                    _showReceiptDetailDialog(detail, false);
                  } else {
                    //chưa sẽ tạo hàng kiểm mới
                    final detail = ExportCancellationReceiptDetail(
                        product: product,
                        cancelledQuantity: 1,
                        productId: product.id);
                    _showReceiptDetailDialog(detail, true);
                  }
                },
                backgroundWidget: receipt!.details.isNotEmpty ? _buildTableView() : _buildEmptyView(),
                products: products
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )

,
      bottomNavigationBar: receipt!.details.isNotEmpty
          ? Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                receipt?.status = 1;
                _controller.save(receipt!);
                context.pop();
                _showSnackBar('Tạo đơn thành công!', Colors.green);
              },
              style:
              ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Lưu tạm'),
            ),
            ElevatedButton(
              onPressed: () {
                _addEc();
              },
              style:
              ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Hoàn thành'),
            ),
          ],
        ),
      )
          : null,
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addEc() {
    ConfirmationDialog.show(
      context: context,
      title: 'Thêm đơn xuất hủy',
      content: 'Bạn có chắc muốn thêm đơn này không?',
      onConfirm: () {
        receipt?.status = 2;
        _controller.save(receipt!);
        productController.subAmountEc(receipt!);
        context.pop();
        _showSnackBar('Tạo đơn thành công!', Colors.green);
      },
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
          Text('Chưa có hàng hóa trong phiếu xuất hủy'),
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
              'Hàng hủy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Số lượng hủy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            numeric: true, // Đánh dấu cột là kiểu số
          ),
          DataColumn(
            label: Text(
              'Giá trị hủy',
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
                  '${receipt?.details.length} mặt hàng',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(
                Text(
                  Helper.formatCurrency(receipt!.totalCancelledQuantity),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(
                Text(
                  Helper.formatCurrency(receipt!.totalCancelledValue),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          for (var item in receipt!.details) _buildDataRow(item),
        ],
      ),
    );
  }

  DataRow _buildDataRow(ExportCancellationReceiptDetail item) {
    return DataRow(
      cells: [
        DataCell(Text(item.product!.name)),
        DataCell(Text(Helper.formatCurrency(item.cancelledQuantity))),
        DataCell(Text(Helper.formatCurrency(item.cancelledValue))),
      ],
      // xử lý khi nhấp vào hàng
      onSelectChanged: (selected) {
        if (selected != null && selected) {
          _showReceiptDetailDialog(item, false);
        }
      },
    );
  }

  // Hàm hiển thị dialog chi tiết hàng hóa
  void _showReceiptDetailDialog(
      ExportCancellationReceiptDetail detail, bool isNew) {
    // Controller cho TextField để nhập số lượng kiểm
    final quantityController = TextEditingController(
      text: detail.cancelledQuantity.toString(),
    );

    // Hiển thị dialog
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            num totalCancelledValue =
                detail.cancelledQuantity * detail.product!.capitalPrice;
            // Hàm cập nhật số lượng đã kiểm
            void updateCancelledQuantity(int newValue) {
              setState(() {
                detail.cancelledQuantity = newValue;
                quantityController.text = newValue.toString();
                totalCancelledValue = detail.cancelledQuantity * detail.product!.capitalPrice;
              });
            }

            return AlertDialog(
              backgroundColor: Colors.black87,
              // Nền tối cho dialog
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              contentPadding: const EdgeInsets.all(16),
              title: _buildDialogTitle(detail, isNew),
              // Tiêu đề dialog
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hiển thị thông tin về hàng hóa
                  _buildProductInfoRow('Tồn kho', detail.product!.quantity),
                  _buildProductInfoRow(
                      'Giá vốn', detail.product!.capitalPrice),
                  _buildProductInfoRow('Giá trị hủy', totalCancelledValue),
                  const SizedBox(height: 20),
                  // Thành phần điều chỉnh số lượng đã kiểm
                  _buildQuantityAdjuster(
                      quantityController, detail, updateCancelledQuantity),
                  const SizedBox(height: 20),
                  // Nút hành động (Thoát, Xong)
                  _buildDialogActions(context, detail, quantityController),
                ],
              ),
            );
          },
        ));
  }

// Tiêu đề của dialog, bao gồm tên hàng hóa và nút xóa
  Widget _buildDialogTitle(ExportCancellationReceiptDetail detail, bool isNew) {
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
              _showDeleteConfirmationDialog(detail); // Mở dialog xác nhận xóa
            },
          ),
      ],
    );
  }

// Hiển thị một hàng thông tin về sản phẩm (nhãn và giá trị)
  Widget _buildProductInfoRow(String label, dynamic value,
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

// Thành phần điều chỉnh số lượng kiểm (gồm giảm, nhập số, tăng)
// Thành phần điều chỉnh số lượng kiểm (gồm giảm, nhập số, tăng)
  Widget _buildQuantityAdjuster(
      TextEditingController controller,
      ExportCancellationReceiptDetail detail,
      void Function(int) updateCancelledQuantity) {
    final stockQuantity = detail.product!.quantity;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Số lượng', style: TextStyle(color: Colors.grey)), // Nhãn
        Row(
          children: [
            // Nút giảm số lượng
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: () {
                if (detail.cancelledQuantity > 1) {
                  updateCancelledQuantity(detail.cancelledQuantity.toInt() - 1);
                  controller.text = detail.cancelledQuantity.toString();
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
                  int? parsedValue = int.parse(value);
                  if (parsedValue >= 1) {
                    // Kiểm tra và giới hạn số lượng tối đa
                    if (parsedValue > stockQuantity) {
                      parsedValue = stockQuantity; // Giới hạn giá trị
                    }
                  } else{
                    parsedValue = 1;
                  }
                  String valueString = parsedValue.toString();
                  updateCancelledQuantity(parsedValue);
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
                if (detail.cancelledQuantity < stockQuantity) {
                  updateCancelledQuantity(detail.cancelledQuantity.toInt() + 1);
                  controller.text = detail.cancelledQuantity.toString();
                }
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
      ExportCancellationReceiptDetail detail,
      TextEditingController controller,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Nút Thoát
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('THOÁT', style: TextStyle(color: Colors.blue)),
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
              detail.cancelledQuantity =
                  int.parse(controller.text) ?? 1; // Cập nhật số lượng kiểm
              // Cập nhật detail trong receipt
              _controller.updateDetail(receipt!, detail);
            });
            Navigator.of(context).pop(); // Đóng dialog
          },
          child: const Text('XONG'),
        ),
      ],
    );
  }

// Dialog xác nhận xóa sản phẩm
  void _showDeleteConfirmationDialog(ExportCancellationReceiptDetail detail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Xóa mặt hàng này khỏi phiếu xuất hủy?',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa mặt hàng này khỏi phiếu xuất hủy không?',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          // Nút Hủy
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('HỦY', style: TextStyle(color: Colors.blue)),
          ),
          // Nút Xóa
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _controller.removeDetail(receipt!, detail); // Xóa sản phẩm
              });
              Navigator.of(context).pop(); // Đóng dialog
            },
            child: const Text('XÓA', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
