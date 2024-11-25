import 'package:flutter/material.dart';
import 'package:sales_management_application/views/widgets/forms/ratio_field.dart';

/// hiển thị tùy chọn lọc cho trang /products
/// TODO: cần xử lý áp dung
class FilterProductScreen extends StatefulWidget {
  const FilterProductScreen({super.key});

  @override
  _FilterProductScreenState createState() => _FilterProductScreenState();
}

class _FilterProductScreenState extends State<FilterProductScreen> {
  bool _isActive = true; // Trạng thái: Đang hoạt động
  bool _isInactive = false; // Trạng thái: Ngừng hoạt động
  late String selectedStatus; //trạng thái tôn kho
  // Sử dụng GlobalKey để tham chiếu đến trạng thái của RatioField
  final GlobalKey<RatioFieldState> _ratioFieldKey = GlobalKey<RatioFieldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bộ lọc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Tồn kho section
            RatioField(
              key: _ratioFieldKey, // Gán key cho RatioField
              title: 'Tồn kho',
              options: const [
                'Tất cả hàng hóa',
                'Dưới định mức tồn',
                'Vượt định mức tồn',
                'Còn hàng',
                'Hết hàng',
              ],
              onChanged: (value) {
                selectedStatus = value;
              },
            ),
            const SizedBox(height: 16),

            // Trạng thái
            _buildStatusSection(),
            const SizedBox(height: 16),
            // Nút "Đặt lại" và "Áp dụng"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _resetFilters();
                  },
                  child: const Text(
                    'Đặt lại',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                  },
                  child: const Text('Áp dụng'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  // Hàm tạo phần Trạng thái
  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('Đang kinh doanh'),
          value: _isActive,
          onChanged: (bool? value) {
            setState(() {
              _isActive = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Ngừng kinh doanh'),
          value: _isInactive,
          onChanged: (bool? value) {
            setState(() {
              _isInactive = value ?? false;
            });
          },
        ),
      ],
    );
  }


  // Hàm để đặt lại các bộ lọc
  void _resetFilters() {
    setState(() {
      // Gọi hàm reset của RatioField để đặt lại trạng thái
      _ratioFieldKey.currentState?.reset();
      _isActive = true;
      _isInactive = false;
    });
  }

  // Hàm để áp dụng bộ lọc
  void _applyFilters() {
    // TODO: Xử lý khi người dùng nhấn "Áp dụng"
    print('Filters applied');
  }
}