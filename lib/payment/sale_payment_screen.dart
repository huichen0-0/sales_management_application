import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/invoice/invoice_receipt.dart';
import 'package:sales_management_application/payment/payment_controller.dart';
import '../../return_sale/return_sale_receipt.dart';
import '../helper/helper.dart';
import '../receipt/receipt.dart';
import '/config/constants.dart';
import '/views/widgets/thousands_formatter.dart';
import '../../views/widgets/dialogs/confirmation_dialog.dart';

class SalePaymentScreen extends StatefulWidget {
  final Receipt receipt;
  final void Function(Receipt receipt) onSubmit;

  const SalePaymentScreen({
    super.key,
    required this.receipt,
    required this.onSubmit,
  });

  @override
  SalePaymentScreenState createState() => SalePaymentScreenState();
}

class SalePaymentScreenState extends State<SalePaymentScreen> {
  //payment controller
  late PaymentController _controller;

  //paymeny methods
  final _paymentMethods = Helper.paymentMethods();

  //text controller so tien thanh toan
  final TextEditingController _amountController = TextEditingController();

  //tien thừa
  num _excessAmount = 0;

  //hóa đơn
  late final _receipt;

  //kiểm tra loại hóa đơn
  late bool check;

  @override
  void initState() {
    super.initState();
    //kiểm tra phải hóa đơn bán hàng k?
    check = widget.receipt is InvoiceReceipt;
    check
        ? _receipt = widget.receipt as InvoiceReceipt
        : _receipt = widget.receipt as ReturnInvoiceReceipt;
    //khởi tạo payment controller
    _controller = PaymentController(receipt: _receipt);
    //gán giá trị còn nợ vào ô nhập
    _amountController.text = Helper.formatCurrency(_receipt.saleDue);
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
              _buildCustomerInfo(context),
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

  Widget _buildCustomerInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.person_outline),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_receipt.customer?.name ?? AppString.retailCustomer),
            if (_receipt.customer != null)
              Text(
                _receipt.customer.phoneNumber,
                style: TextStyle(color: Colors.grey[600]),
              ),
          ],
        ),
        //đi tới trang xem kh chi tiết nếu không phải khách lẻ
        onTap: () => _receipt.customer != null
            ? context.push('${AppPath.customer}/${_receipt.partnerId}')
            : null,
      ),
    );
  }

  Widget _buildPaymentInfo() {
    //tính tiền thừa
    if(_controller.amountPaid > _receipt.saleDue) {
      _excessAmount = _controller.amountPaid - _receipt.saleDue;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        children: [
          _buildPaymentMethod(),
          _buildRowInfo(
              "Tổng tiền hàng", Helper.formatCurrency(_receipt.totalSaleValue)),
          // _buildDiscountRow(),
          //hiển thị khách đã trả nếu là hóa đơn bán hàng
          if(check) _buildRowInfo(
              "Khách đã trả", Helper.formatCurrency(_receipt.amountPaid)),
          if(check) _buildRowInfo(
              "Khách cần trả",
              Helper.formatCurrency(_receipt.saleDue),
              color: Colors.blue),
          _buildPaymentRow(),
          if (_excessAmount > 0)
            _buildRowInfo(
                "Tiền thừa trả khách", Helper.formatCurrency(_excessAmount),
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
          Text(check ? "Khách thanh toán" : "Tiền trả khách",
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
              enabled: check, // Vô hiệu hóa TextField nếu trả hàng
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
  //                     BorderSide(color: Colors.blue), // Thay đổi màu khi focus
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
        final success = _controller.completePayment(_excessAmount);
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
