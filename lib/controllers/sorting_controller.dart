import 'package:collection/collection.dart';
import 'package:sales_management_application/config/constants.dart';

class SortingController {

  List<Map<String, dynamic>> currentData;

  SortingController(this.currentData);

  // Hàm sắp xếp và cập nhật dữ liệu
  void updateSorting(String sortingType, [String? sortValue]) {
    currentData = sortData(currentData, sortingType, sortValue);
  }

  //Phương thức sắp xếp
  List<Map<String, dynamic>> sortData(
      List<Map<String, dynamic>> data, String sortingType, String? sortValue) {
    switch (sortingType) {
      case AppSort.newest:
        return data.sorted((a, b) => b['created_at'].compareTo(a['created_at']));
      case AppSort.oldest:
        return data.sorted((a, b) => a['created_at'].compareTo(b['created_at']));
      case AppSort.ascValue:
        return data.sorted((a, b) => (a[sortValue] as num).compareTo(b[sortValue] as num));
      case AppSort.descValue:
        return data.sorted((a, b) => (b[sortValue] as num).compareTo(a[sortValue] as num));
      case AppSort.aZ:
        return data.sorted((a, b) => (a['name'] as String).compareTo(b['name'] as String));
      case AppSort.zA:
        return data.sorted((a, b) => (b['name'] as String).compareTo(a['name'] as String));
      default:
        return data;
    }
  }
}
