import 'package:sales_management_application/services/sorting_service.dart';

class SortingController {
  final SortingService _sortingService = SortingService();

  List<Map<String, dynamic>> currentData;

  SortingController(this.currentData);

  // Hàm sắp xếp và cập nhật dữ liệu
  void updateSorting(String sortingType, [String? sortValue]) {
    currentData = _sortingService.sortData(currentData, sortingType, sortValue);
  }
}
