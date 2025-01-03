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
      case AppString.newest:
        return data.sorted((a, b) => b['createdAt'].compareTo(a['createdAt']));
      case AppString.oldest:
        return data.sorted((a, b) => a['createdAt'].compareTo(b['createdAt']));
      case AppString.ascValue:
        return data.sorted((a, b) => (a[sortValue] as num).compareTo(b[sortValue] as num));
      case AppString.descValue:
        return data.sorted((a, b) => (b[sortValue] as num).compareTo(a[sortValue] as num));
      case AppString.aZ:
        return data.sorted((a, b) => (a['name'] as String).compareTo(b['name'] as String));
      case AppString.zA:
        return data.sorted((a, b) => (b['name'] as String).compareTo(a['name'] as String));
      default:
        return data;
    }
  }
}
