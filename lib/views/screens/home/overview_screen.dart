import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/custom_sheet.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  String selectedOption =
      'Hôm nay, ${DateFormat('dd/MM/yyyy').format(DateTime.now())}';

  /// hàm gọi hiển thị tùy chọn lọc thời gian
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TimeFilterBottomSheet(
          onOptionSelected: (option, startDate, [endDate]) {
            String formattedDate = endDate != null
                ? '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}'
                : DateFormat('dd/MM/yyyy').format(startDate);
            setState(() {
              selectedOption = '$option, $formattedDate';
            });
          },
        );
      },
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {}, // TODO: xử lý nút thông báo
          ),
        ],
        title: const Text(
          'Nhóm 5',
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(22.0),
          child: TextButton.icon(
            onPressed: () => _showBottomSheet(context),
            label: Text(
              selectedOption,
              style: const TextStyle(color: Colors.yellowAccent),
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.yellowAccent,
            ),
            iconAlignment: IconAlignment.end,
          ),
        ),
      ),
      body: Card(
        color: Colors.white70,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStatistic('1 hóa đơn', '750', 'nghìn', Colors.blue),
                  buildStatistic('Lợi nhuận', '150', 'nghìn', Colors.green),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.receipt, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('1 phiếu trả hàng - 300 nghìn', style: TextStyle(color: Colors.black)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatistic(String title, String value, String unit, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.black)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            Text(unit, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ],
    );
  }

}
