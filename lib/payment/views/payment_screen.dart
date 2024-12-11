import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_management_application/payment/model/payment.dart';
import 'package:sales_management_application/views/helper/helper.dart';
import 'package:sales_management_application/views/widgets/thousands_formatter.dart';
import '../../models/receipt.dart';

class PaymentScreen extends StatefulWidget {
  final Receipt receipt;
  final void Function(Receipt receipt) onSubmit;

  const PaymentScreen(
      {super.key, required this.receipt, required this.onSubmit});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'Tiền mặt';
  num _amountPaid = 0;
  final _paymentMethods = Helper.paymentMethod;
  Payment payment = Payment.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Phương thức thanh toán:',
                style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _paymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  _paymentMethod = newValue!;
                });
              },
              items:
                  _paymentMethods.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Thông tin hóa đơn:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Tổng cộng số lượng: ${widget.receipt.totalQuantity}',
                style: const TextStyle(fontSize: 16)),
            Text('Tổng cộng số tiền: ${widget.receipt.totalValue} VND',
                style: const TextStyle(fontSize: 16)),
            Text('Đã trả: ${widget.receipt.amountPaid} VND',
                style: const TextStyle(fontSize: 16)),
            Text('Cần trả: ${widget.receipt.amountDue} VND',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tiền trả',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsFormatter(),
              ],
              onChanged: (value) {
                setState(() {
                  _amountPaid = num.tryParse(value) ?? 0;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.receipt.details.isNotEmpty
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if(widget.receipt.status != 3)
                  ElevatedButton(
                    // nếu phiếu đã hoàn thành rồi k có nut lưu tam nưữa
                    onPressed:
                        () {
                      payment.createdAt = DateTime.now();
                      payment.method = _paymentMethod;
                      payment.amount = _amountPaid;
                      widget.receipt.status = 1;
                      widget.receipt.payments.add(payment);
                      widget.onSubmit(widget.receipt);
                    }, // TODO: xử lý nút
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Lưu tạm'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      payment.createdAt = DateTime.now();
                      payment.method = _paymentMethod;
                      payment.amount = _amountPaid;
                      widget.receipt.status = 3;
                        widget.receipt.payments.add(payment);
                        widget.onSubmit(widget.receipt);
                    }, // TODO: xử lý nút
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Hoàn thành'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
