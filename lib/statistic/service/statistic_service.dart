import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/import/import_receipt.dart';
import 'package:sales_management_application/invoice/invoice_receipt.dart';
import 'package:sales_management_application/products/product_service.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';
import 'package:sales_management_application/return_import/model/return_import_receipt.dart';
import 'package:sales_management_application/return_sale/return_sale_receipt.dart';
import 'package:sales_management_application/statistic/product_statistic/product_statistic.dart';
import 'package:sales_management_application/statistic/sale_statistic/sale_statistic.dart';

class StatisticService {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ProductService productService = ProductService();

  Future<List<ProductStatistic>> getProductStatistics() async {
    List<ProductStatistic> productList = [];
    Map<String, Object> result =
        await firebaseService.readData("ProductStatistic");
    result.forEach((key, value) {
      ProductStatistic mapValue =
          ProductStatistic.fromJson(Map<String, dynamic>.from(value as Map));
      mapValue.id = key;
      if (isBelonged(mapValue, _auth.currentUser!.uid)) {
        productList.add(mapValue);
      }
    });
    print('Get ProductStatistic data successfully');
    return productList;
  }

  Future<List<SaleStatistic>> getSaleStatistics() async {
    List<SaleStatistic> saleList = [];
    Map<String, Object> result =
        await firebaseService.readData("SaleStatistic");
    result.forEach((key, value) {
      SaleStatistic mapValue = SaleStatistic.fromJson(
          Map<String, dynamic>.from(value as Map));
      mapValue.id = key;
      if (mapValue.uid == _auth.currentUser!.uid) {
        saleList.add(mapValue);
      }
    });
    print('Get SaleStatistic data successfully');
    return saleList;
  }

  bool isBelonged(ProductStatistic product, String uid) {
    if (product.uid == uid) {
      return true;
    }
    return false;
  }

  List<ProductStatistic> getAggregateStatistics(
    List<ProductStatistic> dailyStatistics,
  ) {
    DateTime now = DateTime.now();
    return dailyStatistics
        .groupFoldBy<String, ProductStatistic>(
          (statistic) => statistic.productId,
          (previous, current) {
            return ProductStatistic(
                id: current.productId,
                productId: current.productId,
                productName: current.productName,
                totalSoldQuantity: (previous?.totalSoldQuantity ?? 0) +
                    current.totalSoldQuantity,
                totalImportedQuantity: (previous?.totalImportedQuantity ?? 0) +
                    current.totalImportedQuantity,
                totalRevenue:
                    (previous?.totalRevenue ?? 0) + current.totalRevenue,
                totalCost: (previous?.totalCost ?? 0) + current.totalCost,
                currentInventoryValue: current.currentInventoryValue,
                currentInventoryQuantity: current.currentInventoryQuantity,
                statisticDate: now,
                uid: current.uid);
          },
        )
        .values
        .toList();
  }

  //Tính thống kê tổng hợp
  ProductStatistic getAggregateProductStatistic(
      List<ProductStatistic> statistics) {
    DateTime now = DateTime.now();
    return statistics.fold(
      ProductStatistic.empty(),
      (previousValue, element) => ProductStatistic(
        id: 'aggregate',
        productId: 'aggregate',
        productName: 'Tổng',
        totalSoldQuantity:
            previousValue.totalSoldQuantity + element.totalSoldQuantity,
        totalImportedQuantity:
            previousValue.totalImportedQuantity + element.totalImportedQuantity,
        totalRevenue: previousValue.totalRevenue + element.totalRevenue,
        totalCost: previousValue.totalCost + element.totalCost,
        currentInventoryValue:
            previousValue.currentInventoryValue + element.currentInventoryValue,
        currentInventoryQuantity: previousValue.currentInventoryQuantity +
            element.currentInventoryQuantity,
        statisticDate: now,
        uid: element.uid,
      ),
    );
  }

  //Tính thống kê tổng hợp
  SaleStatistic getAggregateSaleStatistic(
      List<SaleStatistic> statistics) {
    return statistics.fold(
      SaleStatistic.empty(),
      (previousValue, element) => SaleStatistic(
        id: 'aggregate',
        totalRevenue: previousValue.totalRevenue + element.totalRevenue,
        totalCost: previousValue.totalCost + element.totalCost,
        uid: element.uid, totalProfit: previousValue.totalProfit + element.totalProfit,
      ),
    );
  }

  //nhập hàng
  Future<void> updateStatisticOnImportCreated(ImportReceipt receipt) async {
    final statisticDate = receipt.createdAt;

    for (var item in receipt.details) {
      final productStatistic = await _getOrCreateProductStatistic(
        productId: item.productId,
        productName: item.product!.name,
        statisticDate: statisticDate,
      );

      productStatistic.totalImportedQuantity += item.quantity;
      
      await _saveOrUpdateProductStatistic(productStatistic);
    }
  }

  // Hàm cập nhật thống kê khi tạo hóa đơn bán hàng
  Future<void> updateStatisticOnInvoiceCreated(InvoiceReceipt receipt) async {
    final statisticDate = receipt.createdAt;
    //cập nhật thống kê bán hàng
    final saleStatistic = await _getOrCreateSaleStatistic(
      statisticDate: statisticDate,
    );
    saleStatistic.totalRevenue += receipt.totalSaleValue;
    saleStatistic.totalCost += receipt.totalImportValue;
    saleStatistic.totalProfit = saleStatistic.totalRevenue - saleStatistic.totalCost;
    await saveOrUpdateSaleStatistic(saleStatistic);
    //cập nhật thống kê hàng hóa
    for (var item in receipt.details) {
      final productStatistic = await _getOrCreateProductStatistic(
        productId: item.productId,
        productName: item.product!.name,
        statisticDate: statisticDate,
      );

      productStatistic.totalSoldQuantity += item.quantity;
      productStatistic.totalRevenue += item.quantity * item.saleValue;
      productStatistic.totalCost += item.capitalValue; // Cần đảm bảo có giá vốn
      

      await _saveOrUpdateProductStatistic(productStatistic);
    }
  }

  // Hàm cập nhật thống kê khi tạo phiếu trả hàng nhập
  Future<void> updateStatisticOnReturnImportCreated(
      ReturnImportReceipt receipt) async {
    final statisticDate = receipt.createdAt;
    for (var item in receipt.details) {
      final productStatistic = await _getOrCreateProductStatistic(
        productId: item.productId,
        productName: item.product!.name,
        statisticDate: statisticDate,
      );

      productStatistic.totalImportedQuantity -= item.quantity;

      
      await _saveOrUpdateProductStatistic(productStatistic);
    }
  }

  // Hàm cập nhật thống kê khi tạo phiếu trả hàng bán
  Future<void> updateStatisticOnReturnSaleCreated(
      ReturnInvoiceReceipt receipt) async {
    final statisticDate = receipt.createdAt;
    //cập nhật thống kê bán hàng
    final saleStatistic = await _getOrCreateSaleStatistic(
      statisticDate: statisticDate,
    );
    saleStatistic.totalRevenue -= receipt.totalSaleValue;
    saleStatistic.totalCost -= receipt.totalImportValue;
    saleStatistic.totalProfit = saleStatistic.totalRevenue - saleStatistic.totalCost;
    await saveOrUpdateSaleStatistic(saleStatistic);
    //cập nhật thống kê hàng hóa
    for (var item in receipt.details) {
      final productStatistic = await _getOrCreateProductStatistic(
        productId: item.productId,
        productName: item.product!.name,
        statisticDate: statisticDate,
      );

      productStatistic.totalSoldQuantity -= item.quantity;
      productStatistic.totalRevenue -= item.saleValue; // Giá trị hoàn trả
      productStatistic.totalCost -= item.capitalValue;

      
      await _saveOrUpdateProductStatistic(productStatistic);
    }
  }

  // Hàm lấy hoặc tạo mới ProductStatistic theo productId và statisticDate
  Future<ProductStatistic> _getOrCreateProductStatistic({
    required String productId,
    required String productName,
    required DateTime? statisticDate,
  }) async {
    // Định dạng lại ngày để tìm kiếm (chỉ ngày, tháng, năm)
    final formattedDate = statisticDate != null
        ? DateTime(statisticDate.year, statisticDate.month, statisticDate.day)
        : null;

    List<ProductStatistic> existingStatistics =
        await getProductStatistics(); // Lấy tất cả thống kê
    ProductStatistic? existingStatistic = existingStatistics.firstWhereOrNull(
      (stat) =>
          stat.productId == productId &&
          _isSameDay(stat.statisticDate, formattedDate),
    );

    if (existingStatistic != null) {
      return existingStatistic;
    } else {
      // Tạo mới nếu không tìm thấy
      return ProductStatistic(
        id: '',
        // Sẽ được tạo bởi Firebase
        productId: productId,
        productName: productName,
        totalSoldQuantity: 0,
        totalImportedQuantity: 0,
        totalRevenue: 0,
        totalCost: 0,
        currentInventoryValue: 0,
        currentInventoryQuantity: 0,
        statisticDate: formattedDate,
        uid: _auth.currentUser!.uid,
      );
    }
  }

  // Hàm lấy hoặc tạo mới ProductStatistic theo productId và statisticDate
  Future<SaleStatistic> _getOrCreateSaleStatistic({
    required DateTime? statisticDate,
  }) async {
    // Định dạng lại ngày để tìm kiếm (chỉ ngày, tháng, năm)
    final formattedDate = statisticDate != null
        ? DateTime(statisticDate.year, statisticDate.month, statisticDate.day)
        : null;

    List<SaleStatistic> existingStatistics =
        await getSaleStatistics(); // Lấy tất cả thống kê
    SaleStatistic? existingStatistic =
        existingStatistics.firstWhereOrNull(
      (stat) => _isSameDay(stat.createdAt, formattedDate),
    );

    if (existingStatistic != null) {
      return existingStatistic;
    } else {
      // Tạo mới nếu không tìm thấy
      return SaleStatistic(
        id: '',
        totalRevenue: 0,
        totalCost: 0,
        createdAt: formattedDate,
        uid: _auth.currentUser!.uid, totalProfit: 0,
      );
    }
  }

  // Hàm lưu hoặc cập nhật ProductStatistic lên Firebase
  Future<void> _saveOrUpdateProductStatistic(ProductStatistic statistic) async {
    if (statistic.id.isEmpty) {
      // Tạo mới
      statistic.uid = _auth.currentUser!.uid;
      firebaseService.insertData("ProductStatistic", statistic.toJson());
    } else {
      // Cập nhật
      firebaseService.updateData(
          "ProductStatistic", statistic.id, statistic.toJson());
    }
  }

  // Hàm lưu hoặc cập nhật SaleStatistic lên Firebase
  Future<void> saveOrUpdateSaleStatistic(
      SaleStatistic statistic) async {
    if (statistic.id.isEmpty) {
      // Tạo mới
      statistic.uid = _auth.currentUser!.uid;
      firebaseService.insertData("SaleStatistic", statistic.toJson());
    } else {
      // Cập nhật
      firebaseService.updateData(
          "SaleStatistic", statistic.id, statistic.toJson());
    }
  }

  bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) {
      return false;
    }
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
