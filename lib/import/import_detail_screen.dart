import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/config/constants.dart';
import '../payment/payment.dart';
import '../../../views/widgets/dialogs/confirmation_dialog.dart';
import '../helper/helper.dart';
import '../receipt/receipt.dart';
import 'import_controller.dart';
import 'import_receipt.dart';

class ImportDetailScreen extends StatefulWidget {
  final String id;
  final ImportReceipt? receipt;

  const ImportDetailScreen({super.key, required this.receipt, required this.id});

  @override
  State<ImportDetailScreen> createState() => _ImportDetailScreenState(this.receipt);
}

class _ImportDetailScreenState extends State<ImportDetailScreen> {
  //nhập hàng controller
  final ImportController _controller = ImportController();

  //dữ liệu lấy từ db
  late Future<ImportReceipt?> _receiptFuture;

  late ImportReceipt? _receipt;

  _ImportDetailScreenState(this._receipt);

  @override
  void initState() {
    super.initState();
    // _receiptFuture = _controller.getReceiptByIdAsync(widget.receiptId);
  }

  @override
  Widget build(BuildContext context) {

        return Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Colors.white,
          body: _receipt!.uid == '' ?
          FutureBuilder<ImportReceipt>(
            future: _controller.getReceiptById(widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data != null) {
                _receipt = snapshot.data!;
              }
              return buildBody();
            },
          ) : buildBody(),
          bottomNavigationBar: _receipt!.status == AppNum.two
              ? _buildBottomNavigationBar(_receipt!)
              : null,
        );
      // };
    // );
  }

  Widget buildBody() {
    final createdAt = Helper.formatDateTime(_receipt!.createdAt);
    final status = Helper.getStatusReceipt(_receipt!.status);
    final totalImportValue = Helper.formatCurrency(_receipt!.totalImportValue);
    return
    SingleChildScrollView(
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
              _receipt!.supplier!.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            subtitle: Text(
              _receipt!.supplier!.phone,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14),
            ),
            onTap: () {
              //đi tới trang xem ncc chi tiết
              if (_receipt!.supplier!.isDeleted == true) {
                _showSnackBar('Thông tin nhà cung cấp đã bị xóa', Colors.red);
              } else {
                context.push('${AppPath.supplier}/${_receipt!.partnerId}',
                    extra: [_receipt!.partnerId, _receipt!.supplier!.toJson()])
                    .then((result) {
                      setState(() {
                        _receipt?.supplier?.isDeleted = true;
                      });
                });
              }
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _receipt!.details.length,
            itemBuilder: (context, index) {
              final detail = _receipt!.details[index];
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
          _buildSummaryRow(
              AppString.totalImportAmount,
              totalImportValue,
              '${_receipt!.details.length} mặt hàng -'
                  ' Số lượng: ${Helper.formatCurrency(_receipt!.totalQuantity)}'),
          //Phiếu đã hoàn thành mới hiện lịch sử thanh toán
          if(_receipt!.status == AppNum.two) ExpansionTile(
            title: Text(
              '${AppString.amountPaid}: ${Helper.formatCurrency(_receipt!.amountPaid)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              for (var payment in _receipt!.payments)
                _buildPaymentRow(payment),
            ],
          ),
          if(_receipt!.status == AppNum.two) _buildSummaryRow(AppString.amountDue,
              Helper.formatCurrency(_receipt!.importDue)),
        ],
      ),
    );
  }

  // hien thi appbar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppString.detailImportReceipt, style: TextStyle(color: Colors.white)),
      //chỉ cho chỉnh sửa phiếu tạm
      actions: _receipt!.status == 1
          ? [
              ///nút sửa
              IconButton(
                onPressed: () {
                  // context.push('${AppPath.import}/${widget.receiptId}/edit');
                  context.push('${AppPath.import}/${_receipt!.id}/edit', extra: [_receipt!.partnerId, _receipt!]);
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

  Padding _buildBottomNavigationBar(ImportReceipt receipt) {
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
                        .push(AppPath.payment, extra: receipt)
                        .then((result) {
                      if (result != null && result is ImportReceipt) {
                        //TODO: insert hóa đơn nhập vào db
                        _controller.saveReceipt(result);
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
                    ? () async {
                        context.push(AppPath.returnImportAdd, extra: receipt)
                        .then((result) {
                          if (result != null && result is bool && result == true) {
                            receipt.returned = true;
                            _controller.saveReceipt(receipt);
                          }
                        });
                      }
                    : null, // TODO: xử lý nút
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text(AppString.returnImport),
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
      trailing: Text(payment.method),
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
        final success = _controller.cancelReceipt(_receipt!);
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
