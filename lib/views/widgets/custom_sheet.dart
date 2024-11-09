import 'package:flutter/material.dart';

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
