import 'package:sales_management_application/config/constants.dart';

class ProductStatistic {

  String id; // ID duy nhất của bản ghi thống kê (dạng String)

  String productId; // ID của sản phẩm mà bản ghi này liên quan

  String productName; // Tên của sản phẩm

  num totalSoldQuantity; // Tổng số lượng sản phẩm đã bán

  num totalImportedQuantity; // Tổng số lượng sản phẩm đã nhập

  num totalRevenue; // Tổng doanh thu từ sản phẩm

  num totalCost; // Tổng chi phí (giá vốn) của sản phẩm

  num currentInventoryValue; // Giá trị tồn kho hiện tại của sản phẩm

  num currentInventoryQuantity; // Số lượng tồn kho hiện tại của sản phẩm

  DateTime? statisticDate; //DateTime bỏ phần giờ

  String uid;

  // Constructor có tham số, dùng để tạo đối tượng ProductStatisticHive
  ProductStatistic({
    required this.id,
    required this.productId,
    required this.productName,
    required this.totalSoldQuantity,
    required this.totalImportedQuantity,
    required this.totalRevenue,
    required this.totalCost,
    required this.currentInventoryValue,
    required this.currentInventoryQuantity,
    this.statisticDate,
    required this.uid
  });

  // Constructor rỗng, dùng để tạo đối tượng ProductStatisticHive với giá trị mặc định
  ProductStatistic.empty()
      : id = '',
        productId = '',
        productName = '',
        totalSoldQuantity = 0,
        totalImportedQuantity = 0,
        totalRevenue = 0,
        totalCost = 0,
        currentInventoryValue = 0,
        currentInventoryQuantity = 0,
        uid = '';

// Tổng lợi nhuận từ sản phẩm
 num get totalProfit => totalRevenue - totalCost;

  num getAttribute(String value) {
    switch (value) {
      //Tổng số lượng sản phẩm đã bán
      case AppString.totalSoldQuantity:
        return totalSoldQuantity;
      //Tổng số lượng sản phẩm đã nhập
      case AppString.totalImportedQuantity:
        return totalImportedQuantity;
      //Tổng Tổng doanh thu
      case AppString.totalRevenue:
        return totalRevenue;
      //Tổng chi phí
      case AppString.totalCost:
        return totalCost;
      //Tổng lợi nhuận
      case AppString.totalProfit:
        return totalProfit;
      //Tổng số lượng tồn kho
      case AppString.currentInventoryQuantity:
        return currentInventoryQuantity ;
      //Tổng giá trị tồn kho
      case AppString.currentInventoryValue:
        return currentInventoryValue ;
      default:
        return AppNum.zero;
    }
  }

  // Hàm chuyển đổi ProductStatistic thành Map (dạng JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'totalSoldQuantity': totalSoldQuantity,
      'totalImportedQuantity': totalImportedQuantity,
      'totalRevenue': totalRevenue,
      'totalCost': totalCost,
      'totalProfit': totalProfit,
      'currentInventoryValue': currentInventoryValue,
      'currentInventoryQuantity': currentInventoryQuantity,
      'statisticDate': statisticDate!.toIso8601String(),
      'uid': uid,
    };
  }

  // Hàm chuyển đổi Map (dạng JSON) thành ProductStatistic
  factory ProductStatistic.fromJson(Map<String, dynamic> json) {
    return ProductStatistic(
      id: json['id'] ?? '',
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      totalSoldQuantity: json['totalSoldQuantity'] as num,
      totalImportedQuantity: json['totalImportedQuantity'] as num,
      totalRevenue: json['totalRevenue'] as num,
      totalCost: json['totalCost'] as num,
      currentInventoryValue: json['currentInventoryValue'] as num,
      currentInventoryQuantity: json['currentInventoryQuantity'] as num,
      statisticDate: json['statisticDate'] != null
          ? DateTime.tryParse(json['statisticDate'])
          : null,
      uid: json['uid']
    );
  }

}
