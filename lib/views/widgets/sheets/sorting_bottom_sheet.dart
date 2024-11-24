import 'package:flutter/material.dart';
import 'package:sales_management_application/config/constants.dart';

///bottom sheet của sắp xếp
//TODO: mới chỉ hiển thị, chưa áp dụng lên đối tượng
class SortingBottomSheet extends StatelessWidget {
  final String selectedSorting;
  final Function(String) onSelectSorting;

  // Các thuộc tính boolean với giá trị mặc định là true
  final bool? showNewest;
  final bool? showOldest;
  final bool? showAscendingValue;
  final bool? showDescendingValue;
  final bool? showAZ;
  final bool? showZA;


  const SortingBottomSheet({
    super.key,
    required this.selectedSorting,
    required this.onSelectSorting,
    this.showNewest = true,
    this.showOldest = true,
    this.showAscendingValue = true,
    this.showDescendingValue = true,
    this.showAZ = true,
    this.showZA = true,
  });

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
          // Hiển thị từng tùy chọn dựa trên giá trị boolean
          if (showNewest!)
            ListTile(
              title: const Text(AppSort.newest),
              trailing: selectedSorting == AppSort.newest
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                onSelectSorting(AppSort.newest);
                Navigator.pop(context);
              },
            ),
          if (showOldest!)
            ListTile(
              title: const Text(AppSort.oldest),
              trailing: selectedSorting == AppSort.oldest
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                onSelectSorting(AppSort.oldest);
                Navigator.pop(context);
              },
            ),
          if (showAscendingValue!)
            ListTile(
              title: const Text(AppSort.ascValue),
              trailing: selectedSorting == AppSort.ascValue
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                onSelectSorting(AppSort.ascValue);
                Navigator.pop(context);
              },
            ),
          if (showDescendingValue!)
            ListTile(
              title: const Text(AppSort.descValue),
              trailing: selectedSorting == AppSort.descValue
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                onSelectSorting(AppSort.descValue);
                Navigator.pop(context);
              },
            ),
          if (showAZ!)
            ListTile(
              title: const Text(AppSort.aZ),
              trailing: selectedSorting == AppSort.aZ
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                onSelectSorting(AppSort.aZ);
                Navigator.pop(context);
              },
            ),
          if (showZA!)
            ListTile(
              title: const Text(AppSort.zA),
              trailing: selectedSorting == AppSort.zA
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                onSelectSorting(AppSort.zA);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );

  }
}
////////////////////////////////////////////////////////////////////////////////
