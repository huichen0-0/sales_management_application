import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/inventory_check/inventory_controller.dart';
import '../helper/helper.dart';
import 'inventory_check_detail.dart';
import 'inventory_check_receipt.dart';

class InventoryDetailScreen extends StatefulWidget {
  final String id;
  final InventoryCheckReceipt receipt;

  const InventoryDetailScreen({super.key, required this.id, required this.receipt});

  @override
  State<InventoryDetailScreen> createState() => _InventoryDetailScreenState(id, receipt);
}

class _InventoryDetailScreenState extends State<InventoryDetailScreen> {

  String id;
  InventoryCheckReceipt receipt;
  final InventoryController _controller = InventoryController();
  _InventoryDetailScreenState(this.id, this.receipt);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InventoryCheckReceipt?>(
      future: _controller.getDetail(receipt),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Phiếu xuất hủy không tồn tại.'));
        }

        final receipt = snapshot.data!;
        final createdAt =
        Helper.formatDateTime(receipt.createdAt ?? DateTime.now());
        final status = Helper.getStatusReceipt(receipt.status!);

        return
          Scaffold(
            appBar: AppBar(
                title: const Text('Chi tiết phiếu kiểm kho'),
                actions: receipt.status == 1 ? [
                  ///nút sửa
                  IconButton(
                    onPressed: () {
                      context.push('/inventory/$id/edit', extra: [id, receipt]);
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
                ] : [ ]),
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
                        createdAt,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: status == 'Đã cân bằng'
                              ? Colors.green
                              : status == 'Phiếu tạm'
                              ? Colors.orange
                              : Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status,
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
                      rows: receipt.details
                          .map((detail) => _buildDataRow(detail))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tổng thực tế
                  _buildSummaryRow(
                    'Tổng thực tế',
                    Helper.formatCurrency(receipt.totalValueMatched),
                    '${receipt.details.length} mặt hàng -'
                        ' Số lượng: ${Helper.formatCurrency(
                        receipt.totalMatchedQuantity)}',
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow(
                    'Tổng lệch tăng',
                    Helper.formatCurrency(receipt.totalIncrements[0]),
                    '${receipt
                        .totalIncrements[1]} mặt hàng - Số lượng: ${Helper
                        .formatCurrency(
                        receipt.totalIncrements[2])}',
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow(
                    'Tổng lệch giảm',
                    Helper.formatCurrency(receipt.totalDecrements[0]),
                    '${receipt
                        .totalDecrements[1]} mặt hàng - Số lượng: ${Helper
                        .formatCurrency(
                        receipt.totalDecrements[2])}',
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow(
                    'Tổng chênh lệch',
                    Helper.formatCurrency(
                        receipt.totalDecrements[0] +
                            receipt.totalIncrements[0]),
                    '${receipt
                        .totalProductDiv} mặt hàng - Số lượng: ${Helper
                        .formatCurrency(
                        receipt.totalIncrements[2] +
                            receipt.totalDecrements[2])}',
                  ),
                ],
              ),
            ),
          );
      },
    );
  }

  DataRow _buildDataRow(InventoryCheckReceiptDetail detail) {
    return DataRow(
      cells: [
        DataCell(Text(detail.product!.name)),
        DataCell(Text(Helper.formatCurrency(detail.stockQuantity))),
        DataCell(Text(Helper.formatCurrency(detail.matchedQuantity))),
        DataCell(
          Text(
            Helper.formatCurrency(detail.quantityDifference),
            style: TextStyle(
              color: detail.quantityDifference > 0
                  ? Colors.green
                  : detail.quantityDifference < 0
                  ? Colors.red : Colors.black,
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
                context.pop(); // Đóng hộp thoại mà không thay đổi gì
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
                _controller.delete(receipt);
                context.go('/inventory');
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }
}
