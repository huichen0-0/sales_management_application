// search_service.dart (Tầng Data)
class SearchService {
  // Hàm lọc kết quả tìm kiếm từ dữ liệu đầu vào
  List<Map<String, dynamic>> filterSearchResults(
      String query, List<Map<String, dynamic>> searchData, String searchKey) {
    if (query.isEmpty) {
      return [];
    }
    // Lọc kết quả dựa trên giá trị của `searchKey`
    return searchData
        .where((item) =>
            item[searchKey]
                ?.toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ??
            false)
        .toList();
  }
}
