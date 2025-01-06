import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/constants.dart';
import '../helper/helper.dart';
import '../payment/payment.dart';
import '../receipt/receipt.dart';
import '../views/widgets/dialogs/confirmation_dialog.dart';
import 'invoice_controller.dart';
import 'invoice_receipt.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final String receiptId;
  InvoiceReceipt receipt;

  InvoiceDetailScreen(
      {super.key, required this.receiptId, required this.receipt});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState(receipt);
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  //nhập hàng controller
  final InvoiceController _controller = InvoiceController();

  //dữ liệu lấy từ db
  late Future<InvoiceReceipt?> _receiptFuture;

  InvoiceReceipt _receipt;

  _InvoiceDetailScreenState(this._receipt);

  @override
  void initState() {
    super.initState();
    // if (widget.receipt.id == '') {
    //   _receiptFuture = _controller.getReceiptByIdAsync(widget.receiptId);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return _receipt.uid == ''
        ? FutureBuilder<InvoiceReceipt?>(
            future: _controller.getReceiptByIdAsync(widget.receiptId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                    child: Text(AppString.errorNonExistentReceipt));
              }
              _receipt = snapshot.data!;
              if(_receipt.partnerId == '') {
                print(true);
              }
              return buildBody();
            },
          )
        : buildBody();
  }

  Widget buildBody() {
    final createdAt = Helper.formatDateTime(_receipt.createdAt);
    final status = Helper.getStatusReceipt(_receipt.status);
    final totalInvoiceValue = Helper.formatCurrency(_receipt.totalSaleValue);

    return Scaffold(
      appBar: _buildAppBar(),
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
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                _receipt.customer?.name ?? AppString.retailCustomer,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              subtitle: _receipt.customer != null
                  ? Text(
                      _receipt.customer!.phoneNumber,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    )
                  : null,
              onTap: () {
                //đi tới trang xem KH chi tiết
                if (_receipt.partnerId != '')
                  context.push('${AppPath.customer}/${_receipt.partnerId}', extra: _receipt.customer);
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _receipt.details.length,
              itemBuilder: (context, index) {
                final detail = _receipt.details[index];
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
            _buildSummaryRow(
                AppString.totalAmount,
                totalInvoiceValue,
                '${_receipt.details.length} mặt hàng -'
                ' Số lượng: ${Helper.formatCurrency(_receipt.totalQuantity)}'),
            //Phiếu đã hoàn thành mới hiện lịch sử thanh toán
            if (_receipt.status == AppNum.two)
              ExpansionTile(
                title: Text(
                  '${AppString.amountPaid}: ${Helper.formatCurrency(_receipt.amountPaid)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  for (var payment in _receipt.payments)
                    _buildPaymentRow(payment),
                ],
              ),
            if (_receipt.status == AppNum.two)
              _buildSummaryRow(
                  AppString.amountDue, Helper.formatCurrency(_receipt.saleDue)),
          ],
        ),
      ),
      bottomNavigationBar: _receipt.status == AppNum.two
          ? _buildBottomNavigationBar(_receipt)
          : null,
    );
  }

  // hien thi appbar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppString.detailInvoiceReceipt),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // context.go('/suppliers');
          context.pop();
        },
      ),
      //chỉ cho chỉnh sửa phiếu tạm
      actions: _receipt.status == 1
          ? [
              ///nút sửa
              IconButton(
                onPressed: () {
                  context.push('${AppPath.invoice}/${widget.receiptId}/edit', extra: _receipt);
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
    );
  }

  Padding _buildBottomNavigationBar(InvoiceReceipt receipt) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //nợ thì mới ấn được
          ElevatedButton(
            onPressed: receipt.importDue > 0
                ? () {
                    context
                        .push(AppPath.salePayment, extra: receipt)
                        .then((result) {
                      if (result != null && result is Receipt) {
                        //TODO: insert hóa đơn nhập vào db
                        // _controller.updateReceiptReturned(receipt);
                        context.pop();
                      }
                    });
                  }
                : null,
            // TODO: xử lý nút
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text(AppString.payOffDebt),
          ),
          ElevatedButton(
            onPressed: //đã trả hàng thì vô hiệu nút
                !receipt.returned
                    ? () {
                        context.push(AppPath.returnInvoiceAdd, extra: _receipt).then((result){
                          setState(() {
                            _receipt.returned = true;
                          });
                        });
                      }
                    : null, // TODO: xử lý nút
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text(AppString.returnInvoice),
          ),
        ],
      ),
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
        final success = _controller.cancelReceipt(_receipt.id);
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
