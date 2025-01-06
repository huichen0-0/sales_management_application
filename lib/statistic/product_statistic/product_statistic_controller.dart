import 'package:sales_management_application/products/product_filter.dart';
import 'package:sales_management_application/products/product_service.dart';
import 'package:sales_management_application/statistic/product_statistic/product_statistic.dart';
import 'package:sales_management_application/statistic/service/statistic_service.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';
import '../../products/product.dart';
import '../../sort/sorting_controller.dart';

class StatisticController {
  //Service
  final StatisticService _statisticService = StatisticService();
  final ProductService _productService = ProductService();
  final timeFilterService = TimeFilterService(); //luu data

  final _productFilter = ProductFilter();

  //Lấy dữ liệu thống kê trong khoảng thời gian và tổng hợp
  Future<List<ProductStatistic>> getStatistics(
      DateTime? startDate, DateTime? endDate) async {
    List<ProductStatistic> result = [];
    _productFilter.isInactive = false;
    List<Product> products =
        await _productService.getProductList(_productFilter);
    List<ProductStatistic> statistics =
        await _statisticService.getProductStatistics();
    for (var item in statistics) {
      if (timeFilterService.isTimeFilterd(
          item.statisticDate!, startDate, endDate)) {
        result.add(item);
      }
    }
    for (var product in products) {
      // Kiểm tra xem đã có ProductStatistic cho product này trong result chưa
      bool alreadyExists =
          result.any((statistic) => statistic.productId == product.id);

      if (!alreadyExists) {
        result.add(ProductStatistic(
          id: '',
          productId: product.id,
          productName: product.name,
          totalSoldQuantity: 0,
          totalImportedQuantity: 0,
          totalRevenue: 0,
          totalCost: 0,
          currentInventoryValue: product.quantity * product.capitalPrice,
          currentInventoryQuantity: product.quantity,
          statisticDate: DateTime.now(),
          uid: '',
        ));
      }
    }

    return _statisticService.getAggregateStatistics(result);
  }

  //Tính thống kê tổng hợp
  ProductStatistic getAggregateStatistic(List<ProductStatistic> statistics) {
    return _statisticService.getAggregateProductStatistic(statistics);
  }

  ///sắp xếp
  List<ProductStatistic> sortStatistics(List<ProductStatistic> statistics,
      String sortOption, String sortAttribute) {
    // Sắp xếp theo tùy chọn
    final sortingController = SortingController(convertToJSON(statistics));
    sortingController.updateSorting(sortOption, sortAttribute);

    return convertFromJSON(sortingController.currentData);
  }

  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<ProductStatistic> data) => [
        for (var receipt in data) receipt.toJson(),
      ];

  // chuyển sang danh sách object
  List<ProductStatistic> convertFromJSON(List<Map<String, dynamic>> json) =>
      json.map((e) => ProductStatistic.fromJson(e)).toList();
}
