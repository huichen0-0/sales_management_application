import 'package:sales_management_application/services/searching_service.dart';


class SearchingController {
  final SearchService _searchService = SearchService();
  final List<Map<String, dynamic>> searchData; // Dữ liệu tìm kiếm cho trang cụ thể
  String? selectedSearchKey; //thuôc tính tim kiếm
  String currentTag; //tag hiện tại
  String currentHintText; // hint text hiện tại
  List<Map<String, dynamic>> searchResults = []; //kết quả là danh sách

  SearchingController({
    required this.searchData,
    required List<Map<String, String>> searchOptions,
  })  : selectedSearchKey = searchOptions.first['searchKey'],
        currentTag = searchOptions.first['tag']!,
        currentHintText = searchOptions.first['hint']!;

  // Hàm cập nhật tag, hint text và searchKey
  void updateTag(Map<String, String> selectedTagInfo) {
    selectedSearchKey = selectedTagInfo['searchKey'];
    currentTag = selectedTagInfo['tag'] ?? '';
    currentHintText = selectedTagInfo['hint'] ?? '';
  }

  // Hàm cập nhật kết quả tìm kiếm với `searchKey`
  void updateSearchResults(String query) {
    if (selectedSearchKey != null) {
      searchResults = _searchService.filterSearchResults(query, searchData, selectedSearchKey!);
    }
  }
}
