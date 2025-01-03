import 'package:sales_management_application/config/constants.dart';

class TimeFilterService {

  bool isTimeFilterd(DateTime createAt, DateTime? fromDate, DateTime? toDate) {
    if (fromDate == null && toDate == null) {
      return true;
    }
    DateTime tomorrowDate = DateTime.now().add(Duration(days: 1));
    if (fromDate == toDate && fromDate?.day == tomorrowDate.day) {
      return true;
    }
    DateTime from = DateTime(fromDate!.year, fromDate!.month, fromDate!.day);
    DateTime to = DateTime(toDate!.year, toDate!.month, toDate!.day);
    DateTime compareValue = DateTime(createAt.year, createAt.month, createAt.day);
    if ((compareValue.isAtSameMomentAs(from) || compareValue.isAfter(from)) &&
        (compareValue.isAtSameMomentAs(to) || compareValue.isBefore(to))) {
      return true;
    } else {
      return false;
    }
  }

  List<DateTime?> getTimeRange(String selectedOption, DateTime? fromValue, DateTime? toValue) {
    DateTime currentTime = DateTime.now();
    if (selectedOption == AppString.allTime) {
      fromValue = DateTime.now().add(Duration(days: 1));
      toValue = DateTime.now().add(Duration(days: 1));
      return [fromValue, toValue];
    }
    else if (selectedOption == AppString.today) {
      DateTime today = currentTime;
      return [today, today];
    }
    else if (selectedOption == AppString.yesterday) {
      DateTime yesterday = currentTime.subtract(Duration(days: 1));
      return [yesterday, yesterday];
    }
    else if (selectedOption == AppString.last7Days) {
      DateTime last7Days = currentTime.subtract(Duration(days: 6));
      return [last7Days, currentTime];
    }
    else if (selectedOption == AppString.thisMonth) {
      DateTime firstDayOfMonth = DateTime(currentTime.year, currentTime.month, 1);
      DateTime lastDayOfMonth = DateTime(currentTime.year, currentTime.month + 1, 1).subtract(Duration(days: 1));
      return [firstDayOfMonth, lastDayOfMonth];
    } else {
      return [fromValue, toValue];
    }
  }
}