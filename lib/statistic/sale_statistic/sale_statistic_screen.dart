import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/helper/helper.dart';
import 'package:sales_management_application/statistic/sale_statistic/sale_statistic.dart';
import 'package:sales_management_application/statistic/sale_statistic/sale_statistic_controller.dart';
import 'package:sales_management_application/time_filter/time_filter_controller.dart';
import 'package:sales_management_application/views/widgets/sheets/sorting_bottom_sheet.dart';
import 'package:sales_management_application/views/widgets/sheets/time_filter_bottom_sheet.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SaleStatisticScreen extends StatefulWidget {
  const SaleStatisticScreen({super.key});

  @override
  State<SaleStatisticScreen> createState() => _SaleStatisticScreenState();
}

class _SaleStatisticScreenState extends State<SaleStatisticScreen> {
  String _selectedSorting = AppString.newest; // Mặc định sắp xếp giảm dần
  String _selectedOption = AppString.last7Days; // Mặc định là tuần này
  //biến lưu thời gian lọc
  DateTime? fromDate;
  DateTime? toDate;

  TimeFilterController timeFilterController = TimeFilterController();
  final SaleStatisticController _saleStatisticController =
      SaleStatisticController();

  List<SaleStatistic> _statistics = [];
  SaleStatistic _aggregateStatistic = SaleStatistic.empty();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    List<DateTime?> timeRange =
        timeFilterController.getTimeRange(_selectedOption, fromDate, toDate);
    setState(() {
      fromDate = timeRange[0];
      toDate = timeRange[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<SaleStatistic>>(
        future: _saleStatisticController.getStatistics(fromDate, toDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Không có dữ liệu thống kê bán hàng.'));
          } else {
            _statistics = snapshot.data!;
            _statistics = _saleStatisticController.sortStatistics(
                _statistics, _selectedSorting);
            _aggregateStatistic =
                _saleStatisticController.getAggregateStatistic(_statistics);
            return _buildBody(context);
          }
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title:
          const Text('Báo cáo bán hàng', style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: const Icon(Icons.sort, color: Colors.white),
          onPressed: () => _showSortingOptions(context),
        ),
        IconButton(
          icon: const Icon(Icons.filter_alt, color: Colors.white),
          onPressed: () => _showTimeFilterOptions(),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummaryCards(context),
          const SizedBox(height: 20),
          _buildChart(context),
          const SizedBox(height: 20),
          _buildDataTable(context),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Row(
      children: [
        _buildSummaryCard(
          context,
          "Lợi nhuận",
          Helper.formatCurrency(_aggregateStatistic.totalProfit),
          Colors.blue,
        ),
        const SizedBox(width: 10),
        _buildSummaryCard(
          context,
          "Doanh thu",
          Helper.formatCurrency(_aggregateStatistic.totalRevenue),
          Colors.redAccent,
        ),
        const SizedBox(width: 10),
        _buildSummaryCard(
          context,
          "Giá vốn",
          Helper.formatCurrency(_aggregateStatistic.totalCost),
          Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lợi nhuận',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('dd/MM'),
            ),
            tooltipBehavior: _tooltipBehavior,
            series: <ChartSeries<SaleStatistic, DateTime>>[
              LineSeries<SaleStatistic, DateTime>(
                dataSource: _statistics,
                xValueMapper: (SaleStatistic sales, _) => sales.createdAt,
                yValueMapper: (SaleStatistic sales, _) => sales.totalProfit,
                name: 'Lợi nhuận',
                color: Colors.blue,
              ),
              LineSeries<SaleStatistic, DateTime>(
                dataSource: _statistics,
                xValueMapper: (SaleStatistic sales, _) => sales.createdAt,
                yValueMapper: (SaleStatistic sales, _) => sales.totalRevenue,
                name: 'Doanh thu',
                color: Colors.redAccent,
              ),
              LineSeries<SaleStatistic, DateTime>(
                dataSource: _statistics,
                xValueMapper: (SaleStatistic sales, _) => sales.createdAt,
                yValueMapper: (SaleStatistic sales, _) => sales.totalCost,
                name: 'Giá vốn',
                color: Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Chi tiết thống kê',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(label: Text('Ngày')),
                DataColumn(
                    label: Text('Lợi nhuận', textAlign: TextAlign.right)),
                DataColumn(
                    label: Text('Doanh thu', textAlign: TextAlign.right)),
                DataColumn(label: Text('Giá vốn', textAlign: TextAlign.right)),
              ],
              rows: _statistics.map((statistic) {
                return DataRow(
                  onSelectChanged: (selected) {
                    if (selected != null && selected) {
                      context.push('/dailySaleStatistic', extra: statistic.createdAt);
                    }
                  },
                  cells: [
                    DataCell(Text(
                        DateFormat('dd/MM/yyyy').format(statistic.createdAt!))),
                    DataCell(
                        Text(Helper.formatCurrency(statistic.totalProfit))),
                    DataCell(
                        Text(Helper.formatCurrency(statistic.totalRevenue))),
                    DataCell(Text(Helper.formatCurrency(statistic.totalCost))),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
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
              List<DateTime?> timeRange = timeFilterController.getTimeRange(
                  _selectedOption, startDate, endDate);
              fromDate = timeRange[0];
              toDate = timeRange[1];
              _loadStatistics(); // Tải lại dữ liệu sau khi chọn thời gian
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
          showAZ: false,
          showZA: false,
          showDescendingValue: false,
          showAscendingValue: false,
          onSelectSorting: (option) {
            setState(() {
              _selectedSorting = option;
            });
          },
          selectedSorting: _selectedSorting,
        );
      },
    );
  }
}
