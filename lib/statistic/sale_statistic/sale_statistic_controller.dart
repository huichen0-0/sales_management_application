import 'package:sales_management_application/statistic/sale_statistic/sale_statistic.dart';
import 'package:sales_management_application/statistic/service/statistic_service.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';
import '../../sort/sorting_controller.dart';

class SaleStatisticController {
  //Service
  final StatisticService _statisticService = StatisticService();
  final timeFilterService = TimeFilterService(); //luu data

  //Lấy dữ liệu thống kê trong khoảng thời gian và tổng hợp
  Future<List<SaleStatistic>> getStatistics(
      DateTime? startDate, DateTime? endDate) async {
    List<SaleStatistic> result = [];
    List<SaleStatistic> statistics =
        await _statisticService.getSaleStatistics();
    for (var item in statistics) {
      if (timeFilterService.isTimeFilterd(
          item.createdAt!, startDate, endDate)) {
        result.add(item);
      }
    }
    DateTime currentDate = startDate!;
    while (currentDate.isBefore(endDate!)) {
      // Kiểm tra xem đã có ProductStatistic cho product này trong result chưa
      bool alreadyExists = result
          .any((statistic) => _isSameDay(statistic.createdAt, currentDate));

      if (!alreadyExists) {
        final newStatistic = SaleStatistic(
          id: '',
          totalRevenue: 0,
          totalCost: 0,
          createdAt: currentDate,
          uid: '', totalProfit: 0,
        );
        await _statisticService.saveOrUpdateSaleStatistic(newStatistic);
        result.add(newStatistic);
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return result;
  }

  //Tính thống kê tổng hợp
  SaleStatistic getAggregateStatistic(List<SaleStatistic> statistics) {
    return _statisticService.getAggregateSaleStatistic(statistics);
  }

  ///sắp xếp
  List<SaleStatistic> sortStatistics(
      List<SaleStatistic> statistics, String sortOption) {
    // Sắp xếp theo tùy chọn
    final sortingController = SortingController(convertToJSON(statistics));
    sortingController.updateSorting(sortOption);

    return convertFromJSON(sortingController.currentData);
  }

  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<SaleStatistic>? data) => [
        for (var receipt in data ?? <SaleStatistic>[]) receipt.toJson(),
      ];

  // chuyển sang danh sách object
  List<SaleStatistic> convertFromJSON(List<Map<String, dynamic>> json) =>
      json.map((e) => SaleStatistic.fromJson(e)).toList();

  bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) {
      return false;
    }
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
