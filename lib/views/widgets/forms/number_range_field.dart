import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_management_application/views/widgets/thousands_formatter.dart';

class NumberRangeField extends StatelessWidget {
  final String fromLabel;
  final String toLabel;
  final TextEditingController fromController;
  final TextEditingController toController;

  const NumberRangeField({
    super.key,
    required this.fromController,
    required this.toController, required this.fromLabel, required this.toLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: fromController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ThousandsFormatter(),],
            decoration: InputDecoration(
              labelText: fromLabel,
              border: const OutlineInputBorder(),
            ),
            // Validator kiểm tra giá trị
            validator: (value) {
              // Nếu không nhập giá trị, mặc định "Từ" là 0
              if (value == null || value.isEmpty) {
                value = '0';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: toController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ThousandsFormatter(),],
            decoration: InputDecoration(
              labelText: toLabel,
              border: const OutlineInputBorder(),
            ),
            // Validator kiểm tra giá trị
            validator: (value) {
              if (value == null || value.isEmpty) {
                  value = '999999999'; // để trống mặc định giá trị là 999999999
              }

              final num? toValue = num.tryParse(value);

              // Kiểm tra xem giá trị của "Từ" có tồn tại không và có hợp lệ không
              final num? fromValue = num.tryParse(fromController.text);
              if (fromValue != null && fromValue > toValue!) {
                return 'Phải lớn hơn giá trị nhỏ nhất';
              }

              return null;
            },
          ),
        ),
      ],
    );
  }
}
