import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_management_application/views/widgets/thousands_formatter.dart';

/// /Phone number field/ ///
class PriceField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const PriceField({super.key, required this.controller, required this.label});

  ///giải phóng controller
  void dispose() {
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixText: '₫ ',
      ),
      // Sử dụng inputFormatters chỉ cho nhâp số và format hiển thị
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        ThousandsFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng không để trống';
        }
        return null;
      },
    );
  }
}
////////////////////////////////////////////////////////////////////////////////
