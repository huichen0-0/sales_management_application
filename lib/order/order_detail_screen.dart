import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../helper/helper.dart';
import '../receipt/receipt.dart';
import '/config/constants.dart';
import '../../../views/widgets/dialogs/confirmation_dialog.dart';
import 'order.dart';
import 'order_controller.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState(order);
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  //nhập hàng controller
  final OrderController _controller = OrderController();
  Order _order;
  _OrderDetailScreenState(this._order);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

        final createdAt = Helper.formatDateTime(_order.createdAt);
        final status = Helper.getStatusReceipt(_order.status);
        final totalOrderValue = Helper.formatCurrency(_order.totalAmount);

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
                    _order.customer!.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  subtitle: Text(
                    _order.customer!.phoneNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  onTap: () {
                    //đi tới trang xem kh chi tiết
                    context.push('${AppPath.customer}/${_order.customerId}', extra: _order.customer);
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _order.details.length,
                  itemBuilder: (context, index) {
                    final detail = _order.details[index];
                    return ListTile(
                      title: Text(detail.product!.name),
                      leading: const Icon(Icons.image, size: 30),
                      trailing: Text(
                        Helper.formatCurrency(detail.amount),
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
                    totalOrderValue,
                    '${_order.details.length} mặt hàng -'
                        ' Số lượng: ${Helper.formatCurrency(_order.totalQuantity)}'),
              ],
            ),
          ),
          bottomNavigationBar: _order.status == AppNum.one
              ? _buildBottomNavigationBar()
              : null,
        );
  }

  // hien thi appbar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(AppString.detailOrder),
      //chỉ cho chỉnh sửa phiếu tạm
      actions: _order.status == AppNum.one
          ? [
        ///nút sửa
        IconButton(
          onPressed: () {
            context.push('${AppPath.order}/${_order.id}/edit');
          },
          icon: const Icon(Icons.edit),
        ),
        ///nút xóa
        IconButton(
          onPressed: () {
            _handleCancelOrder();
          },
          icon: const Icon(Icons.delete),
        ),
      ]
          : null,
    );
  }

  Padding _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              final newInvoice = _controller.createInvoiceBasedOnOrder(_order);
              //tới trang thanh toán (tạo hóa đơn)
              context.push(AppPath.salePayment, extra: newInvoice)
                  .then((result) {
                    //trả về từ trang sale payment
                if (result != null && result is Receipt) {
                  //TODO: insert hóa đơn vào db, cập nhật order thành hoàn thành
                  _order.status = AppNum.two;
                  _controller.updateOrder(updatedItem: _order);
                  context.pop();
                }
              });
            },
            // TODO: xử lý nút
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text(AppString.pay),
          ),
          // ElevatedButton(
          //   onPressed: //đã trả hàng thì vô hiệu nút
          //   !_order.returned
          //       ? () async {
          //     context.push(AppPath.returnOrderAdd, extra: _order);
          //   }
          //       : null, // TODO: xử lý nút
          //   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          //   child: const Text(AppString.returnOrder),
          // ),
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

  // Widget _buildPaymentRow(Payment payment) {
  //   return ListTile(
  //     title: Text('Số tiền: ${Helper.formatCurrency(payment.amount)}'),
  //     subtitle:
  //     Text('Ngày thanh toán: ${Helper.formatDateTime(payment.createdAt)}'),
  //     trailing: Text(payment.method),
  //   );
  // }
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
  void _handleCancelOrder() {
    ConfirmationDialog.show(
      context: context,
      title: AppString.confirmCancelTitle,
      content: AppString.confirmCancelContent,
      onConfirm: () {
        final success = _controller.cancelOrder(_order);
        if (success) {
          context.pop();
          _showSnackBar(AppString.successCancel, Colors.green);
        } else {
          _showSnackBar(AppString.error, Colors.red);
        }
      },
    );
  }
}
