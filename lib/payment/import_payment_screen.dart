import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/payment/payment_controller.dart';
import '../../return_import/model/return_import_receipt.dart';
import '../helper/helper.dart';
import '../import/import_receipt.dart';
import '../receipt/receipt.dart';
import '/config/constants.dart';
import '/views/widgets/thousands_formatter.dart';
import '../../views/widgets/dialogs/confirmation_dialog.dart';

class ImportPaymentScreen extends StatefulWidget {
  final Receipt receipt;
  final void Function(Receipt receipt) onSubmit;

  const ImportPaymentScreen({
    super.key,
    required this.receipt,
    required this.onSubmit,
  });

  @override
  ImportPaymentScreenState createState() => ImportPaymentScreenState();
}

class ImportPaymentScreenState extends State<ImportPaymentScreen> {
  late PaymentController _controller;
  final _paymentMethods = Helper.paymentMethods();
  final TextEditingController _amountController = TextEditingController();

  //tiền thừa
  num _excessAmount = 0;
  late final _receipt;

  //kiểm tra xem hóa đơn nhập k?
  late bool check;

  @override
  void initState() {
    super.initState();
    check = widget.receipt is ImportReceipt;
    check
        ? _receipt = widget.receipt as ImportReceipt
        : _receipt = widget.receipt as ReturnImportReceipt;

    _controller = PaymentController(receipt: _receipt);
    _amountController.text = Helper.formatCurrency(_receipt.importDue);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.pay)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSupplierInfo(context),
              const SizedBox(height: 10),
              // _buildSeeDetailsButton(),
              // const SizedBox(height: 10),
              _buildPaymentInfo(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
      _receipt.details.isNotEmpty ? _buildBottomNavigationBar() : null,
    );
  }

  Widget _buildSupplierInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: _receipt.supplier != null
          ? ListTile(
        leading: const Icon(Icons.person_outline),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_receipt.supplier!.name),
            Text(
              _receipt.supplier.phone,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        //đi tới trang xem kh chi tiết nếu không phải khách lẻ
        onTap: () => _receipt.supplier != null
            ? context.push('${AppPath.supplier}/${_receipt.partnerId}')
            : null,
      )
          : null,
    );
  }

  // Widget _buildSeeDetailsButton() {
  //   return InkWell(
  //     onTap: () {
  //       //TODO: navigate to order detail
  //       print('view order details');
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.all(10),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[200],
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: const Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text('Xem hàng trong đơn'),
  //           Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPaymentInfo() {
    _excessAmount = _controller.amountPaid - _receipt.importDue;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        children: [
          _buildPaymentMethod(),
          _buildRowInfo("Tổng tiền hàng",
              Helper.formatCurrency(_receipt.totalImportValue)),
          // _buildDiscountRow(),
          if(check) _buildRowInfo(
              "Đã trả NCC", Helper.formatCurrency(_receipt.amountPaid)),
          if(check) _buildRowInfo(
              "Cần trả NCC", Helper.formatCurrency(_receipt.importDue),
              color: Colors.blue),
          _buildPaymentRow(),
          if (_excessAmount > 0)
            _buildRowInfo("Tiền thừa", Helper.formatCurrency(_excessAmount),
                color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildPaymentRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(check ? "Thanh toán NCC" : 'NCC trả',
              style: const TextStyle(
                fontSize: 16,
              )),
          SizedBox(
            width: 100,
            child: TextField(
              controller: _amountController,
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.blue), // Thay đổi màu khi focus
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsFormatter(),
              ],
              onChanged: (value) {
                setState(() {
                  _controller.updateAmountPaid(value);
                });
              },
              enabled: check,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildDiscountRow() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         const Text("Giảm giá (%)",
  //             style: TextStyle(
  //               fontSize: 16,
  //             )),
  //         SizedBox(
  //           width: 60,
  //           child: TextField(
  //             controller: _discountController,
  //             textAlign: TextAlign.end,
  //             decoration: const InputDecoration(
  //               border: UnderlineInputBorder(),
  //               focusedBorder: UnderlineInputBorder(
  //                 borderSide:
  //                 BorderSide(color: Colors.blue), // Thay đổi màu khi focus
  //               ),
  //               suffix: Text("%"),
  //             ),
  //             keyboardType: TextInputType.number,
  //             inputFormatters: [
  //               FilteringTextInputFormatter.digitsOnly,
  //             ],
  //             onChanged: (value) {
  //               setState(() {
  //                 value.isEmpty
  //                     ? _discountController.text = '0'
  //                     : _discount = num.parse(value);
  //               });
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildRowInfo(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: color)),
          Text(value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(AppString.paymentMethod, style: TextStyle(fontSize: 16)),
          DropdownButton<String>(
            value: _controller.paymentMethod,
            onChanged: (newValue) {
              setState(() {
                _controller.updatePaymentMethod(newValue!);
              });
            },
            items: _paymentMethods.map((method) {
              return DropdownMenuItem(value: method, child: Text(method));
            }).toList(),
          ),
        ],
      ),
    );
  }

  //Hiển thị BottomNavigationBar
  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //status đã hoàn thành tức TH thanh toán nợ sẽ k hiển thị nút lưu tạm
          if (_receipt.status != AppNum.two)
            ElevatedButton(
              onPressed: () {
                _handleSaveTemporary();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(AppString.saveTemporary),
            ),
          ElevatedButton(
            onPressed: () {
              _handleCompletePayment();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text(AppString.complete),
          ),
        ],
      ),
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

  void _handleSaveTemporary() {
    ConfirmationDialog.show(
      context: context,
      title: AppString.confirmTemporaryTitle,
      content: AppString.confirmTemporaryContent,
      onConfirm: () {
        final success = _controller.saveTemporary();
        if (success) {
          widget.onSubmit(_controller.receipt);
          _showSnackBar(AppString.successTemporary, Colors.green);
        } else {
          _showSnackBar(AppString.errorInvalidAmount, Colors.red);
        }
      },
    );
  }

  void _handleCompletePayment() {
    ConfirmationDialog.show(
      context: context,
      title: AppString.confirmCompleteTitle,
      content: AppString.confirmCompleteContent,
      onConfirm: () {
        _controller.updateAmountPaid(_amountController.text);
        final success = _controller.completePayment();
        if (success) {
          widget.onSubmit(_controller.receipt);
          _showSnackBar(AppString.successComplete, Colors.green);
        } else {
          _showSnackBar(AppString.errorInvalidAmount, Colors.red);
        }
      },
    );
  }
}
