import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///bottom sheet cho lọc thời gian
//TODO: mới chỉ hiển thị+lấy thời gian, chưa áp dụng, chưa hoàn thành "tùy chỉnh"
typedef OptionSelectedCallback = void
    Function(String option, DateTime startDate, [DateTime? endDate]);

class TimeFilterBottomSheet extends StatelessWidget {
  final OptionSelectedCallback onOptionSelected;

  const TimeFilterBottomSheet({super.key, required this.onOptionSelected});

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
            title: const Text('Hôm nay'),
            onTap: () {
              DateTime now = DateTime.now();
              onOptionSelected('Hôm nay', now);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Hôm qua'),
            onTap: () {
              DateTime yesterday =
                  DateTime.now().subtract(const Duration(days: 1));
              onOptionSelected('Hôm qua', yesterday);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('7 ngày qua'),
            onTap: () {
              DateTime now = DateTime.now();
              DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));
              onOptionSelected('7 ngày qua', sevenDaysAgo, now);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Tháng này'),
            onTap: () {
              DateTime now = DateTime.now();
              DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
              onOptionSelected('Tháng này', firstDayOfMonth, now);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Tùy chỉnh'),
            onTap: () {
              //TODO: cho chon khoang thoi gian
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

///bottom sheet của sắp xếp
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class SortingBottomSheet extends StatelessWidget {
  final String selectedSorting;
  final Function(String) onSelectSorting;

  const SortingBottomSheet(
      {super.key,
      required this.selectedSorting,
      required this.onSelectSorting});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Sắp xếp theo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: const Text('Mới nhất'),
            trailing: selectedSorting == 'Mới nhất'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSorting('Mới nhất');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Cũ nhất'),
            trailing: selectedSorting == 'Cũ nhất'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSorting('Cũ nhất');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Giá trị tăng'),
            trailing: selectedSorting == 'Giá trị tăng'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSorting('Giá trị tăng');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Giá trị giảm'),
            trailing: selectedSorting == 'Giá trị giảm'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSorting('Giá trị giảm');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('A-Z'),
            trailing: selectedSorting == 'A-Z'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSorting('A-Z');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Z-A'),
            trailing: selectedSorting == 'Z-A'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSorting('Z-A');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

///bottom sheet của hiển thị NCC theo ...
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class DisplaySupplierBottomSheet extends StatelessWidget {
  final String selectedDisplay;
  final Function(String) onSelectDisplay;

  const DisplaySupplierBottomSheet(
      {super.key,
      required this.selectedDisplay,
      required this.onSelectDisplay});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Tổng mua'),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay('Tổng mua');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Nợ cần trả NCC'),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay('Nợ cần trả NCC');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Tổng mua trừ tổng trả'),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay('Tổng mua trừ tổng trả');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

///bottom sheet của hiển thị khach hang theo ...
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class DisplayCustomerBottomSheet extends StatelessWidget {
  final String selectedDisplay;
  final Function(String) onSelectDisplay;

  const DisplayCustomerBottomSheet(
      {super.key,
      required this.selectedDisplay,
      required this.onSelectDisplay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Tổng bán'),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay('Tổng bán');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Nợ cần thu'),
            trailing: const Text('0'), //TODO: cần lấy giá trị từ db
            onTap: () {
              onSelectDisplay('Nợ cần thu');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

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
                  // Thanh kéo
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

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

///bottom sheet của giới tính
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class SexBottomSheet extends StatelessWidget {
  final String selectedSex;
  final Function(String) onSelectSex;

  const SexBottomSheet(
      {super.key,
        required this.selectedSex,
        required this.onSelectSex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Giới tính',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: const Text('Nam'),
            trailing: selectedSex == 'Nam'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSex('Nam');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Nữ'),
            trailing: selectedSex == 'Nữ'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSex('Nữ');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Khác'),
            trailing: selectedSex == 'Khác'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              onSelectSex('Khác');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}