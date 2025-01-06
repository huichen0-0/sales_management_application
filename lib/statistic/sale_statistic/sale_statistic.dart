import 'package:sales_management_application/config/constants.dart';

class SaleStatistic {

  String id; // ID duy nhất của bản ghi thống kê (dạng String)

  num totalRevenue; // Tổng doanh thu từ sản phẩm

  num totalCost; // Tổng chi phí (giá vốn) của sản phẩm
  num totalProfit;
  DateTime? createdAt; //DateTime bỏ phần giờ

  String uid;

  // Constructor có tham số, dùng để tạo đối tượng SaleProductStatisticHive
  SaleStatistic({
    required this.id,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
    this.createdAt,
    required this.uid
  });

  // Constructor rỗng, dùng để tạo đối tượng SaleProductStatisticHive với giá trị mặc định
  SaleStatistic.empty()
      : id = '',
        totalRevenue = 0,
        totalCost = 0,
  totalProfit = 0,
        uid = '';


  num getAttribute(String value) {
    switch (value) {
    //Tổng Tổng doanh thu
      case AppString.totalRevenue:
        return totalRevenue;
    //Tổng chi phí
      case AppString.totalCost:
        return totalCost;
    //Tổng lợi nhuận
      case AppString.totalProfit:
        return totalProfit;
      default:
        return AppNum.zero;
    }
  }

  // Hàm chuyển đổi SaleProductStatistic thành Map (dạng JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalRevenue': totalRevenue,
      'totalCost': totalCost,
      'totalProfit': totalProfit,
      'createdAt': createdAt!.toIso8601String(),
      'uid': uid,
    };
  }

  // Hàm chuyển đổi Map (dạng JSON) thành SaleProductStatistic
  factory SaleStatistic.fromJson(Map<String, dynamic> json) {
    return SaleStatistic(
        id: json['id'] ?? '',
        totalRevenue: json['totalRevenue'] as num,
        totalCost: json['totalCost'] as num,
        totalProfit: json['totalProfit'] as num,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'])
            : null,
        uid: json['uid']
    );
  }

}
