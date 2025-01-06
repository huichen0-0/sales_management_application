import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/import/import_service.dart';
import 'package:sales_management_application/products/product_service.dart';
import 'package:sales_management_application/suppliers/supplier_service.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';
import '../products/product.dart';
import '../receipt/receipt_detail.dart';
import '../sort/sorting_controller.dart';
import '../statistic/service/statistic_service.dart';
import '../suppliers/supplier.dart';
import 'import_filter.dart';
import 'import_receipt.dart';

class ImportController {
  //lấy dữ liệu từ db, key gán vào id
  List<ImportReceipt> data = [  ];
  ImportService importService = ImportService();
  ProductService productService = ProductService();
  SupplierService supplierService = SupplierService();
  TimeFilterService timeFilterService = TimeFilterService();

  // Hàm lấy dữ liệu
  Future<List<ImportReceipt>> getData(ImportFilter filter, DateTime? fromDate, DateTime? toDate, String? supplierId) async {
    //lấy data từ db lưu vào biến data
    List<ImportReceipt> receipts = await importService.getData(filter);
    List<ImportReceipt> results = [];
    for(ImportReceipt i in receipts) {
      if(((supplierId != null && i.partnerId == supplierId) || supplierId == null)
          && timeFilterService.isTimeFilterd(i.createdAt, fromDate, toDate)) {
        List<ReceiptDetail> details = [];
        for (ReceiptDetail detail in i.details) {
          Product product = await productService.getProduct(detail.productId);
          detail.product = product;
          details.add(detail);
        }
        i.details = details;
        Supplier supplier = await supplierService.getSupplierByKey(i.partnerId);
        i.supplier = supplier;
        results.add(i);
      }
    }
    return results;
  }

  Future<ImportReceipt> getReceiptByKey(String key) {
    return importService.getReceiptByKey('ImportReceipt',key);
  }

  /// XỬ LÝ PHIẾU ///
  //tổng giá trị hiên thị, đã hoàn thành mới cộng
  num getTotalDisplayValue(String attribute, List<ImportReceipt> receipts) {
      return receipts.fold(
        AppNum.zero,
            (sum, receipt) {
          var value = receipt.getAttributeValue(attribute);
          return sum + (receipt.status == AppNum.two ? value : AppNum.zero);
        },
      );
  }
  //Hủy phiếu
  bool cancelReceipt(ImportReceipt receipt) {
    try {
      importService.delete(receipt);
      return true;
    } catch(e) {
      print(e.toString());
      return false;
    }
  }

  // Hàm thêm mới/cập nhật phiếu
  void updateReceipt({
    required ImportReceipt updatedItem,
  }) {
    final index = data.indexWhere((receipt) => receipt.id == updatedItem.id);
    if (index == -1) {
      data.add(updatedItem);
    } else {
      data[index] = updatedItem;
    }
  }

  // Hàm lấy phiếu theo ID future
  Future<ImportReceipt?> getReceiptByIdAsync(String id) async {
    return data.firstWhere(
      (receipt) => receipt.id == id,
      orElse: () => ImportReceipt.empty(),
    );
  }

  // Hàm lấy phiếu theo ID
  Future<ImportReceipt> getReceiptById(String id) async {
    ImportReceipt importReceipt = await importService.getReceiptByKey('ImportReceipt', id);
    List<ReceiptDetail> details = [];
    for(ReceiptDetail detail in importReceipt.details) {
      Product product = await productService.getProduct(detail.productId);
      detail.product = product;
      details.add(detail);
    }
    importReceipt.details = details;
    Supplier supplier = await supplierService.getSupplierByKey(importReceipt.partnerId);
    importReceipt.supplier = supplier;
    return importReceipt;
  }

  void saveReceipt(ImportReceipt receipt) {
    importService.save(receipt, 'ImportReceipt');
    final statisticService = StatisticService();
    if(receipt.status == 2) statisticService.updateStatisticOnImportCreated(receipt);
  }

  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<ImportReceipt>? data) => [
        for (var receipt in data ?? <ImportReceipt>[]) receipt.toJson1(),
      ];

  // chuyển sang danh sách object
  List<ImportReceipt> convertFromJSON(List<Map<String, dynamic>> json) {
    return json
        .map((receiptJson) => ImportReceipt.fromJson(receiptJson))
        .toList();
  }

  /// XỬ LÝ CHI TIẾT PHIẾU ///
  // kiểm tra hàng hóa đã trong phiếu kiểm chưa
  bool existDetail(ImportReceipt receipt, String productId) {
    return receipt.details.any((item) => item.productId == productId);
  }

  /// Hàm lấy chi tiết phiếu trong phiếu hủy xuất
  ReceiptDetail getDetailByProductId(ImportReceipt receipt, String productId) {
    return receipt.details.firstWhere(
      (detail) => detail.productId == productId,
      orElse: () => ReceiptDetail.empty(),
    );
  }

  /// Hàm cập nhật chi tiết phiếu trong phiếu hủy xuất
  void updateDetail(ImportReceipt receipt, ReceiptDetail detail) {
    final detailIndex = receipt.details.indexWhere(
      (item) => item.productId == detail.productId,
    );

    if (detailIndex != -1) {
      // Cập nhật chi tiết phiếu
      receipt.details[detailIndex] = detail;
    } else {
      // Thêm chi tiết phiếu mới
      receipt.details.add(detail);
    }
  }

  //Hàm xóa chi tiết phiếu ra khỏi phiếu
  void removeDetail(ImportReceipt receipt, ReceiptDetail detail) {
    receipt.details.remove(detail);
  }


  ///lọc theo thời gian
  List<ImportReceipt> filterReceiptsByDateRange(
      List<ImportReceipt> receipts, DateTime? startDate, DateTime? endDate) {
    List<ImportReceipt> filteredReceipts = receipts;
    if (startDate != null) {
      filteredReceipts = receipts.where((receipt) {
        return receipt.createdAt.isAfter(startDate);
      }).toList();
    }
    if (endDate != null) {
      filteredReceipts = filteredReceipts.where((receipt) {
        return receipt.createdAt.isBefore(endDate);
      }).toList();
    }
    return filteredReceipts;
  }

  ///lọc theo bộ lọc
  List<ImportReceipt> filterReceipts(
    List<ImportReceipt> receipts,
    Map<String, dynamic> filters,
  ) {
    List<ImportReceipt> filteredReceipts = receipts;
    //bộ lọc
    if (filters.isNotEmpty) {
      final statusFilters = filters[AppAttribute.status] as Map<int, bool>;
      filteredReceipts = receipts.where((receipt) {
        return statusFilters[receipt.status] == true;
      }).toList();
    }
    return filteredReceipts;
  }

  ///sắp xếp
  List<ImportReceipt> sortReceipts(
    List<ImportReceipt> receipts,
    String sortOption,
  ) {
    // Sắp xếp theo tùy chọn
    final sortingController = SortingController(convertToJSON(receipts));
    sortingController.updateSorting(sortOption);

    return convertFromJSON(sortingController.currentData);
  }

}
