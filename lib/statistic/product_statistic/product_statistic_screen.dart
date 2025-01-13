import 'package:flutter/material.dart';
import 'package:sales_management_application/statistic/product_statistic/product_statistic.dart';
import '../../config/constants.dart';
import '../../helper/helper.dart';
import '../../time_filter/time_filter_controller.dart';
import '../../views/widgets/sheets/sorting_bottom_sheet.dart';
import '../../views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'product_statistic_controller.dart'; // CONSIDER REMOVING THIS, likely a leftover
import 'display_product_statistic_bottom_sheet.dart';

class ProductStatisticScreen extends StatefulWidget {
  const ProductStatisticScreen({super.key});

  @override
  State<ProductStatisticScreen> createState() => ProductStatisticScreenState();
}

class ProductStatisticScreenState extends State<ProductStatisticScreen> {
  String _selectedSorting = AppString.descValue; // Mặc định sắp xếp giảm dần
  String _sortAttribute = AppAttribute.totalSoldQuantity;
  String _selectedOption = AppString.today; // Mặc định là tuần này
  String _selectedDisplay = AppString.totalSoldQuantity;
  //biến lưu thời gian lọc
  DateTime? fromDate;
  DateTime? toDate;

  TimeFilterController timeFilterController = TimeFilterController();
  final StatisticController _statisticController = StatisticController();

  List<ProductStatistic> _statistics = [];
  ProductStatistic _aggregateStatistic = ProductStatistic.empty();

  @override
  void initState() {
    super.initState();
    // Load initial data when the screen is initialized
    _loadStatistics();
  }

  // Helper function to load statistics
  Future<void> _loadStatistics() async {
    List<DateTime?> timeRange =
    timeFilterController.getTimeRange(_selectedOption, fromDate, toDate);
    setState(() {
      fromDate = timeRange[0]; // Removed unnecessary force unwrap
      toDate = timeRange[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<ProductStatistic>>(
        future: _statisticController.getStatistics(fromDate, toDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            // Improved empty state handling
            return const Center(child: Text('Không có dữ liệu thống kê.'));
          } else {
            _statistics = snapshot.data!;
            //sắp xếp
            if(_statistics.isNotEmpty){
              _statistics = _statisticController.sortStatistics(
                  _statistics, _selectedSorting, _sortAttribute);
            }

            _aggregateStatistic =
                _statisticController.getAggregateStatistic(_statistics);
            return _buildItemList(context, _statistics);
          }
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text(AppString.productStatistic,
          style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: const Icon(Icons.sort, color: Colors.white),
          onPressed: () => _showSortingOptions(context),
        ),
      ],
    );
  }

  Widget _buildItemList(
      BuildContext context, List<ProductStatistic> statistics) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.calendar_today, color: Colors.black),
              label: Text(_selectedOption,
                  style: const TextStyle(color: Colors.black)),
              onPressed: () => _showTimeFilterOptions(),
            ),
            Column(
              children: [
                TextButton.icon(
                  onPressed: () => _showDisplayOptions(context),
                  label: Text(_selectedDisplay,
                      style: const TextStyle(color: Colors.black)),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                ),
                Text(
                  Helper.formatCurrency(
                      _aggregateStatistic.getAttribute(_selectedDisplay)),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text('${statistics.length} sản phẩm',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        for (var statistic in statistics)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(statistic.productName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _calculateProgressValue(statistic),
                          color: Colors.blue,
                          backgroundColor: Colors.grey[300],
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        Helper.formatCurrency(
                            statistic.getAttribute(_selectedDisplay)),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  double _calculateProgressValue(ProductStatistic statistic) {
    double maxValue =
    _aggregateStatistic.getAttribute(_selectedDisplay).toDouble();
    double value = statistic.getAttribute(_selectedDisplay).toDouble();
    return maxValue <= 0 ? 0 : value / maxValue;
  }

  void _showTimeFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TimeFilterBottomSheet(
          selectedOption: _selectedOption,
          onOptionSelected: (option, startDate, [endDate]) {
            setState(() {
              _selectedOption = option;
              // Recalculate time range and update fromDate and toDate
              List<DateTime?> timeRange =
              timeFilterController.getTimeRange(_selectedOption, startDate, endDate);
              fromDate = timeRange[0];
              toDate = timeRange[1];
            });
          },
        );
      },
    );
  }

  void _showSortingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SortingBottomSheet(
          showOldest: false,
          showNewest: false,
          showZA: false,
          showAZ: false,
          selectedSorting: _selectedSorting,
          onSelectSorting: (option) {
            setState(() {
              _selectedSorting = option;
            });
          },
        );
      },
    );
  }

  void _showDisplayOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DisplayProductStatisticBottomSheet(
          selectedDisplay: _selectedDisplay,
          onSelectDisplay: (option) {
            setState(() {
              _selectedDisplay = option;
              _sortAttribute = Helper.getAttribute(_selectedDisplay);
            });
          },
        );
      },
    );
  }
}