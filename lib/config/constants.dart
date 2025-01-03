class AppAttribute {
  static const String name = 'name';
  static const String phone = 'phone';
  static const String phoneNumber = 'phoneNumber';
  static const String quantity = 'quantity';
  static const String createdAt = 'createdAt';
  static const String note = 'note';
  static const String description = 'description';
  static const String id = 'id';
  static const String capitalPrice = 'capitalPrice';
  static const String sellingPrice = 'sellingPrice';
  static const String status = 'status';
  static const String totalAmount = 'totalAmount';
  static const String totalCapitalValue = 'totalCapitalValue';
  static const String totalSaleValue = 'totalSaleValue';
  static const String totalQuantity = 'totalQuantity';
  static const String importDue = 'importDue';
  static const String saleDue = 'saleDue';
  static const String totalPaid = 'totalPaid';
  static const String details = 'details';
  static const String product = 'product';
  static const String supplier = 'supplier';
  static const String customer = 'customer';
}

class AppString {
  ///Phương thưc thanh toán
  static const String cash = 'Tiền mặt';
  static const String bankTransfer = 'Chuyển khoản';
  static const String creditCard = 'Thẻ tín dụng';

  ///Tùy chọn săp xếp
  static const String newest = 'Mới nhất';
  static const String oldest = 'Cũ nhất';
  static const String ascValue = 'Giá trị tăng';
  static const String descValue = 'Giá trị giảm';
  static const String aZ = 'A-Z';
  static const String zA = 'Z-A';

  ///Tùy chọn hiển thị
  static const String totalSale = 'Tổng bán';
  static const String totalPurchase = 'Tổng mua';
  static const String totalRefund = 'Tổng trả';
  static const String sellingPrice = 'Giá bán';
  static const String capitalPrice = 'Giá vốn';
  static const String totalImportDue = 'Tổng nợ NCC';
  static const String totalSaleDue = 'Tổng khách nợ';
  static const String totalImportValue = 'Tổng tiền hàng'; //nhập
  static const String totalSaleValue = 'Tổng tiền hàng'; //bán
  static const String totalPaid = 'Đã thanh toán';

  ///Tùy chọn lọc thời gian
  static const String allTime = 'Toàn thời gian';
  static const String today = 'Hôm nay';
  static const String yesterday = 'Hôm qua';
  static const String last7Days = '7 ngày qua';
  static const String thisMonth = 'Tháng này';

  ///Trạng thái phiếu
  static const String completed = 'Đã hoàn thành';
  static const String temporary = 'Phiếu tạm';
  static const String canceled = 'Đã hủy';
  // //Trạng thái phiếu hoàn thành
  // static const String balanced = 'Đã cân bằng';
  // static const String received = 'Đã nhập hàng';
  // static const String returned = 'Đã trả hàng';
  static const String unknown = 'Không xác định';

  ///Label
  static const String paymentMethod = 'Phương thức thanh toán';
  static const String invoiceInfo = 'Thông tin hóa đơn';
  static const String total = 'Tổng cộng';
  static const String amountInput = 'Tiền trả';
  static const String amountPaid = 'Đã thanh toán';
  static const String amountDue = 'Còn nợ';
  static const String amount = 'Tiền hàng';
  static const String totalAmount = 'Tổng tiền hàng';

  static const String statusReceipt = 'Trạng thái phiếu';





  static const String quantity = 'Số lượng';
  static const String inventory = 'Tồn kho';
  static const String unitPrice = 'Đơn giá';
  static const String totalPrice = 'Thành tiền';

  static const String selectSupplier = 'Chọn nhà cung cấp';
  static const String selectCustomer = 'Chọn khách hàng';
  static const String retailCustomer = 'Khách lẻ';

  ///Hint
  static const String amountInputHint = 'Nhập số tiền';
  static const String searchProductHint = 'Tìm theo hàng hóa';
  static const String searchSupplierHint = 'Tìm theo nhà cung cấp';
  static const String searchCustomerHint = 'Tìm theo khách hàng';

  ///Button
  static const String saveTemporary = 'Lưu tạm';
  static const String complete = 'Hoàn thành';
  static const String cancel = 'Hủy';
  static const String confirm = 'Xác nhận';
  static const String ok = 'Ok';
  static const String reset = 'Đặt lại';
  static const String apply = 'Áp dụng';
  static const String payOffDebt = 'Thanh toán nợ';
  static const String exit = 'Thoát';
  static const String finish = 'Xong';

  ///inventory
  static const String inventoryCheckReceipt = 'Phiếu kiểm kho';
  ///export cancel
  static const String exportCancellationReceipt = 'Phiếu xuất hủy';
  ///order
  static const String order = 'Đơn đặt hàng';
  static const String searchOrder = 'Tìm kiếm đơn đặt hàng';
  static const String createOrder = 'Tạo đơn đặt hàng';
  static const String updateOrder = 'Cập nhật đơn đặt hàng';
  static const String detailOrder = 'Chi tiết đơn đặt hàng';
  static const String filterOrder = 'Bộ lọc đơn đặt hàng';
  static const String emptyOrder = 'Chưa có đơn đặt hàng';
  ///invoice
  static const String invoice = 'Hóa đơn bán hàng';
  static const String searchInvoiceReceipt = 'Tìm kiếm hóa đơn bán hàng';
  static const String createInvoiceReceipt = 'Tạo hóa đơn bán hàng';
  static const String updateInvoiceReceipt = 'Cập nhật hóa đơn bán hàng';
  static const String detailInvoiceReceipt = 'Chi tiết hóa đơn bán hàng';
  static const String filterInvoiceReceipt = 'Bộ lọc hóa đơn bán hàng';
  static const String emptyInvoiceReceipt = 'Chưa có hóa đơn bán hàng';
  ///return sale
  static const String returnInvoice= 'Trả hàng';
  static const String searchReturnInvoice = 'Tìm kiếm hóa đơn trả hàng';
  static const String createReturnInvoice = 'Tạo hóa đơn trả hàng';
  static const String updateReturnInvoice= 'Cập nhật hóa đơn trả hàng';
  static const String detailReturnInvoice= 'Chi tiết hóa đơn trả hàng';
  static const String filterReturnInvoice= 'Bộ lọc hóa đơn trả hàng';
  static const String emptyReturnInvoice = 'Chưa có hóa đơn trả hàng';
  ///import
  static const String import = 'Nhập hàng';
  static const String importReceipt = 'Phiếu nhập hàng';
  static const String importedProduct = 'Hàng nhập';
  static const String totalImportAmount = 'Tổng tiền hàng nhập';
  static const String createImportReceipt = 'Tạo phiếu nhập hàng';
  static const String updateImportReceipt = 'Cập nhật phiếu nhập hàng';
  static const String searchImportReceipt = 'Tìm kiếm phiếu nhập hàng';
  static const String detailImportReceipt = 'Chi tiết phiếu nhập hàng';
  static const String filterImportReceipt = 'Bộ lọc phiếu nhập hàng';
  static const String emptyImportReceipt = 'Chưa có phiếu nhập hàng';
  ///return import
  static const String returnImport = 'Trả hàng nhập';
  static const String returnImportReceipt = 'Phiếu trả hàng nhập';
  static const String totalReturnAmount = 'Tổng tiền hàng trả';
  static const String filterReturnImportReceipt = 'Bộ lọc phiếu trả hàng nhập';
  static const String createReturnImportReceipt = 'Tạo phiếu trả hàng nhập';
  static const String updateReturnImportReceipt = 'Cập nhật phiếu trả hàng nhập';
  static const String emptyReturnImportReceipt = 'Chưa có phiếu trả hàng nhập';
  static const String searchReturnImportReceipt =
      'Tìm kiếm phiếu trả hàng nhập';
  static const String detailReturnImportReceipt =
      'Chi tiết phiếu trả hàng nhập';



  ///Title
  static const String pay = 'Thanh toán';
  static const String product = 'Hàng hóa';
  static const String supplier = 'Nhà cung cấp';
  static const String customer = 'Khách hàng';
  static const String paymentHistory = 'Lịch sử giao dịch';

  static const String confirmTemporaryTitle = 'Xác nhận lưu tạm';
  static const String confirmCompleteTitle = 'Xác nhận hoàn thành';
  static const String confirmCancelTitle = 'Xác nhận hủy phiếu';
  static const String removeProductTitle = 'Xác nhận loại bỏ mặt hàng';

  ///Content
  static const String confirmTemporaryContent =
      'Bạn có chắc muốn tạo phiếu tạm? '
      'Giá trị của phiếu sẽ chưa được tính và phiếu có thể được chỉnh sửa.';
  static const String confirmCompleteContent =
      'Bạn có chắc muốn hoàn thành việc tạo phiếu? '
      'Phiếu sẽ được áp dụng và sẽ không thể thay đổi.';
  static const String confirmCancelContent = 'Bạn chắc chắn muốn hủy phiếu này?'
      'Phiếu sẽ không còn được hiển thị và mọi giá trị sẽ không được áp dụng';
  static const String removeProductContent = 'Bạn có chắc chắn muốn xóa mặt hàng này khỏi phiếu hiện tại không?';
  static const String emptyProductInReceipt = 'Chưa có hàng hóa trong phiếu';

  /// Thông báo Snackbar
  static const String successTemporary = 'Phiếu đã được lưu tạm thành công!';
  static const String successComplete = 'Phiếu đã hoàn thành thành công!';
  static const String successCancel = 'Phiếu đã hủy thành công!';

  static const String errorInvalidAmount = 'Vui lòng nhập số tiền hợp lệ!';
  static const String errorNoProduct = 'Vui lòng thêm hàng hoá!';
  static const String errorNoSupplier = 'Vui lòng thêm nhà cung cấp!';
  static const String errorNoCustomer = 'Vui lòng thêm khách hàng!';
  static const String errorLoadingData = 'Lỗi tải dữ liệu';
  static const String errorNonExistentReceipt = 'Phiếu không tồn tại!';
  static const String errorNonExistentOrder = 'Đơn đặt hàng không tồn tại!';

  static const String error = 'Đã xảy ra lỗi! Vui lòng thử lại sau!';

  static const String vnd = 'VND';
}

class AppNum {
  static const int zero = 0;
  static const int one = 1;
  static const int two = 2;
}

class AppPath {
  ///order
  static const String order = '/order';
  static const String orderAdd = '/order/add';
  static const String orderFilter = '/order/filter';
  ///invoice
  static const String invoice = '/invoice';
  static const String invoiceAdd = '/invoice/add';
  static const String invoiceFilter = '/invoice/filter';

  ///return invoice
  static const String returnInvoice = '/returnInvoice';
  static const String returnInvoiceAdd = '/returnInvoice/add';
  static const String returnInvoiceFilter = '/returnInvoice/filter';
  ///payment
  static const String payment = '/payment';
  static const String salePayment = '/salePayment';
  ///return import
  static const String returnImport = '/returnImport';
  static const String returnImportAdd = '/returnImport/add';
  static const String returnImportFilter = '/returnImport/filter';

  ///import
  static const String import = '/import';
  static const String importAdd = '/import/add';
  static const String importFilter = '/import/filter';

  ///supplier
  static const String supplier = '/suppliers';
  static const String supplierAdd = '/suppliers/add';
  static const String supplierFilter = '/suppliers/filter';
  static const String supplierSelection = '/supplierSelection';
  ///customer
  static const String customer = '/customers';
  static const String customerAdd = '/customers/add';
  static const String customerFilter = '/customers/filter';
  static const String customerSelection = '/customerSelection';
}
enum ReceiptType{
  invoice,
  returnInvoice,
  import,
  returnImport,
}
