import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/controllers/inventory_controller.dart';
import 'package:sales_management_application/models/inventory_check_receipt.dart';

class InventoryDetailScreen extends StatefulWidget {
  final int inventoryCheckReceiptId;

  const InventoryDetailScreen(
      {super.key, required this.inventoryCheckReceiptId});

  @override
  State<InventoryDetailScreen> createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends State<InventoryDetailScreen> {
  //kiểm kho controller
  final InventoryController _controller = InventoryController();

  //phiếu kiểm
  InventoryCheckReceipt? item;

  @override
  void initState() {
    super.initState();
    //phiếu kiểm kho
    item = _controller
        .getInventoryCheckReceiptById(widget.inventoryCheckReceiptId)!;
  }

  /// Hàm format số tiền
  String formatCurrency(num amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết phiếu kiểm kho'),
        actions: [
          ///nút sửa
          IconButton(
            onPressed: () {
              context.push('/inventory/${widget.inventoryCheckReceiptId}/edit');
            },
            icon: const Icon(Icons.edit),
          ),

          ///nút xóa
          IconButton(
            onPressed: () {
              _showDeleteDialog();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Mã phiếu và trạng thái
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(item!.createdAt),
                  style: const TextStyle(color: Colors.grey),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item!.getStatusLabel(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // Bảng dữ liệu
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Nếu cần cuộn ngang
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Mặt hàng',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Tồn kho',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Thực tế',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Lệch',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: [
                  for (var i in item!.products)
                    _buildDataRow(i.product.name!, i.stockQuantity,
                        i.matchedQuantity, i.quantityDifference)
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tổng thực tế
            _buildSummaryRow(
              'Tổng thực tế',
              formatCurrency(item!.totalValueMatched),
              '${item!.products.length} mặt hàng -'
                  ' Số lượng: ${formatCurrency(item!.totalMatchedQuantity)}',
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Tổng lệch tăng',
              formatCurrency(item!.totalIncrements[0]),
              '${item!.totalIncrements[1]} mặt hàng - Số lượng: ${formatCurrency(item!.totalIncrements[2])}',
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Tổng lệch giảm',
              formatCurrency(item!.totalDecrements[0]),
              '${item!.totalDecrements[1]} mặt hàng - Số lượng: ${formatCurrency(item!.totalDecrements[2])}',
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Tổng chênh lệch',
              formatCurrency(
                  item!.totalDecrements[0] + item!.totalIncrements[0]),
              '${item!.totalProductDiv} mặt hàng - Số lượng: ${formatCurrency(item!.totalIncrements[2] + item!.totalDecrements[2])}',
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(
      String itemName, num stock, num matched, num difference) {
    return DataRow(
      cells: [
        DataCell(Text(itemName)),
        DataCell(Text('$stock')),
        DataCell(Text('$matched')),
        DataCell(
          Text(
            '$difference',
            style: TextStyle(
              color: difference > 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String value, [String? subtitle]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
      ],
    );
  }

  /// Hàm hiển thị hộp thoại xác nhận xóa khách hàng
  void _showDeleteDialog() {
    // Hiển thị hộp thoại xác nhận
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                'Bạn chắc chắn muốn xóa phiếu kiểm kho này?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            /// Nút Hủy
            IconButton(
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 35,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Đóng hộp thoại mà không thay đổi gì
              },
            ),

            /// Nút Đồng ý
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.green,
                size: 35,
              ),
              onPressed: () {
                //TODO: thực hiện thao tác xóa
                context.pop();
                context.pop();
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }
}
