import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async'; // Để sử dụng Timer cho debounce

class SearchBarScreen extends StatefulWidget {
  final List<Map<String, String>>
  searchOptions; // ds chứa searchKey, tag và hint
  final List<Map<String, dynamic>>
  searchData; // dữ liệu tìm kiếm tùy chỉnh cho từng trang
  final VoidCallback onCancel; // hủy bỏ tìm kiếm
  final String title; // tiêu đề của trang
  final String dataType; // kiểu đối tượng vd: products, customers...

  const SearchBarScreen({
    super.key,
    required this.searchOptions,
    required this.searchData,
    required this.onCancel,
    required this.title,
    required this.dataType,
  });

  @override
  _SearchBarScreenState createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  // controller lấy input tìm kiếm
  final TextEditingController _textController = TextEditingController();
  // kết quả tìm kiếm
  List<Map<String, dynamic>> _searchResults = [];
  // tag hiện tại được chọn
  String? _selectedSearchKey;
  // text gợi ý hiện tại
  String? _currentHintText;
  // tag hiện tại
  String? _currentTag;
  // timer cho debounce
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Khởi tạo với tất cả dữ liệu ban đầu
    _searchResults = List.from(widget.searchData);
    // Nếu có searchOption ban đầu, chọn cái đầu tiên
    if (widget.searchOptions.isNotEmpty) {
      _selectedSearchKey = widget.searchOptions.first['searchKey'];
      _currentHintText = widget.searchOptions.first['hint'];
      _currentTag = widget.searchOptions.first['tag'];
    }
    // Thiết lập listener cho TextField
    _textController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  // hàm xử lý khi text trong ô tìm kiếm thay đổi (có debounce)
  void _onSearchTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _updateSearchResults(_textController.text);
    });
  }

  // hàm cập nhật kết quả tìm kiếm dựa trên từ khóa và tag
  void _updateSearchResults(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        _searchResults = List.from(widget.searchData);
      });
      return;
    }

    final String lowerSearchText = searchText.toLowerCase();
    setState(() {
      _searchResults = widget.searchData.where((item) {
        if (_selectedSearchKey != null) {
          final fieldValue = item[_selectedSearchKey]?.toString().toLowerCase() ?? '';
          return fieldValue.contains(lowerSearchText);
        }
        return false;
      }).toList();
    });
  }

  // hàm xử lý khi nhấn vào icon quét mã vạch
  void _onBarcodeScanPressed() {
    print('quét mã vạch');
    // todo: thêm mã quét mã vạch thực tế ở đây
  }

  // hàm cập nhật tag được chọn
  void _updateTag(Map<String, String> newTag) {
    _selectedSearchKey = newTag['searchKey'];
    _currentHintText = newTag['hint'];
    _currentTag = newTag['tag'];
  }

  @override
  Widget build(BuildContext context) {
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
            // thanh tìm kiếm
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: _currentHintText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0),
                      // thêm icon quét mã vạch nếu tag "hàng hóa" được chọn
                      suffixIcon: _currentTag == "Hàng hóa"
                          ? IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: _onBarcodeScanPressed,
                      )
                          : null,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text(
                    'hủy',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // danh sách tag
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.searchOptions.map((item) {
                // biến kiểm tra tag được chọn (key)
                final bool isSelected = _selectedSearchKey == item['searchKey'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!isSelected) {
                        // nếu chọn tag khác, cập nhật tag đã chọn và kết quả
                        _updateTag(item);
                        _updateSearchResults(_textController.text);
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

            // danh sách kết quả tìm kiếm
            Expanded(
              child: ListView.builder(
                // số lượng đối tượng
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  // lấy từng đối tượng theo thứ tự trong searchResults
                  final item = _searchResults[index];
                  // lấy id
                  final itemId = item['id'].toString();
                  // hiển thị ra
                  return ListTile(
                    // nội dung của thuộc tính đang tìm
                    title: Text(item[_selectedSearchKey ?? ''] ?? ''),
                    // xử lý khi chọn kết quả tìm kiếm
                    onTap: () {
                      if (widget.dataType == 'customers') {
                        context.push('/${widget.dataType}/$itemId',
                            extra: item); // Truyền trực tiếp Map
                      } else if (widget.dataType == 'products') {
                        context.push('/${widget.dataType}/$itemId',
                            extra: [item['id'], item]);
                      } else if (widget.dataType == 'suppliers') {
                        context.push('/${widget.dataType}/$itemId',
                            extra: item['id']);
                      }

                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}