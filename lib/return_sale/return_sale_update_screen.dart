import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/invoice/invoice_controller.dart';
import '../helper/helper.dart';
import '../products/product_controller.dart';
import '../receipt/receipt.dart';
import '/config/constants.dart';
import 'return_sale_controller.dart';
import 'return_sale_receipt.dart';


class UpdateReturnInvoiceScreen extends StatefulWidget {
  final ReturnInvoiceReceipt receipt;

  const UpdateReturnInvoiceScreen({
    super.key,
    required this.receipt,
  });

  @override
  State<UpdateReturnInvoiceScreen> createState() =>
      _UpdateReturnInvoiceScreenState();
}

class _UpdateReturnInvoiceScreenState extends State<UpdateReturnInvoiceScreen> {
  late ReturnInvoiceReceipt _receipt;
  final ReturnInvoiceController returnInvoiceController = ReturnInvoiceController();
  final InvoiceController invoiceController = InvoiceController();
  ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();
    _receipt = widget.receipt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Màu nền tối
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(_receipt.id == ''
            ? AppString.createReturnInvoice
            : AppString.updateReturnInvoice),
      ),
      body: Column(
        children: [
          // Thông tin chung về phiếu trả hàng
          Container(
            padding: const EdgeInsets.all(16.0),
            child:  ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                _receipt.partnerId != '' ?  _receipt.customer!.name : AppString.retailCustomer,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              subtitle: _receipt.partnerId != '' ? Text(
                _receipt.customer!.phoneNumber,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14),
              ) : null,
              onTap: () {
                //đi tới trang xem KH chi tiết
                if(_receipt.partnerId != '')
                  context.push('${AppPath.customer}/${_receipt.partnerId}', extra: _receipt.customer);
              },
            ),
          ),
          // Danh sách hàng hóa
          Expanded(
            child: ListView.builder(
              itemCount: _receipt.details.length,
              itemBuilder: (context, index) {
                final detail = _receipt.details[index];

                void incrementQuantity() {
                  setState(() {
                    // Tăng số lượng nếu chưa đạt tối đa
                    if (detail.quantity < detail.maxQuantity!) {
                      detail.quantity++;
                    }
                  });
                }

                void decrementQuantity() {
                  setState(() {
                    // Giảm số lượng nếu lớn hơn 0
                    if (detail.quantity > 0) {
                      detail.quantity--;
                    }
                  });
                }

                return Column(
                  children: [
                    Row(
                      children: [
                        /// Quantity and Name
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.product!.name,
                              ),
                              Text(
                                Helper.formatCurrency(detail.product!.sellingPrice),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        /// Price and Delete Label
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Helper.formatCurrency(detail.saleValue),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: decrementQuantity,
                                  icon: const Icon(Icons.remove),
                                  constraints: const BoxConstraints(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${detail.quantity} / ${detail.maxQuantity} ${detail.product!.unit}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: incrementQuantity,
                                  icon: const Icon(Icons.add),
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    const Divider(thickness: 0.1),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _receipt.details.isNotEmpty
          ? Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: ElevatedButton(
          onPressed: () {
            //kiểm tra số luơngj hàng trong phiêu phải > 0
            if (_receipt.totalQuantity > AppNum.zero) {
              // đến trang thanh toán
              context.push(AppPath.salePayment, extra: _receipt).then((result) {
                //thanh toan xong
                if (result != null && result is ReturnInvoiceReceipt) {
                  final receipt = result;
                  receipt.id = _receipt.id;
                  if(result.status == 2){
                    receipt.details.removeWhere((e) => e.quantity <= 0);
                    productController.addAmount(receipt);
                  }
                  invoiceController.updateReceiptReturned(receipt.invoiceReceiptId, true);
                  returnInvoiceController.saveReceipt(receipt);
                  context.pop(receipt);
                }
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(AppString.errorNoProduct),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: AppString.ok,
                    onPressed: () {},
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(AppString.pay),
        ),
      )
          : null,
    );
  }
}
