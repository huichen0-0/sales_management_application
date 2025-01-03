import 'package:sales_management_application/time_filter/time_filter_service.dart';

class TimeFilterController {
  TimeFilterService timeFilterService = TimeFilterService();

  List<DateTime?> getTimeRange(String selectedOption, DateTime? fromValue, DateTime? toValue) {
    return timeFilterService.getTimeRange(selectedOption, fromValue, toValue);
  }
}