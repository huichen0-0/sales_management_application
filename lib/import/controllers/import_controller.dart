import '../../controllers/sorting_controller.dart';
import '../../models/receipt_detail.dart';
import '/payment/model/payment.dart';
import '../models/import_receipt.dart';
import '../../models/supplier.dart';
import '/models/product.dart';

class ImportController {
  //lấy dữ liệu từ db, key gán vào id
  List<ImportReceipt> data = [
    ImportReceipt(
      id: 'id-phieu-1',
      partnerId: 'id-ncc-1',
      supplier: Supplier(
        id: 'id-ncc-1',
        amount: 0,
        name: 'Anh A',
        address: '',
        isActive: true,
        isDeleted: false,
        phone: '0111111111',
        email: '',
        note: '',
        uid: '',
      ),
      details: [
        ReceiptDetail(
          productId: "25",
          product: Product(
            id: "25",
            name: 'Giò hổ Châu Phi',
            barcode: '9890892083',
            unit: 'Kg',
            capitalPrice: 200000,
            sellingPrice: 500000,
            quantity: 200,
            minLimit: 10,
            maxLimit: 10000,
            description: 'Mô tả',
            notes: 'Ghi chú',
            isActive: true,
            imageUrl: 'image',
            createdAt: DateTime.now(),
          ),
          quantity: 10,
        ),
      ],
      payments: [
        Payment(amount: 100000, method: 'Tiền mặt', createdAt: DateTime.now()),
      ],
      createdAt: DateTime.now(),
      status: 1,
      //đã hoàn thành
      returned: false,
    ),
    ImportReceipt(
      id: 'id-phieu-2',
      partnerId: 'id-ncc-1',
      supplier: Supplier(
        id: 'id-ncc-1',
        amount: 0,
        name: 'Anh A',
        address: '',
        isActive: true,
        isDeleted: false,
        phone: '0111111111',
        email: '',
        note: '',
        uid: '',
      ),
      details: [
        ReceiptDetail(
          productId: "21",
          product: Product(
            id: "21",
            name: 'Giò hổ Châu Phi',
            barcode: '9890892083',
            unit: 'Kg',
            capitalPrice: 200000,
            sellingPrice: 500000,
            quantity: 200,
            minLimit: 10,
            maxLimit: 10000,
            description: 'Mô tả',
            notes: 'Ghi chú',
            isActive: true,
            imageUrl: 'image',
            createdAt: DateTime.now(),
          ),
          quantity: 20,
        ),
        ReceiptDetail(
          productId: '20',
          product: Product(
            id: "20",
            name: 'Giò hổ Châu Phi',
            barcode: '9890892083',
            unit: 'Kg',
            capitalPrice: 200000,
            sellingPrice: 500000,
            quantity: 200,
            minLimit: 10,
            maxLimit: 10000,
            description: 'Mô tả',
            notes: 'Ghi chú',
            isActive: true,
            imageUrl: 'image',
            createdAt: DateTime.now(),
          ),
          quantity: 20,
        ),
      ],
      payments: [
        Payment(
            amount: 100000, method: 'Chuyển khoản', createdAt: DateTime.now()),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: 3,
      //đã hoàn thành
      returned: false,
    ),
  ];

  // Hàm lấy dữ liệu
  Future<List<ImportReceipt>> getData() async {
    //lấy data từ db lưu vào biến data
    return data;
  }

  /// XỬ LÝ PHIẾU ///
  //tổng giá trị hiên thị, đã hoàn thành mới cộng
  num getTotalDisplayValue(String attribute) {
    return data.fold(
      0,
      (sum, receipt) {
        var value = receipt.getAttributeValue(attribute);
        return sum + (receipt.status == 3 ? value : 0);
      },
    );
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
  ImportReceipt? getReceiptById(String id) {
    return data.firstWhere(
      (receipt) => receipt.id == id,
      orElse: () => ImportReceipt.empty(),
    );
  }

  // Hàm xóa phiếu
  void deleteReceipt(String id) {
    data.removeWhere((receipt) => receipt.id == id);
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

  List<ImportReceipt> filterAndSortReceipts(
      List<ImportReceipt> receipts,
      Map<String, dynamic> filters,
      DateTime? startDate,
      DateTime? endDate,
      String sortOption,) {
    List<ImportReceipt> filteredReceipts = receipts;

    // Lọc theo khoảng thời gian
    if (startDate != null) {
      filteredReceipts = filterReceiptsByDateRange(
          filteredReceipts, startDate, endDate);
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

  bool isFiltered() {
    print('Dữ liệu đã lọc!');
    return true;
  }

  bool isBelonged() {
    print('Data của người dùng!');
    return true;
  }

  List<ImportReceipt> filterReceiptsByDateRange(
      List<ImportReceipt> receipts, DateTime startDate, DateTime? endDate) {
    return endDate != null
        ? receipts.where((receipt) {
            return receipt.createdAt.isAfter(startDate) &&
                receipt.createdAt.isBefore(endDate);
          }).toList()
        : receipts.where((receipt) {
            return receipt.createdAt.isAfter(startDate);
          }).toList();
  }
}
