
import 'package:sales_management_application/products/product_service.dart';
import 'package:sales_management_application/return_sale/return_invoice_service.dart';
import 'package:sales_management_application/return_sale/return_sale_filter.dart';

import '../config/constants.dart';
import '../customers/model/customer.dart';
import '../customers/service/customer_service.dart';
import '../products/product.dart';
import '../receipt/receipt_detail.dart';
import '../sort/sorting_controller.dart';
import '../statistic/service/statistic_service.dart';
import '../time_filter/time_filter_service.dart';
import 'return_sale_receipt.dart';

class ReturnInvoiceController {

  ReturnInvoiceService returnInvoiceService = ReturnInvoiceService();
  ProductService productService = ProductService();
  CustomerService customerService = CustomerService();
  TimeFilterService timeFilterService = TimeFilterService();

  //lấy dữ liệu từ db, key gán vào id
  List<ReturnInvoiceReceipt> data = [ ];

  // Hàm lấy dữ liệu
  Future<List<ReturnInvoiceReceipt>> getReturnInvoiceList(ReturnInvoiceFilter filter, String? customerId, DateTime? fromDate, DateTime? toDate) async {
    List<ReturnInvoiceReceipt> results = [];
    List<ReturnInvoiceReceipt> returnInvoices = await returnInvoiceService.getData(filter);
    for(ReturnInvoiceReceipt receipt in returnInvoices) {
      if (timeFilterService.isTimeFilterd(receipt.createdAt, fromDate, toDate)
          &&
          ((customerId == null) || (customerId != null && receipt.partnerId == customerId))
      ) {
        List<ReceiptDetail> detailResult = [];
      for(ReceiptDetail detail in receipt.details) {
        Product product = await productService.getProduct(detail.productId);
        detail.product = product;
        detailResult.add(detail);
      }
      receipt.details = detailResult;
        if (receipt.partnerId != '') {
          Customer customer = await customerService.getCustomerByKey(
              receipt.partnerId);
          receipt.customer = customer;
        }
      results.add(receipt);
    }}
    return results;
  }

  void saveReceipt(ReturnInvoiceReceipt receipt) {
    returnInvoiceService.saveReceipt(receipt);
    final statisticService = StatisticService();
    if(receipt.status == 2) statisticService.updateStatisticOnReturnSaleCreated(receipt);
  }

  /// XỬ LÝ PHIẾU ///
  //tổng giá trị hiên thị, đã hoàn thành mới cộng
  num getTotalDisplayValue(List<ReturnInvoiceReceipt> list, String attribute) {
    return list.fold(
      AppNum.zero,
          (sum, receipt) {
        var value = receipt.getAttributeValue(attribute);
        return sum + (receipt.status == AppNum.two ? value : AppNum.zero);
      },
    );
  }
  //Hủy phiếu
  bool cancelReceipt(String id) {
    returnInvoiceService.cancelReceipt(id);
    return true;
  }

  // Hàm lấy phiếu theo ID future
  Future<ReturnInvoiceReceipt?> getReceiptByIdAsync(String id) async {
    ReturnInvoiceReceipt receipt = await returnInvoiceService.getReceiptById(id);
    List<ReceiptDetail> detailResult = [];
    for(ReceiptDetail detail in receipt.details) {
      Product product = await productService.getProduct(detail.productId);
      detail.product = product;
      detailResult.add(detail);
    }
    receipt.details = detailResult;
    if (receipt.partnerId != '') {
      Customer customer = await customerService.getCustomerByKey(
          receipt.partnerId);
      receipt.customer = customer;
    }
    return receipt;
  }

  // Hàm lấy phiếu theo ID
  ReturnInvoiceReceipt? getReceiptById(String id) {
    return data.firstWhere(
          (receipt) => receipt.id == id,
      orElse: () => ReturnInvoiceReceipt.empty(),
    );
  }

  // Hàm xóa phiếu
  void deleteReceipt(String id) {
    data.removeWhere((receipt) => receipt.id == id);
  }

  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<ReturnInvoiceReceipt>? data) => [
    for (var receipt in data ?? <ReturnInvoiceReceipt>[]) receipt.toJson1(),
  ];

  // chuyển sang danh sách object
  List<ReturnInvoiceReceipt> convertFromJSON(List<Map<String, dynamic>> json) {
    return json
        .map((receiptJson) => ReturnInvoiceReceipt.fromJson(receiptJson))
        .toList();
  }
  //lọc, sắp xếp dữ liệu
  List<ReturnInvoiceReceipt> filterAndSortReceipts(
      List<ReturnInvoiceReceipt> receipts,
      Map<String, dynamic> filters,
      DateTime? startDate,
      DateTime? endDate,
      String sortOption,
      ) {
    List<ReturnInvoiceReceipt> filteredReceipts = receipts;

    // Lọc theo khoảng thời gian
    if (startDate != null) {
      filteredReceipts =
          filterReceiptsByDateRange(filteredReceipts, startDate, endDate);
    }
    // Sắp xếp theo tùy chọn
    SortingController sortingController = SortingController(convertToJSON(filteredReceipts));
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
  bool existDetail(ReturnInvoiceReceipt receipt, String productId) {
    return receipt.details.any((item) => item.productId == productId);
  }

  /// Hàm lấy chi tiết phiếu trong phiếu hủy xuất
  ReceiptDetail getDetailByProductId(
      ReturnInvoiceReceipt receipt, String productId) {
    return receipt.details.firstWhere(
          (detail) => detail.productId == productId,
      orElse: () => ReceiptDetail.empty(),
    );
  }

  /// Hàm cập nhật chi tiết phiếu trong phiếu hủy xuất
  void updateDetail(ReturnInvoiceReceipt receipt, ReceiptDetail detail) {
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
  void removeDetail(ReturnInvoiceReceipt receipt, ReceiptDetail detail) {
    receipt.details.remove(detail);
  }

  ///lọc theo thời gian
  List<ReturnInvoiceReceipt> filterReceiptsByDateRange(
      List<ReturnInvoiceReceipt> receipts, DateTime? startDate, DateTime? endDate) {
    List<ReturnInvoiceReceipt> filteredReceipts = receipts;
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
  List<ReturnInvoiceReceipt> filterReceipts(
      List<ReturnInvoiceReceipt> receipts,
      Map<String, dynamic> filters,
      ) {
    List<ReturnInvoiceReceipt> filteredReceipts = receipts;
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
  List<ReturnInvoiceReceipt> sortReceipts(
      List<ReturnInvoiceReceipt> receipts,
      String sortOption,
      String sortAttribute
      ) {
    // Sắp xếp theo tùy chọn
    final sortingController = SortingController(convertToJSON(receipts));
    sortingController.updateSorting(sortOption, sortAttribute);

    return convertFromJSON(sortingController.currentData);
  }
}
