import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/import/import_receipt.dart';
import 'package:sales_management_application/suppliers/supplier.dart';
import '../../../helper/helper.dart';
import '../../../payment/payment.dart';
import '../../../receipt/receipt.dart';
import '../../../views/widgets/dialogs/confirmation_dialog.dart';
import '../../controller/return_import_controller.dart';
import '../../model/return_import_receipt.dart';

class ReturnImportDetailScreen extends StatefulWidget {
  final ReturnImportReceipt receipt;

  ReturnImportDetailScreen({super.key, required this.receipt});

  @override
  State<ReturnImportDetailScreen> createState() =>
      _ReturnImportDetailScreenState(this.receipt);
}

class _ReturnImportDetailScreenState extends State<ReturnImportDetailScreen> {
  //nhập hàng controller
  final ReturnImportController _controller = ReturnImportController();
  ReturnImportReceipt receipt;
  _ReturnImportDetailScreenState(this.receipt);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        final createdAt = Helper.formatDateTime(receipt.createdAt);
        final status = Helper.getStatusReceipt(receipt.status);
        final totalReturnImportValue = Helper.formatCurrency(receipt.totalImportValue);

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppString.detailReturnImportReceipt),
            //chỉ cho chỉnh sửa phiếu tạm
            actions: receipt.status == AppNum.one
                ? [
                    ///nút sửa
                    IconButton(
                      onPressed: () {
                        context.push('${AppPath.returnImport}/${receipt.id}/edit', extra: [receipt.partnerId, receipt])
                        .then((result) {
                          if (result != null && result is ReturnImportReceipt) {
                            setState(() {
                              receipt = result;
                            });
                          }
                        });;
                      },
                      icon: const Icon(Icons.edit),
                    ),

                    ///nút xóa
                    IconButton(
                      onPressed: () {
                        _handleCancelReceipt();
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
                        color: status == AppString.completed
                            ? Colors.green
                            : status == AppString.temporary
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
                    context.push('${AppPath.supplier}/${receipt.partnerId}', extra: [receipt.partnerId, Supplier.empty().toJson()]);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.receipt),
                  title: const Text(
                    AppString.importReceipt,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    //đi tới trang xem phieu nhap chi tiết
                    context.push('${AppPath.import}/${receipt.importReceiptId}', extra: ImportReceipt.empty());
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: receipt.details.length,
                  itemBuilder: (context, index) {
                    final detail = receipt.details[index];
                    return ListTile(
                      title: Text(detail.product!.name),
                      leading: const Icon(Icons.image, size: 30),
                      trailing: Text(
                        Helper.formatCurrency(detail.capitalValue),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '${Helper.formatCurrency(detail.product!.capitalPrice)}'
                          ' x${Helper.formatCurrency(detail.quantity)} ${detail.product!.unit}'),
                      onTap: null,
                    );
                  },
                ),
                // Bảng dữ liệu
                _buildSummaryRow(
                    AppString.totalReturnAmount,
                    totalReturnImportValue,
                    '${receipt.details.length} mặt hàng -'
                        ' Số lượng: ${Helper.formatCurrency(receipt.totalQuantity)}'),
                //Phiếu đã hoàn thành mới hiện lịch sử thanh toán
                if(receipt.status == AppNum.two) ExpansionTile(
                  title: Text(
                    '${AppString.amountPaid}: ${Helper.formatCurrency(receipt.amountPaid)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    for (var payment in receipt.payments)
                      _buildPaymentRow(payment),
                  ],
                ),
                if(receipt.status == AppNum.two) _buildSummaryRow(AppString.amountDue,
                    Helper.formatCurrency(receipt.importDue)),
              ],
            ),
          ),
          // trạng thái phiếu hoàn thành mới hiển thị nút thanh toán nợ(nếu có)
          bottomNavigationBar: receipt.status == AppNum.two
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// nút thanh toán nợ
                      ElevatedButton(
                        onPressed: receipt.importDue > 0
                            ? () {
                                context
                                    .push(AppPath.salePayment, extra: receipt)
                                    .then((result) {
                                  if (result != null && result is Receipt) {
                                    //TODO: tạo phiếu mới vào db
                                    _controller.updateReceipt(
                                        updatedItem: receipt);
                                    context.pop();
                                  }
                                });
                              }
                            : null,
                        // TODO: xử lý nút
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Text(AppString.payOffDebt),
                      ),
                    ],
                  ),
                )
              : null,
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
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Hàm hiển thị hộp thoại xác nhận hủy phiếu
  void _handleCancelReceipt() {
    ConfirmationDialog.show(
      context: context,
      title: AppString.confirmCancelTitle,
      content: AppString.confirmCancelContent,
      onConfirm: () {
        final success = _controller.cancelReceipt(receipt);
        if (success) {
          Navigator.of(context).pop();
          _showSnackBar(AppString.successCancel, Colors.green);
        } else {
          _showSnackBar(AppString.error, Colors.red);
        }
      },
    );
  }
}
