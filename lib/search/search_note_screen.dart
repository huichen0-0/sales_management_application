import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Để sử dụng Timer cho debounce

class SearchNoteScreen extends StatefulWidget {
  final List<Map<String, String>> searchOptions; // ds chứa searchKey, tag và hint
  final List<Map<String, dynamic>> searchData; // dữ liệu tìm kiếm tùy chỉnh
  final VoidCallback onCancel; // callback khi hủy tìm kiếm
  final String title; // tiêu đề trang
  final String dataType; // kiểu dữ liệu (vd: invoice, order)
  final Widget Function(Map<String, dynamic> item) itemBuilder; // widget hiển thị item

  const SearchNoteScreen({
    super.key,
    required this.searchOptions,
    required this.searchData,
    required this.onCancel,
    required this.title,
    required this.dataType,
    required this.itemBuilder, // tham số widget tùy chỉnh
  });

  @override
  _SearchNoteScreenState createState() => _SearchNoteScreenState();
}

class _SearchNoteScreenState extends State<SearchNoteScreen> {
  // controller cho ô nhập liệu tìm kiếm
  final TextEditingController _textController = TextEditingController();
  // kết quả tìm kiếm được cập nhật
  final ValueNotifier<List<Map<String, dynamic>>> _searchResults = ValueNotifier([]);
  // tag tìm kiếm hiện tại được chọn
  String? _selectedSearchKey;
  // timer cho việc debounce tìm kiếm
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Khởi tạo kết quả tìm kiếm ban đầu với tất cả dữ liệu
    _searchResults.value = List.from(widget.searchData);
    // Nếu có searchOption, mặc định chọn cái đầu tiên
    if (widget.searchOptions.isNotEmpty) {
      _selectedSearchKey = widget.searchOptions.first['searchKey'];
    }
    // lắng nghe thay đổi text để thực hiện tìm kiếm
    _textController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _debounceTimer?.cancel();
    _searchResults.dispose();
    super.dispose();
  }

  // hàm xử lý khi text trong ô tìm kiếm thay đổi (có debounce)
  void _onSearchTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _filterSearchResults(_textController.text);
    });
  }

  // hàm lọc kết quả tìm kiếm dựa trên text và tag
  void _filterSearchResults(String searchText) {
    final String lowerSearchText = searchText.toLowerCase();
    final String? currentSearchKey = _selectedSearchKey;

    final List<Map<String, dynamic>> filteredResults = widget.searchData.where((item) {
      if (searchText.isEmpty) {
        return true; // hiển thị tất cả nếu không có text
      }
      if (currentSearchKey != null) {
        final fieldValue = item[currentSearchKey]?.toString().toLowerCase() ?? '';
        return fieldValue.contains(lowerSearchText);
      }
      return false;
    }).toList();

    _searchResults.value = filteredResults;
  }

  // hàm xử lý khi nhấn vào icon quét mã vạch
  void _onBarcodeScanPressed() {
    print('quét mã vạch');
    // todo: thêm mã quét mã vạch thực tế ở đây
  }

  // hàm xử lý khi nhấn vào icon x để xóa text
  void _onCancelIconPressed() {
    _textController.clear();
    // sau khi xóa text, hiển thị lại toàn bộ dữ liệu
    _filterSearchResults('');
  }

  // hàm cập nhật tag được chọn
  void _updateTag(Map<String, String> newTag) {
    setState(() {
      _selectedSearchKey = newTag['searchKey'];
      // thực hiện lọc lại kết quả khi thay đổi tag
      _filterSearchResults(_textController.text);
    });
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
                      hintText: widget.searchOptions.firstWhereOrNull((option) => option['searchKey'] == _selectedSearchKey)?['hint'],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_textController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: _onCancelIconPressed,
                            ),
                          if (_selectedSearchKey == "productId") // kiểm tra searchKey thay vì tag
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
                    'Hủy',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // danh sách tags
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.searchOptions.map((item) {
                // biến kiểm tra tag được chọn (key)
                final bool isSelected = _selectedSearchKey == item['searchKey'];
                return GestureDetector(
                  onTap: () {
                    _updateTag(item);
                  },
                  child: Chip(
                    label: Text(item['tag']!),
                    backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
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
              child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: _searchResults,
                builder: (context, searchResults, child) {
                  // nhóm danh sách kết quả theo ngày
                  final groupedItems = groupBy(searchResults, (item) {
                    return DateFormat('yyyy/MM/dd').format(DateTime.parse(item['createdAt']));
                  });
                  return ListView(
                    children: [
                      // duyệt qua từng nhóm
                      for (var group in groupedItems.entries)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // hiển thị ngày của nhóm
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
                            // hiển thị danh sách các item trong nhóm
                            for (var item in group.value)
                              GestureDetector(
                                onTap: () {
                                  // chuyển tới trang chi tiết
                                  final itemId = item['id'].toString();
                                  if (widget.dataType == 'invoice') {
                                    context.push('/${widget.dataType}/$itemId', extra: item);
                                  } else if (widget.dataType == 'order') {
                                    context.push('/${widget.dataType}/$itemId', extra: item);
                                  } else if (widget.dataType == 'returnInvoice') {
                                    context.push('/${widget.dataType}/$itemId');
                                  }
                                },
                                child: widget.itemBuilder(item),
                              ),
                          ],
                        ),
                    ],
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