import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///field + bottom sheet hiển thị chọn khoảng thời gian
class DateRangePickerField extends StatefulWidget {
  const DateRangePickerField({super.key});

  @override
  State<DateRangePickerField> createState() => _DateRangePickerFieldState();
}

class _DateRangePickerFieldState extends State<DateRangePickerField> {
  ///
  DateTime? startDate;

  // Ngày bắt đầu
  DateTime? endDate;

  // Ngày kết thúc
  void _showDateRangePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tiêu đề "Thời gian"
                  const Text(
                    'Thời gian',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  // Các trường "Từ ngày" và "Đến ngày"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        // Từ ngày
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? picked =
                              await _selectDate(context, startDate);
                              if (picked != null) {
                                setModalState(() {
                                  startDate = picked;
                                });
                                setState(() {
                                  startDate = picked;
                                });
                              }
                            },
                            child: _buildDateField('Từ ngày', startDate),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Đến ngày
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? picked =
                              await _selectDate(context, endDate);
                              if (picked != null) {
                                setModalState(() {
                                  endDate = picked;
                                });
                                setState(() {
                                  endDate = picked;
                                });
                              }
                            },
                            child: _buildDateField('Đến ngày', endDate),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nút "Xong"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Đóng BottomSheet
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        // Đặt chiều rộng nút bằng toàn bộ chiều ngang
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Xong'),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Hàm chọn ngày từ DatePicker
  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    return picked;
  }

  // Hàm định dạng ngày thành chuỗi
  String _formatDate(DateTime? date) {
    if (date == null) return 'Chọn ngày';
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  // Hàm xây dựng trường ngày với nhãn và giá trị
  Widget _buildDateField(String label, DateTime? date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(_formatDate(date), style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDateRangePicker(context); // Gọi BottomSheet khi nhấn vào
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
            const SizedBox(width: 12),
            Text(
              startDate != null && endDate != null
                  ? '${_formatDate(startDate)} - ${_formatDate(endDate)}'
                  : 'Chọn khoảng thời gian',
              style: TextStyle(
                color: startDate == null && endDate == null
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////