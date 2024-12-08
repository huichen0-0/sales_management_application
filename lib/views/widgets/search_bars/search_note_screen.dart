import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/controllers/searching_controller.dart';

class SearchNoteScreen extends StatefulWidget {
  final List<Map<String, String>>
      searchOptions; // Danh sách chứa searchKey, tag và hint
  final List<Map<String, dynamic>>
      searchData; // Dữ liệu tìm kiếm tùy chỉnh cho từng trang
  final VoidCallback onCancel; //hủy
  final String title; //tiêu đề
  final String dataType; //kiểu đối tượng vd: products, customers...
  final Widget Function(Map<String, dynamic> item)
      itemBuilder; // Widget tùy chỉnh

  const SearchNoteScreen({
    super.key,
    required this.searchOptions,
    required this.searchData,
    required this.onCancel,
    required this.title,
    required this.dataType,
    required this.itemBuilder, // Thêm tham số itemBuilder
  });

  @override
  _SearchNoteScreenState createState() => _SearchNoteScreenState();
}

class _SearchNoteScreenState extends State<SearchNoteScreen> {
  //controller lấy input
  final TextEditingController _textController = TextEditingController();

  //controller tìm kiếm
  late SearchingController _searchingController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo SearchingController với dữ liệu đầu vào
    _searchingController = SearchingController(
      searchData: widget.searchData,
      searchOptions: widget.searchOptions,
    );

    // Đặt listener cho TextField để cập nhật kết quả tìm kiếm
    _textController.addListener(() {
      _searchingController.updateSearchResults(_textController.text);
      setState(() {}); // Cập nhật UI khi có thay đổi kết quả
    });
  }

  // Hàm xử lý khi nhấn vào icon quét mã vạch
  void _onBarcodeScanPressed() {
    print('Quét mã vạch');
    // TODO: Thêm mã quét mã vạch thực tế ở đây
  }
  // Hàm xử lý khi nhấn vào icon x
  void _onCancelIconPressed() {
    print('Đặt lại thanh tìm kiếm');
    _textController.clear();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    // Nhóm danh sách kết quả theo ngày
    final groupedItems = groupBy(_searchingController.searchResults, (item) {
      // Chuyển `DateTime` thành chuỗi định dạng ngày
      return DateFormat('yyyy/MM/dd').format(item['createdAt']);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Thanh tìm kiếm
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: _searchingController.currentHintText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      // Thêm icon quét mã vạch nếu tag "Hàng hóa" được chọn
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_textController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: _onCancelIconPressed,
                            ),
                          if (_searchingController.currentTag == "Hàng hóa")
                            IconButton(
                              icon: const Icon(Icons.qr_code_scanner),
                              onPressed: _onBarcodeScanPressed,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text(
                    'Huỷ',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Danh sách tags
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.searchOptions.map((item) {
                // Biến kiểm tra tag được chọn (key)
                final bool isSelected =
                    _searchingController.selectedSearchKey == item['searchKey'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!isSelected) {
                        // Nếu chọn tag khác, cập nhật tag đã chọn và kết quả
                        _searchingController.updateTag(item);
                        _searchingController
                            .updateSearchResults(_textController.text);
                      }
                    });
                  },
                  child: Chip(
                    label: Text(item['tag']!),
                    backgroundColor:
                        isSelected ? Colors.blue : Colors.grey[300],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Danh sách kết quả tìm kiếm
            Expanded(
              child: ListView(
                children: [
                  // Duyệt qua từng nhóm
                  for (var group in groupedItems.entries)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hiển thị ngày của nhóm
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            group.key,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Hiển thị danh sách các item trong nhóm
                        for (var item in group.value)
                          GestureDetector(
                            onTap: () {
                              //chuyển tới trang chi tiết
                              final itemId = item['id'].toString();
                              context.push('/${widget.dataType}/$itemId');
                            },
                            child: widget.itemBuilder(item),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
