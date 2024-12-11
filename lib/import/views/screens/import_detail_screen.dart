import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/receipt.dart';
import '../../../models/receipt_detail.dart';
import '../../../payment/model/payment.dart';
import '../../controllers/import_controller.dart';
import '../../models/import_receipt.dart';
import '/views/helper/helper.dart';

class ImportDetailScreen extends StatefulWidget {
  final String receiptId;

  const ImportDetailScreen({super.key, required this.receiptId});

  @override
  State<ImportDetailScreen> createState() => _ImportDetailScreenState();
}

class _ImportDetailScreenState extends State<ImportDetailScreen> {
  //nhập hàng controller
  final ImportController _controller = ImportController();
  late Future<ImportReceipt?> _receiptFuture;

  @override
  void initState() {
    super.initState();
    _receiptFuture = _controller.getReceiptByIdAsync(widget.receiptId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImportReceipt?>(
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
        final createdAt = Helper.formatDateTime(receipt.createdAt);
        final status = Helper.getStatusReceipt(receipt.status);
        final totalImportValue =
            Helper.formatCurrency(receipt.totalValue);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Chi tiết phiếu nhập hàng'),
            //chỉ cho chỉnh sửa phiếu tạm
            actions: receipt.status == 1
                ? [
                      ///nút sửa
                      IconButton(
                        onPressed: () {
                          context.push('/import/${widget.receiptId}/edit');
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
                  ]
                : null,
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
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(
                    receipt.supplier!.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  subtitle: Text(
                    receipt.supplier!.phone,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  onTap: () {
                    //đi tới trang xem ncc chi tiết
                    context.push('/suppliers/${receipt.partnerId}');
                  },
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
                          'Giá nhập',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Số lượng',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Tiền hàng',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: [
                      for (var detail in receipt.details) _buildDataRow(detail),
                    ],
                  ),
                ),
                _buildSummaryRow(
                    'Tổng tiền hàng',
                    totalImportValue,
                    '${receipt.details.length} mặt hàng -'
                        ' Số lượng: ${Helper.formatCurrency(receipt.totalQuantity)}'),
                ExpansionTile(
                  title: Text(
                    'Đã thanh toán: ${Helper.formatCurrency(receipt.amountPaid)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    for (var payment in receipt.payments)
                      _buildPaymentRow(payment),
                  ],
                ),
                _buildSummaryRow(
                    'Còn nợ', Helper.formatCurrency(receipt.amountDue)),
              ],
            ),
          ),
          bottomNavigationBar: receipt.status == 3
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //nợ thì mới ấn được
                      ElevatedButton(
                        onPressed: receipt.amountDue > 0
                            ?
                            () {
                              if (receipt.partnerId != '') {
                                context.push('/payment', extra: receipt).then((result) {
                                  if (result != null && result is Receipt) {
                                    //TODO: insert hóa đơn nhập vào db
                                    _controller.updateReceipt(updatedItem: receipt);
                                    context.pop();
                                  }
                                });
                              }
                        } : null,
                        // TODO: xử lý nút
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Text('Thanh toán nợ'),
                      ),
                      ElevatedButton(
                        onPressed: () async {}, // TODO: xử lý nút
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Text('Trả hàng nhập'),
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }

  DataRow _buildDataRow(ReceiptDetail detail) {
    final importPrice = Helper.formatCurrency(detail.product!.capitalPrice);
    final quantity = Helper.formatCurrency(detail.quantity);
    final unit = detail.product!.unit!;
    return DataRow(
      cells: [
        DataCell(Text(detail.product!.name)),
        DataCell(Text(importPrice)),
        DataCell(Text('$quantity $unit')),
        DataCell(Text(Helper.formatCurrency(detail.value))),
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

  Widget _buildPaymentRow(Payment payment) {
    return ListTile(
      title: Text('Số tiền: ${Helper.formatCurrency(payment.amount)}'),
      subtitle:
          Text('Ngày thanh toán: ${Helper.formatDateTime(payment.createdAt)}'),
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
                'Bạn chắc chắn muốn xóa phiếu nhập hàng này?',
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
