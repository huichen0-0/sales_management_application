import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/controllers/inventory_controller.dart';
import 'package:sales_management_application/models/inventory_check_receipt.dart';
import 'package:sales_management_application/models/inventory_check_receipt_detail.dart';
import 'package:sales_management_application/views/widgets/search_bars/search_product.dart';

class UpdateInventoryScreen extends StatefulWidget {
  final InventoryCheckReceipt?
      existingNote; // Tham số cho phiếu kiểm kho hiện có

  const UpdateInventoryScreen({super.key, this.existingNote});

  @override
  State<UpdateInventoryScreen> createState() => _UpdateInventoryScreenState();
}

class _UpdateInventoryScreenState extends State<UpdateInventoryScreen> {
  //phiếu kiểm kho
  InventoryCheckReceipt inventoryCheckReceipt = InventoryCheckReceipt();

  //kiểm kho controller
  final InventoryController _controller = InventoryController();

  @override
  void initState() {
    super.initState();
    // Nếu đang cập nhật phiếu kiểm kho, gán dữ liệu vào `inventoryCheckReceipt`
    if (widget.existingNote != null) {
      inventoryCheckReceipt = widget.existingNote!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.existingNote == null
            ? 'Tạo phiếu kiểm kho'
            : 'Cập nhật phiếu kiểm kho'),
      ),
      body: SingleChildScrollView(
        child: ProductSearchBar(
          onProductTap: (product) {
            InventoryCheckReceiptDetail inventoryCheckReceiptDetail;
            //kiểm tra hàng hóa đã trong phiếu kiểm chưa
            if (inventoryCheckReceipt.isInInventoryCheckReceipt(product)) {
              // rồi sẽ lấy ra tiếp tục kiểm
              inventoryCheckReceiptDetail = inventoryCheckReceipt
                  .getInventoryCheckReceiptDetailByProduct(product);
              _showInventoryCheckReceiptDetailDialog(
                  inventoryCheckReceiptDetail, false);
            } else {
              //chưa sẽ tạo hàng kiểm mới
              inventoryCheckReceiptDetail =
                  InventoryCheckReceiptDetail(product: product);
              _showInventoryCheckReceiptDetailDialog(
                  inventoryCheckReceiptDetail, true);
            }
          },
          backgroundWidget: inventoryCheckReceipt.products.isNotEmpty
              ? _buildTableView()
              : _buildEmptyView(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _controller.updateInventoryCheckReceipt(
                    newNote: inventoryCheckReceipt, status: 0);
                context.pop(true);
              }, // TODO: xử lý nút
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Lưu tạm'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _controller.updateInventoryCheckReceipt(
                    newNote: inventoryCheckReceipt, status: 1);
                context.pop(true);
              }, // TODO: xử lý nút
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Hoàn thành'),
            ),
          ],
        ),
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
          Text('Chưa có hàng hóa trong phiếu kiểm kho'),
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
              'Hàng kiểm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Tồn kho',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            numeric: true, // Đánh dấu cột là kiểu số
          ),
          DataColumn(
            label: Text(
              'Thực tế',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            numeric: true, // Đánh dấu cột là kiểu số
          ),
          DataColumn(
            label: Text(
              'Lệch',
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
                  '${inventoryCheckReceipt.products.length} mặt hàng',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${inventoryCheckReceipt.totalStockQuantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${inventoryCheckReceipt.totalMatchedQuantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${inventoryCheckReceipt.totalQuantityDifference}',
                  style: TextStyle(
                    color: inventoryCheckReceipt.totalQuantityDifference >= 0
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          for (var item in inventoryCheckReceipt.products) _buildDataRow(item),
        ],
      ),
    );
  }

  DataRow _buildDataRow(InventoryCheckReceiptDetail item) {
    return DataRow(
      cells: [
        DataCell(Text(item.product.name!)),
        DataCell(Text('${item.stockQuantity}')),
        DataCell(Text('${item.matchedQuantity}')),
        DataCell(
          Text(
            '${item.quantityDifference}',
            style: TextStyle(
              color: item.quantityDifference >= 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      // Thay thế onLongPress bằng onSelectChanged để xử lý khi nhấp vào hàng
      onSelectChanged: (selected) {
        if (selected != null && selected) {
          _showInventoryCheckReceiptDetailDialog(item, false);
        }
      },
    );
  }

  // Hàm hiển thị dialog chi tiết hàng hóa
  void _showInventoryCheckReceiptDetailDialog(
      InventoryCheckReceiptDetail inventoryCheckReceiptDetail, bool isNew) {
    // Controller cho TextField để nhập số lượng kiểm
    final quantityController = TextEditingController(
      text: inventoryCheckReceiptDetail.matchedQuantity.toString(),
    );

    // Hàm cập nhật số lượng đã kiểm
    void updateCheckedQuantity(int newValue) {
      setState(() {
        inventoryCheckReceiptDetail.matchedQuantity = newValue.toDouble();
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
        title: _buildDialogTitle(inventoryCheckReceiptDetail, isNew),
        // Tiêu đề dialog
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hiển thị thông tin về hàng hóa
            _buildProductInfoRow(
                'Tồn kho', inventoryCheckReceiptDetail.product.quantity),
            _buildProductInfoRow(
                'Đã kiểm', inventoryCheckReceiptDetail.matchedQuantity.toInt()),
            _buildProductInfoRow(
              'Chênh lệch',
              inventoryCheckReceiptDetail.quantityDifference,
              highlightColor: inventoryCheckReceiptDetail.quantityDifference < 0
                  ? Colors.red
                  : Colors.green,
            ),
            const SizedBox(height: 20),
            // Thành phần điều chỉnh số lượng đã kiểm
            _buildQuantityAdjuster(quantityController,
                inventoryCheckReceiptDetail, updateCheckedQuantity),
            const SizedBox(height: 20),
            // Nút hành động (Thoát, Xong)
            _buildDialogActions(context, inventoryCheckReceiptDetail, isNew,
                quantityController),
          ],
        ),
      ),
    );
  }

// Tiêu đề của dialog, bao gồm tên hàng hóa và nút xóa
  Widget _buildDialogTitle(
      InventoryCheckReceiptDetail inventoryCheckReceiptDetail, bool isNew) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          child: Text(
            inventoryCheckReceiptDetail.product.name![0].toUpperCase(),
            // Chữ cái đầu tên sản phẩm
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        // Tên sản phẩm
        Expanded(
          child: Text(
            inventoryCheckReceiptDetail.product.name!,
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
              _showDeleteConfirmationDialog(
                  inventoryCheckReceiptDetail); // Mở dialog xác nhận xóa
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
            '$value', // Giá trị
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
      InventoryCheckReceiptDetail inventoryCheckReceiptDetail,
      void Function(int) updateCheckedQuantity) {
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
                if (inventoryCheckReceiptDetail.matchedQuantity > 0) {
                  updateCheckedQuantity(
                      inventoryCheckReceiptDetail.matchedQuantity.toInt() - 1);
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
                  // Chỉ cho phép nhập số
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
                  int? parsedValue = int.tryParse(value);
                  if (parsedValue != null && parsedValue >= 0) {
                    updateCheckedQuantity(parsedValue);
                  }
                },
              ),
            ),
            // Nút tăng số lượng
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                updateCheckedQuantity(
                    inventoryCheckReceiptDetail.matchedQuantity.toInt() + 1);
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
    InventoryCheckReceiptDetail inventoryCheckReceiptDetail,
    bool isNew,
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
              inventoryCheckReceiptDetail.matchedQuantity =
                  double.tryParse(controller.text) ??
                      0.0; // Cập nhật số lượng kiểm
              if (isNew) {
                inventoryCheckReceipt.products
                    .add(inventoryCheckReceiptDetail); // Thêm mới
              } else {
                inventoryCheckReceipt.updateInventoryCheckReceiptDetail(
                    inventoryCheckReceiptDetail); // Cập nhật sản phẩm
              }
            });
            Navigator.of(context).pop(); // Đóng dialog
          },
          child: const Text('XONG'),
        ),
      ],
    );
  }

// Dialog xác nhận xóa sản phẩm
  void _showDeleteConfirmationDialog(
      InventoryCheckReceiptDetail inventoryCheckReceiptDetail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Xóa mặt hàng này khỏi phiếu kiểm?',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa mặt hàng này khỏi phiếu kiểm không?',
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
                inventoryCheckReceipt.products
                    .remove(inventoryCheckReceiptDetail); // Xóa sản phẩm
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
