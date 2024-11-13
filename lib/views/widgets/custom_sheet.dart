import 'package:flutter/material.dart';

///bottom sheet cho lọc thời gian
//TODO: mới chỉ hiển thị+lấy thời gian, chưa áp dụng, chưa hoàn thành "tùy chỉnh"
typedef OptionSelectedCallback = void
    Function(String option, DateTime startDate, [DateTime? endDate]);

class TimeFilterBottomSheet extends StatelessWidget {
  final OptionSelectedCallback onOptionSelected;

  const TimeFilterBottomSheet({super.key, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
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
          onTap: () { //TODO: cho chon khoang thoi gian
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

///bottom sheet của sắp xếp
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class SortingBottomSheet extends StatelessWidget {
  final String selectedSorting;
  final Function(String) onSelectSorting;

  SortingBottomSheet({required this.selectedSorting, required this.onSelectSorting});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
        ],
      ),
    );
  }
}

///bottom sheet của hiển thị NCC
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class DisplaySupplierBottomSheet extends StatelessWidget {
  final String selectedDisplay;
  final Function(String) onSelectDisplay;

  DisplaySupplierBottomSheet({required this.selectedDisplay, required this.onSelectDisplay});

  @override
  Widget build(BuildContext context) {
    return Container(
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

