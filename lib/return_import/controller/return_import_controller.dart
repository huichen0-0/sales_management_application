import 'package:sales_management_application/time_filter/time_filter_service.dart';

import '../../import/import_filter.dart';
import '../../products/product.dart';
import '../../products/product_service.dart';
import '../../receipt/receipt_detail.dart';
import '../../sort/sorting_controller.dart';
import '../../statistic/service/statistic_service.dart';
import '../../suppliers/supplier.dart';
import '../../suppliers/supplier_service.dart';
import '../model/return_import_receipt.dart';
import '../return_import_filter.dart';
import '../return_import_service.dart';

class ReturnImportController {
  //lấy dữ liệu từ db, key gán vào id
  List<ReturnImportReceipt> data = [ ];
  ReturnImportService returnImportService = ReturnImportService();
  ProductService productService = ProductService();
  SupplierService supplierService = SupplierService();
  TimeFilterService timeFilterService = TimeFilterService();

  // Hàm lấy dữ liệu
  Future<List<ReturnImportReceipt>> getData(ReturnImportFilter filter,  String selectedOption, DateTime? fromDate, DateTime? toDate, String? supplierId) async {
    //lấy data từ db lưu vào biến data
    List<ReturnImportReceipt> receipts = await returnImportService.getData(filter);
    List<ReturnImportReceipt> results = [];
    for(ReturnImportReceipt i in receipts) {
      if (((supplierId != null && supplierId == i.partnerId) || supplierId == null) && timeFilterService.isTimeFilterd(i.createdAt, fromDate, toDate)) {
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

  /// XỬ LÝ PHIẾU ///
  //tổng giá trị hiên thị, đã hoàn thành mới cộng
  num getTotalDisplayValue(String attribute, List<ReturnImportReceipt> receipts) {
    return receipts.fold(
      0,
      (sum, receipt) {
        var value = receipt.getAttributeValue(attribute);
        return sum + (receipt.status == 2 ? value : 0);
      },
    );
  }
  //Hủy phiếu
  bool cancelReceipt(ReturnImportReceipt receipt) {
    try {
      returnImportService.delete(receipt);
      return true;
    } catch(e) {
      print(e.toString());
      return false;
    }
  }

  void saveReceipt(ReturnImportReceipt receipt) {
    returnImportService.save(receipt, 'ReturnImportReceipt');
    final statisticService = StatisticService();
    if(receipt.status == 2) statisticService.updateStatisticOnReturnImportCreated(receipt);
  }

  // Hàm thêm mới/cập nhật phiếu
  void updateReceipt({
    required ReturnImportReceipt updatedItem,
  }) {
    final index = data.indexWhere((receipt) => receipt.id == updatedItem.id);
    if (index == -1) {
      data.add(updatedItem);
    } else {
      data[index] = updatedItem;
    }
  }

  // Hàm lấy phiếu theo ID future
  Future<ReturnImportReceipt?> getReceiptByIdAsync(String id) async {
    return data.firstWhere(
      (receipt) => receipt.id == id,
      orElse: () => ReturnImportReceipt.empty(),
    );
  }

  // Hàm lấy phiếu theo ID
  ReturnImportReceipt? getReceiptById(String id) {
    return data.firstWhere(
      (receipt) => receipt.id == id,
      orElse: () => ReturnImportReceipt.empty(),
    );
  }

  // Hàm xóa phiếu
  void deleteReceipt(String id) {
    data.removeWhere((receipt) => receipt.id == id);
  }

  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<ReturnImportReceipt>? data) => [
        for (var receipt in data ?? <ReturnImportReceipt>[]) receipt.toJson1(),
      ];

  // chuyển sang danh sách object
  List<ReturnImportReceipt> convertFromJSON(List<Map<String, dynamic>> json) {
    return json
        .map((receiptJson) => ReturnImportReceipt.fromJson(receiptJson))
        .toList();
  }
  //lọc, sắp xếp dữ liệu
  List<ReturnImportReceipt> filterAndSortReceipts(
    List<ReturnImportReceipt> receipts,
    Map<String, dynamic> filters,
    DateTime? startDate,
    DateTime? endDate,
    String sortOption,
  ) {
    List<ReturnImportReceipt> filteredReceipts = receipts;

    // Lọc theo khoảng thời gian
    if (startDate != null) {
      filteredReceipts =
          filterReceiptsByDateRange(filteredReceipts, startDate, endDate);
    }
    // Sắp xếp theo tùy chọn
    SortingController sortingController =
        SortingController(convertToJSON(filteredReceipts));
    sortingController.updateSorting(sortOption);
    final sortedMap = sortingController.currentData;
    filteredReceipts = convertFromJSON(sortedMap);

    //bộ lọc
    if (filters.isNotEmpty) {
      final statusFilters = filters['status'] as Map<int, bool>;
      filteredReceipts = receipts.where((receipt) {
        return statusFilters[receipt.status] == true;
      }).toList();
    }

    return filteredReceipts;
  }

  /// XỬ LÝ CHI TIẾT PHIẾU ///
  // kiểm tra hàng hóa đã trong phiếu kiểm chưa
  bool existDetail(ReturnImportReceipt receipt, String productId) {
    return receipt.details.any((item) => item.productId == productId);
  }

  /// Hàm lấy chi tiết phiếu trong phiếu hủy xuất
  ReceiptDetail getDetailByProductId(
      ReturnImportReceipt receipt, String productId) {
    return receipt.details.firstWhere(
      (detail) => detail.productId == productId,
      orElse: () => ReceiptDetail.empty(),
    );
  }

  /// Hàm cập nhật chi tiết phiếu trong phiếu hủy xuất
  void updateDetail(ReturnImportReceipt receipt, ReceiptDetail detail) {
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
  void removeDetail(ReturnImportReceipt receipt, ReceiptDetail detail) {
    receipt.details.remove(detail);
  }

  ///lọc theo thời gian
  List<ReturnImportReceipt> filterReceiptsByDateRange(
      List<ReturnImportReceipt> receipts, DateTime? startDate, DateTime? endDate) {
    List<ReturnImportReceipt> filteredReceipts = receipts;
    // lấy phiếu có createdAt > startDate
    if (startDate != null) {
      filteredReceipts = receipts.where((receipt) {
        return receipt.createdAt.isAfter(startDate);
      }).toList();
    }
    // lấy phiếu có createdAt < endDate
    if (endDate != null) {
      filteredReceipts = filteredReceipts.where((receipt) {
        return receipt.createdAt.isBefore(endDate);
      }).toList();
    }
    return filteredReceipts;
  }

  ///lọc theo bộ lọc
  List<ReturnImportReceipt> filterReceipts(
      List<ReturnImportReceipt> receipts,
      Map<String, dynamic> filters,
      ) {
    List<ReturnImportReceipt> filteredReceipts = receipts;
    //bộ lọc
    if (filters.isNotEmpty) {
      //status : {0 : bool, 1 : bool, 3: bool}
      final statusFilters = filters['status'] as Map<int, bool>;
      filteredReceipts = receipts.where((receipt) {
        return statusFilters[receipt.status] == true;
      }).toList();
    }
    return filteredReceipts;
  }

  ///sắp xếp
  List<ReturnImportReceipt> sortReceipts(
      List<ReturnImportReceipt> receipts,
      String sortOption,
      ) {
    // khơỉ tạo
    final sortingController = SortingController(convertToJSON(receipts));
    //sắp xếp theo tùy chọn
    sortingController.updateSorting(sortOption);
    //chuyển về object
    return convertFromJSON(sortingController.currentData);
  }
}
