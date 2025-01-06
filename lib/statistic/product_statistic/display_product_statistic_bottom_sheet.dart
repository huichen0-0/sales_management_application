import 'package:flutter/material.dart';
import 'package:sales_management_application/config/constants.dart';

class DisplayProductStatisticBottomSheet extends StatelessWidget {
  final String selectedDisplay;
  final Function(String) onSelectDisplay;

  const DisplayProductStatisticBottomSheet(
      {super.key,
      required this.selectedDisplay,
      required this.onSelectDisplay});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ConstrainedBox(
          // Sử dụng ConstrainedBox để giới hạn chiều cao
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                0.6, // Ví dụ: 60% chiều cao màn hình
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Hiển thị theo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                //đã bán
                ListTile(
                  title: const Text(AppString.totalSoldQuantity),
                  trailing: selectedDisplay == AppString.totalSoldQuantity
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    onSelectDisplay(AppString.totalSoldQuantity);
                    Navigator.pop(context);
                  },
                ),
                // đã nhap
                ListTile(
                  title: const Text(AppString.totalImportedQuantity),
                  trailing: selectedDisplay == AppString.totalImportedQuantity
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    onSelectDisplay(AppString.totalImportedQuantity);
                    Navigator.pop(context);
                  },
                ),
                //doanh thu
                ListTile(
                  title: const Text(AppString.totalRevenue),
                  trailing: selectedDisplay == AppString.totalRevenue
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    onSelectDisplay(AppString.totalRevenue);
                    Navigator.pop(context);
                  },
                ),
                //chi phi
                ListTile(
                  title: const Text(AppString.totalCost),
                  trailing: selectedDisplay == AppString.totalCost
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    onSelectDisplay(AppString.totalCost);
                    Navigator.pop(context);
                  },
                ),
                //loi nhuan
                ListTile(
                  title: const Text(AppString.totalProfit),
                  trailing: selectedDisplay == AppString.totalProfit
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    onSelectDisplay(AppString.totalProfit);
                    Navigator.pop(context);
                  },
                ),
                //ton kho
                ListTile(
                  title: const Text(AppString.currentInventoryQuantity),
                  trailing:
                      selectedDisplay == AppString.currentInventoryQuantity
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                  onTap: () {
                    onSelectDisplay(AppString.currentInventoryQuantity);
                    Navigator.pop(context);
                  },
                ),
                //gia tri kho
                ListTile(
                  title: const Text(AppString.currentInventoryValue),
                  trailing: selectedDisplay == AppString.currentInventoryValue
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    onSelectDisplay(AppString.currentInventoryValue);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
