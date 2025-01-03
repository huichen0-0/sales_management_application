
import 'package:flutter/material.dart';
import '../products/product_filter.dart';
import '../products/products_screen.dart';
import '../views/widgets/forms/ratio_field.dart';

/// hiển thị tùy chọn lọc cho trang /products
class FilterProductScreen extends StatefulWidget {
  ProductFilter filter = ProductFilter();
  FilterProductScreen(this.filter, {super.key});

  @override
  _FilterProductScreenState createState() => _FilterProductScreenState(filter);
}

class _FilterProductScreenState extends State<FilterProductScreen> {
  bool _isActive = true; // Trạng thái: Đang hoạt động
  bool _isInactive = true; // Trạng thái: Ngừng hoạt động
  String selectedStatus = ''; //trạng thái tôn kho
  ProductFilter filter = ProductFilter();
  final GlobalKey<RatioFieldState> _ratioFieldKey = GlobalKey<RatioFieldState>();

  _FilterProductScreenState(ProductFilter productFilter) {
    filter = productFilter;
    _isActive = productFilter.isActive;
    _isInactive = productFilter.isInactive;
    selectedStatus = productFilter.getStatus();
    // print(productFilter.isAvailable);
    // print(selectedStatus);
  }

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
              initialValue: selectedStatus,
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
      _isInactive = true;
    });
  }

  // Hàm để áp dụng bộ lọc
  void _applyFilters() {
    filter.isActive = _isActive;
    filter.isInactive = _isInactive;
    if (selectedStatus == 'Dưới định mức tồn') {
      filter.setStatus(true, false, false, false);
    }
    else if (selectedStatus == 'Vượt định mức tồn') {
      filter.setStatus(false, true, false, false);
    }
    else if (selectedStatus == 'Còn hàng') {
      filter.setStatus(false, false, false, true);
    }
    else if (selectedStatus == 'Hết hàng') {
      filter.setStatus(false, false, true, false);
    } else {
      filter.setStatus(false, false, false, false);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(filter),
      ),
    );
  }
}