import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/views/widgets/search_bars/search_product.dart';
import 'package:sales_management_application/xuathuy/controllers/ec_controller.dart';
import 'package:sales_management_application/xuathuy/models/ec_receipt.dart';
import 'package:sales_management_application/xuathuy/models/ec_receipt_detail.dart';
import 'package:sales_management_application/xuathuy/views/helper/helper.dart';

class UpdateExportCancellationScreen extends StatefulWidget {
  final ExportCancellationReceipt?
      existingReceipt; // Tham số cho phiếu xuất hủy hiện có

  const UpdateExportCancellationScreen({super.key, this.existingReceipt});

  @override
  State<UpdateExportCancellationScreen> createState() =>
      _UpdateExportCancellationScreenState();
}

class _UpdateExportCancellationScreenState
    extends State<UpdateExportCancellationScreen> {
  //phiếu xuất hủy
  ExportCancellationReceipt receipt = ExportCancellationReceipt();

  //xuất hủy controller
  final ExportCancellationController _controller =
      ExportCancellationController();

  @override
  void initState() {
    super.initState();
    // Nếu đang cập nhật phiếu xuất hủy, gán dữ liệu vào `receipt`
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
            ? 'Tạo phiếu xuất hủy'
            : 'Cập nhật phiếu xuất hủy'),
      ),
      body: SingleChildScrollView(
        child: ProductSearchBar(
          onProductTap: (product) {
            //kiểm tra hàng hóa đã trong phiếu kiểm chưa
            if (_controller.existDetail(receipt, product.id!)) {
              // rồi sẽ lấy ra tiếp tục kiểm
              final detail =
                  _controller.getDetailByProductId(receipt, product.id!);
              _showReceiptDetailDialog(detail, false);
            } else {
              //chưa sẽ tạo hàng kiểm mới
              final detail = ExportCancellationReceiptDetail(
                  product: product, cancelledQuantity: 1);
              _showReceiptDetailDialog(detail, true);
            }
          },
          backgroundWidget: receipt.products.isNotEmpty
              ? _buildTableView()
              : _buildEmptyView(),
        ),
      ),
      bottomNavigationBar: receipt.products.isNotEmpty ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                receipt.status = 0;
                _controller.updateReceipt(updatedItem: receipt);
                context.pop(true);
              }, // TODO: xử lý nút
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Lưu tạm'),
            ),
            ElevatedButton(
              onPressed: () {
                receipt.status = 3;
                _controller.updateReceipt(updatedItem: receipt);
                context.pop(true);
              }, // TODO: xử lý nút
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Hoàn thành'),
            ),
          ],
        ),
      ) : null,
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
                  '${receipt.products.length} mặt hàng',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(
                Text(
                  Helper.formatCurrency(receipt.totalCancelledQuantity),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(
                Text(
                  Helper.formatCurrency(receipt.totalCancelledValue),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          for (var item in receipt.products) _buildDataRow(item),
        ],
      ),
    );
  }

  DataRow _buildDataRow(ExportCancellationReceiptDetail item) {
    return DataRow(
      cells: [
        DataCell(Text(item.product.name!)),
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

    // Hàm cập nhật số lượng đã kiểm
    void updateCancelledQuantity(num newValue) {
      setState(() {
        detail.cancelledQuantity = newValue;
        quantityController.text = newValue.toString();
      });
    }

    // Hiển thị dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        // Nền tối cho dialog
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(16),
        title: _buildDialogTitle(detail, isNew),
        // Tiêu đề dialog
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hiển thị thông tin về hàng hóa
            _buildProductInfoRow('Tồn kho', detail.product.quantity),
            _buildProductInfoRow('Giá vốn', detail.product.capitalPrice),
            _buildProductInfoRow('Giá trị hủy', detail.cancelledValue),
            const SizedBox(height: 20),
            // Thành phần điều chỉnh số lượng đã kiểm
            _buildQuantityAdjuster(
                quantityController, detail, updateCancelledQuantity),
            const SizedBox(height: 20),
            // Nút hành động (Thoát, Xong)
            _buildDialogActions(context, detail, quantityController),
          ],
        ),
      ),
    );
  }

// Tiêu đề của dialog, bao gồm tên hàng hóa và nút xóa
  Widget _buildDialogTitle(ExportCancellationReceiptDetail detail, bool isNew) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          child: Text(
            detail.product.name![0].toUpperCase(),
            // Chữ cái đầu tên sản phẩm
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        // Tên sản phẩm
        Expanded(
          child: Text(
            detail.product.name!,
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
  Widget _buildQuantityAdjuster(
      TextEditingController controller,
      ExportCancellationReceiptDetail detail,
      void Function(num) updateCancelledQuantity) {
    final stockQuantity = detail.product.quantity!;
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
                  num? parsedValue = num.tryParse(value);
                  if (parsedValue != null && parsedValue >= 1) {
                    // Kiểm tra và giới hạn số lượng tối đa
                    if (parsedValue > stockQuantity) {
                      parsedValue = stockQuantity; // Giới hạn giá trị
                      controller.text =
                          parsedValue.toString(); // Cập nhật lại UI
                    }
                    updateCancelledQuantity(parsedValue);
                  }
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
                  num.tryParse(controller.text) ?? 1; // Cập nhật số lượng kiểm
              _controller.updateDetail(receipt, detail);
              // Cập nhật detail trong receipt
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
                receipt.products.remove(detail); // Xóa sản phẩm
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
