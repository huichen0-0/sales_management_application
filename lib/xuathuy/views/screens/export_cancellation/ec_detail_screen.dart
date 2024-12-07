import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/views/helper/helper.dart';
import 'package:sales_management_application/xuathuy/controllers/ec_controller.dart';
import 'package:sales_management_application/xuathuy/models/ec_receipt.dart';
import 'package:sales_management_application/xuathuy/models/ec_receipt_detail.dart';

class ExportCancellationDetailScreen extends StatefulWidget {
  final int receiptId;

  const ExportCancellationDetailScreen({super.key, required this.receiptId});

  @override
  State<ExportCancellationDetailScreen> createState() =>
      _ExportCancellationDetailScreenState();
}

class _ExportCancellationDetailScreenState
    extends State<ExportCancellationDetailScreen> {
  final ExportCancellationController _controller =
      ExportCancellationController();
  late Future<ExportCancellationReceipt?> _receiptFuture;

  @override
  void initState() {
    super.initState();
    _receiptFuture = _controller.getReceiptByIdAsync(widget.receiptId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExportCancellationReceipt?>(
      future: _receiptFuture,
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
        final totalValue = Helper.formatCurrency(receipt.totalCancelledValue);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Chi tiết phiếu xuất hủy'),
            actions: receipt.status != 0 ?  [
            
              IconButton(
                onPressed: _showDeleteDialog,
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                  onPressed: () => context
                      .push('/export_cancellation/${widget.receiptId}/edit'),
                  icon: const Icon(Icons.edit),
                ),
              
            ] : null
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      createdAt,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: status == 'Đã hoàn thành'
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
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                          label: Text('Mặt hàng',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Số lượng hủy',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Giá vốn',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Giá trị hủy',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: receipt.products
                        .map((detail) => _buildDataRow(detail))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSummaryRow('Tổng giá trị hủy', totalValue,
                    '${receipt.products.length} mặt hàng - Số lượng: ${receipt.totalCancelledQuantity}'),
              ],
            ),
          ),
        );
      },
    );
  }

  DataRow _buildDataRow(ExportCancellationReceiptDetail detail) {
    return DataRow(
      cells: [
        DataCell(Text(detail.product.name!)),
        DataCell(Text('${detail.cancelledQuantity}')),
        DataCell(Text(Helper.formatCurrency(detail.product.capitalPrice!))),
        DataCell(Text(Helper.formatCurrency(detail.cancelledValue))),
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
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content:
              const Text('Bạn có chắc chắn muốn hủy phiếu xuất hủy này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                // TODO: Thực hiện thao tác hủy phiếu (cập nhật status)
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child:
                  const Text('Đồng ý', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}
