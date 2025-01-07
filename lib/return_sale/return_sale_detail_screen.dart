import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/invoice/invoice_controller.dart';
import 'package:sales_management_application/invoice/invoice_receipt.dart';
import 'package:sales_management_application/return_sale/return_sale_filter.dart';

import '../config/constants.dart';
import '../helper/helper.dart';
import '../payment/payment.dart';
import '../receipt/receipt.dart';
import '../views/widgets/dialogs/confirmation_dialog.dart';
import 'return_sale_controller.dart';
import 'return_sale_receipt.dart';


class ReturnInvoiceDetailScreen extends StatefulWidget {
  final String receiptId;
  const ReturnInvoiceDetailScreen({super.key, required this.receiptId});

  @override
  State<ReturnInvoiceDetailScreen> createState() =>
      _ReturnInvoiceDetailScreenState();
}

class _ReturnInvoiceDetailScreenState extends State<ReturnInvoiceDetailScreen> {
  //nhập hàng controller
  final ReturnInvoiceController returnInvoiceController = ReturnInvoiceController();
  late Future<ReturnInvoiceReceipt?> _receiptFuture;
  final invoiceController = InvoiceController();

  @override
  void initState() {
    super.initState();
    _receiptFuture = returnInvoiceController.getReceiptByIdAsync(widget.receiptId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReturnInvoiceReceipt?>(
      future: _receiptFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text(AppString.errorNonExistentReceipt));
        }

        var receipt = snapshot.data!;
        final createdAt = Helper.formatDateTime(receipt.createdAt);
        final status = Helper.getStatusReceipt(receipt.status);
        final totalReturnInvoiceValue =
        Helper.formatCurrency(receipt.totalSaleValue);

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppString.detailReturnInvoice),
            //chỉ cho chỉnh sửa phiếu tạm
            actions: receipt.status == AppNum.one
                ? [
              ///nút sửa
              IconButton(
                onPressed: () {
                  context.push('${AppPath.returnInvoice}/${widget.receiptId}/edit', extra: receipt)
                  .then((result) {
                    if (result != null && result is ReturnInvoiceReceipt) {
                      setState(() {
                        receipt = result;
                      });
                    }
                  });
                  ;
                },
                icon: const Icon(Icons.edit),
              ),

              ///nút xóa
              IconButton(
                onPressed: () {
                  _handleCancelReceipt(receipt);
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
                    receipt.partnerId != '' ?  receipt.customer!.name : AppString.retailCustomer,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  subtitle: receipt.partnerId != '' ? Text(
                    receipt.customer!.phoneNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ) : null,
                  onTap: () {
                    //đi tới trang xem KH chi tiết
                    if (receipt.customer!.status == 3) {
                      _showSnackBar('Thông tin khách hàng đã bị xóa', Colors.red);
                    } else if (receipt.partnerId != '') {
                      context.push('${AppPath.customer}/${receipt.partnerId}', extra: receipt.customer);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.receipt),
                  title: const Text(
                    AppString.invoice,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                     context.push('${AppPath.invoice}/${receipt.invoiceReceiptId}', extra: InvoiceReceipt.empty());
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
                        Helper.formatCurrency(detail.saleValue),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '${Helper.formatCurrency(detail.product!.sellingPrice)}'
                              ' x${Helper.formatCurrency(detail.quantity)} ${detail.product!.unit}'),
                      onTap: null,
                    );
                  },
                ),
                // Bảng dữ liệu
                _buildSummaryRow(
                    AppString.totalReturnAmount,
                    totalReturnInvoiceValue,
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
                    Helper.formatCurrency(receipt.saleDue)),
              ],
            ),
          ),
        );
      },
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
  void _handleCancelReceipt(ReturnInvoiceReceipt receipt) {
    ConfirmationDialog.show(
      context: context,
      title: AppString.confirmCancelTitle,
      content: AppString.confirmCancelContent,
      onConfirm: () {
        final success = returnInvoiceController.cancelReceipt(widget.receiptId);
        if (success) {
          invoiceController.updateReceiptReturned(receipt.invoiceReceiptId, false);
          Navigator.of(context).pop();
          _showSnackBar(AppString.successCancel, Colors.green);
        } else {
          _showSnackBar(AppString.error, Colors.red);
        }
      },
    );
  }
}
