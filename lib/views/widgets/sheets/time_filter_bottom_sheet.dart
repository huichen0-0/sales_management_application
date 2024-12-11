import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';

///bottom sheet cho lọc thời gian
//TODO: mới chỉ hiển thị+lấy thời gian, chưa áp dụng, chưa hoàn thành "tùy chỉnh"
//TODO: cần cấu hình hoặc thêm vào db các tuỳ chọn
typedef OptionSelectedCallback = void
    Function(String option, DateTime? startDate, [DateTime? endDate]);

class TimeFilterBottomSheet extends StatefulWidget {
  final OptionSelectedCallback onOptionSelected;
  final String? selectedOption; // Thêm thuộc tính selectedOption

  const TimeFilterBottomSheet({
    super.key,
    required this.onOptionSelected,
    this.selectedOption = AppTime.today, // Giá trị mặc định
  });

  @override
  State<TimeFilterBottomSheet> createState() => _TimeFilterBottomSheetState();
}

class _TimeFilterBottomSheetState extends State<TimeFilterBottomSheet> {
  // Hàm định dạng ngày thành chuỗi
  String _formatDate(DateTime? date) {
    if (date == null) return 'Chọn ngày';
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Lọc theo thời gian',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: const Text(AppTime.allTime),
            trailing: widget.selectedOption == AppTime.allTime
                ? const Icon(Icons.check, color: Colors.blue)
                : null, // Hiển thị dấu check nếu là mặc định
            onTap: () {
              // trả về null để xác định là lâý tất cả
              widget.onOptionSelected(AppTime.allTime, null, null);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppTime.today),
            trailing: widget.selectedOption == AppTime.today
                ? const Icon(Icons.check, color: Colors.blue)
                : null, // Hiển thị dấu check nếu là mặc định
            onTap: () {
              // Lấy thời gian hiện tại
              DateTime now = DateTime.now();
              // Tạo đối tượng DateTime cho đầu ngày hôm nay (00:00:00)
              DateTime today = DateTime(now.year, now.month, now.day);

              widget.onOptionSelected(AppTime.today, today, null);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppTime.yesterday),
            trailing: widget.selectedOption == AppTime.yesterday
                ? const Icon(Icons.check, color: Colors.blue)
                : null, // Hiển thị dấu check nếu là mặc định
            onTap: () {
              DateTime yesterday =
                  DateTime.now().subtract(const Duration(days: 1));
              DateTime startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
              // Tạo đối tượng DateTime cho cuối ngày hôm nay (23:59:59.999)
              DateTime endDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59, 999);
              widget.onOptionSelected(AppTime.yesterday, startDate, endDate);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppTime.last7Days),
            trailing: widget.selectedOption == AppTime.last7Days
                ? const Icon(Icons.check, color: Colors.blue)
                : null, // Hiển thị dấu check nếu là mặc định
            onTap: () {
              DateTime sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
              DateTime startDate = DateTime(sevenDaysAgo.year, sevenDaysAgo.month, sevenDaysAgo.day);
              widget.onOptionSelected(AppTime.last7Days, startDate, null);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppTime.thisMonth),
            trailing: widget.selectedOption == AppTime.thisMonth
                ? const Icon(Icons.check, color: Colors.blue)
                : null, // Hiển thị dấu check nếu là mặc định
            onTap: () {
              DateTime now = DateTime.now();
              DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
              widget.onOptionSelected(AppTime.thisMonth, firstDayOfMonth, null);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Tùy chỉnh'),
            onTap: () {
              // TODO: Cho chọn khoảng thời gian
              Navigator.pop(context);
              _showDateRangePicker();
            },
          ),
        ],
      ),
    );
  }

  void _showDateRangePicker() {
    DateTime? startDate;
    // Ngày bắt đầu
    DateTime? endDate;
    // Ngày kết thúc

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
                        if (startDate != null && endDate != null) {
                          DateTime now = DateTime.now();
                          endDate = DateTime(endDate!.year, endDate!.month, endDate!.day, now.hour, now.minute, now.second);
                          widget.onOptionSelected(
                              '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                              startDate,
                              endDate);
                        }
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
}

////////////////////////////////////////////////////////////////////////////////
