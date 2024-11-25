import 'package:flutter/material.dart';

class RatioField extends StatefulWidget {
  final String title;
  final List<String> options; // Danh sách các tùy chọn
  final ValueChanged<String> onChanged;

  const RatioField({
    super.key,
    required this.title,
    required this.options,
    required this.onChanged,
  });

  @override
  RatioFieldState createState() => RatioFieldState();
}

class RatioFieldState extends State<RatioField> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    // Sử dụng giá trị đầu tiên trong options làm giá trị mặc định
    _selectedValue = widget.options.isNotEmpty ? widget.options.first : '';
  }

  // Hàm reset để đặt lại giá trị về giá trị đầu tiên trong danh sách options
  void reset() {
    setState(() {
      _selectedValue = widget.options.isNotEmpty ? widget.options.first : '';
      widget.onChanged(_selectedValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề cho tỷ lệ
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Tạo các lựa chọn tỷ lệ từ danh sách `options`
        ...widget.options.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _selectedValue,
            onChanged: (String? value) {
              setState(() {
                _selectedValue = value!;
                widget.onChanged(_selectedValue);
              });
            },
          );
        }),
      ],
    );
  }
}
