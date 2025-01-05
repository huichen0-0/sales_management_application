import 'package:sales_management_application/customers/service/customer_service.dart';
import 'package:sales_management_application/invoice/invoice_filter.dart';
import 'package:sales_management_application/invoice/invoice_service.dart';
import 'package:sales_management_application/products/product_service.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';

import '../customers/model/customer.dart';
import '../products/product.dart';
import '../receipt/receipt_detail.dart';
import '/config/constants.dart';
import '../sort/sorting_controller.dart';
import 'invoice_receipt.dart';

class InvoiceController {
  //lấy dữ liệu từ db, key gán vào id
  List<InvoiceReceipt> data = [ ];
  InvoiceService invoiceService = InvoiceService();
  ProductService productService = ProductService();
  CustomerService customerService = CustomerService();
  TimeFilterService timeFilterService = TimeFilterService();

  // Hàm lấy dữ liệu
  Future<List<InvoiceReceipt>> getData(InvoiceFilter filter, DateTime? fromDate, DateTime? toDate, String? partnerId) async {
    List<InvoiceReceipt> results = [];
    List<InvoiceReceipt> invoices = await invoiceService.getData(filter);
    for(InvoiceReceipt receipt in invoices) {
      if (((partnerId != null && partnerId == receipt.partnerId) || partnerId == null) && timeFilterService.isTimeFilterd(receipt.createdAt, fromDate, toDate)) {
        List<ReceiptDetail> detailResult = [];
        for (ReceiptDetail detail in receipt.details) {
          Product product = await productService.getProduct(detail.productId);
          detail.product = product;
          detailResult.add(detail);
        }
        receipt.details = detailResult;
        Customer customer = await customerService.getCustomerByKey(
            receipt.partnerId);
        receipt.customer = customer;
        results.add(receipt);
      }
    }
    return results;
  }

  void saveReceipt(InvoiceReceipt receipt) {
    receipt.createdAt = DateTime.now();
    if (receipt.id == '') {
      this.invoiceService.saveReceipt(receipt);
    } else {
      invoiceService.updateReceipt(receipt);
    }
  }

  /// XỬ LÝ PHIẾU ///
  //tổng giá trị hiên thị, đã hoàn thành mới cộng
  num getTotalDisplayValue(String attribute, List<InvoiceReceipt> receipts) {
    return receipts.fold(
      AppNum.zero,
      (sum, receipt) {
        var value = receipt.getAttributeValue(attribute);
        return sum + (receipt.status == AppNum.two ? value : AppNum.zero);
      },
    );
  }

  //Hủy phiếu
  bool cancelReceipt(InvoiceReceipt _receipt) {
    try {
      invoiceService.removeReceipt(_receipt);
      return true;
    } catch(e) {
      return false;
    }
  }

  // Hàm thêm mới/cập nhật phiếu
  void updateReturnedStatus(InvoiceReceipt updatedItem) {
    this.invoiceService.updateReceiptReturned(updatedItem.id);
  }

  // Hàm lấy phiếu theo ID future
  Future<InvoiceReceipt?> getReceiptByIdAsync(String id) async {
    InvoiceReceipt receipt = await invoiceService.getReceiptById(id);
    List<ReceiptDetail> detailResult = [];
    for(ReceiptDetail detail in receipt.details) {
      Product product = await productService.getProduct(detail.productId);
      detail.product = product;
      detailResult.add(detail);
    }
    receipt.details = detailResult;
    Customer customer = await customerService.getCustomerByKey(receipt.partnerId);
    receipt.customer = customer;
    return receipt;
  }

  // Hàm lấy phiếu theo ID
  Future<InvoiceReceipt?> getReceiptById(String id) async {
    return await invoiceService.getReceiptById(id);
  }

  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<InvoiceReceipt>? data) => [
        for (var receipt in data ?? <InvoiceReceipt>[]) receipt.toJson1(),
      ];

  // chuyển sang danh sách object
  List<InvoiceReceipt> convertFromJSON(List<Map<String, dynamic>> json) {
    return json
        .map((receiptJson) => InvoiceReceipt.fromJson(receiptJson))
        .toList();
  }

  /// XỬ LÝ CHI TIẾT PHIẾU ///
  // kiểm tra hàng hóa đã trong phiếu kiểm chưa
  bool existDetail(InvoiceReceipt receipt, String productId) {
    return receipt.details.any((item) => item.productId == productId);
  }

  /// Hàm lấy chi tiết phiếu trong phiếu hủy xuất
  ReceiptDetail getDetailByProductId(InvoiceReceipt receipt, String productId) {
    return receipt.details.firstWhere(
      (detail) => detail.productId == productId,
      orElse: () => ReceiptDetail.empty(),
    );
  }

  /// Hàm cập nhật chi tiết phiếu trong phiếu hủy xuất
  void updateDetail(InvoiceReceipt receipt, ReceiptDetail detail) {
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
  void removeDetail(InvoiceReceipt receipt, ReceiptDetail detail) {
    receipt.details.remove(detail);
  }

  ///lọc theo thời gian
  List<InvoiceReceipt> filterReceiptsByDateRange(
      List<InvoiceReceipt> receipts, DateTime? startDate, DateTime? endDate) {
    List<InvoiceReceipt> filteredReceipts = receipts;
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
  List<InvoiceReceipt> filterReceipts(
    List<InvoiceReceipt> receipts,
    Map<String, dynamic> filters,
  ) {
    List<InvoiceReceipt> filteredReceipts = receipts;
    //bộ lọc
    if (filters.isNotEmpty) {
      final statusFilters = filters[AppAttribute.status] as Map<int, bool>;
      filteredReceipts = receipts.where((receipt) {
        return statusFilters[receipt.status] == true;
      }).toList();
    }
    return filteredReceipts;
  }


  // Hàm thêm mới/cập nhật phiếu
  void updateReceiptReturned(String id) {
    invoiceService.updateReceiptReturned(id);
  }

  ///sắp xếp
  List<InvoiceReceipt> sortReceipts(
    List<InvoiceReceipt> receipts,
    String sortOption,
      String sortAttribute
  ) {
    // Sắp xếp theo tùy chọn
    final sortingController = SortingController(convertToJSON(receipts));
    sortingController.updateSorting(sortOption, sortAttribute);

    return convertFromJSON(sortingController.currentData);
  }
}
