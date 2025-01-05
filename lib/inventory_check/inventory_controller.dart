import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';
import 'package:sales_management_application/views/widgets/cards/inventory_receipt_card.dart';
import 'package:sales_management_application/views/widgets/search_bars/search_note_screen.dart';
import 'inventory_check_detail.dart';
import '../products/product.dart';
import 'inventory_check_receipt.dart';
import 'inventory_filter.dart';
import 'inventory_service.dart';
import '../products/product_service.dart';

class InventoryController {

  InventoryService inventoryService = InventoryService();
  ProductService productService = ProductService();
  TimeFilterService timeFilterService = TimeFilterService();
  List<InventoryCheckReceipt> data = [  ];

  // Hàm lấy dữ liệu
  Future<List<InventoryCheckReceipt>> getData(InventoryFilter filter, DateTime? fromDate, DateTime? toDate) async {
    List<InventoryCheckReceipt> receipts = await inventoryService.getData(filter);
    List<InventoryCheckReceipt> results = [];
    for(InventoryCheckReceipt i in receipts) {
      if (timeFilterService.isTimeFilterd(i.createdAt, fromDate, toDate)) {
        InventoryCheckReceipt t = await getDetail(i);
        results.add(t);
      }
    }
    return results;
  }

  Future<InventoryCheckReceipt> getDetail(InventoryCheckReceipt receipt) async {
    List<InventoryCheckReceiptDetail> details = [];
    for(InventoryCheckReceiptDetail i in receipt.details) {
      InventoryCheckReceiptDetail t = InventoryCheckReceiptDetail.empty();
      Product product = await productService.getProduct(i.productId);
      t.product = product;
      t.productId = i.productId;
      t.matchedQuantity = i.matchedQuantity;
      details.add(t);
    }
    receipt.details = details;
    return receipt;
  }

  void save(InventoryCheckReceipt receipt) {
    inventoryService.save(receipt, 'InventoryCheck');
    // if (receipt.status == 2) {
    //   for(InventoryCheckReceiptDetail i in receipt.details) {
    //     Product product = await productService.getProduct(i.productId);
    //     inventoryService.updateInventory(product, i.matchedQuantity);
    //   }
    // }
  }

  void delete(InventoryCheckReceipt receipt) {
    inventoryService.delete(receipt);
  }

  //Hàm lấy tất cả phiếu chưa hủy
  List<InventoryCheckReceipt> getUncancelledReceipts() {
    return data.where((receipt) => receipt.status != 0).toList();
  }

  // Hàm lấy phiếu theo ID future
  Future<InventoryCheckReceipt?> getReceiptByIdAsync(int id) async {
    return data.firstWhere(
          (receipt) => receipt.id == id,
      orElse: () => InventoryCheckReceipt.empty(),
    );
  }
  // Hàm lấy phiếu theo ID
  InventoryCheckReceipt? getReceiptById(int id) {
    return data.firstWhere(
          (receipt) => receipt.id == id,
      orElse: () => InventoryCheckReceipt.empty(),
    );
  }

  // Hàm xóa phiếu
  void deleteReceipt(int id) {
    data.removeWhere((receipt) => receipt.id == id);
  }

  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<InventoryCheckReceipt>? data) => [
    for (var receipt in data ?? <InventoryCheckReceipt>[]) receipt.toJSON1(),
  ];

  // chuyển sang danh sách object
  List<InventoryCheckReceipt> convertFromJSON(List<Map<String, dynamic>> json) {
    return json
        .map((receiptJson) => InventoryCheckReceipt.fromJSON(receiptJson))
        .toList();
  }

  /// XỬ LÝ CHI TIẾT PHIẾU ///
  // kiểm tra hàng hóa đã trong phiếu kiểm chưa
  bool existDetail(InventoryCheckReceipt receipt, String productId) {
    return receipt.details.any((item) => item.product!.id == productId);
  }
  /// Hàm lấy chi tiết phiếu trong phiếu hủy xuất
  InventoryCheckReceiptDetail getDetailByProductId(
      InventoryCheckReceipt receipt, String productId) {
    return receipt.details.firstWhere(
          (detail) => detail.product!.id == productId,
      orElse: () => InventoryCheckReceiptDetail.empty(),
    );
  }


  /// Hàm cập nhật chi tiết phiếu trong phiếu hủy xuất
  void updateDetail(InventoryCheckReceipt receipt, InventoryCheckReceiptDetail detail) {
    final detailIndex = receipt.details.indexWhere(
          (item) => item.product!.id == detail.product!.id,
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
  void removeDetail(InventoryCheckReceipt receipt, InventoryCheckReceiptDetail detail){
    receipt.details.remove(detail);
  }

  // Hàm mở trang tìm kiếm phiếu kiểm
  Future<void> openSearchScreen(BuildContext context, List<InventoryCheckReceipt> receipts) async {
    List<Map<String, dynamic>> searchData = receipts.map((i) => i.toJSON1()).toList();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchNoteScreen(
          searchOptions: const [
            {
              'searchKey': 'details',
              'tag': 'Hàng hóa',
              'hint': 'Tìm theo hàng hóa'
            },
          ],
          //chuyển sang map để tìm kiếm
          searchData: searchData,
          dataType: 'inventory',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: 'Tìm kiếm phiếu kiểm kho',
          itemBuilder: (item) {
            return InventoryCheckReceiptCard(
              receipt: InventoryCheckReceipt.fromJSON(item), //chuyển về object
              onTap: (id) => context.push('/inventory/$id', extra: [id, InventoryCheckReceipt.fromJSON(item)]),
            );
          },
        ),
      ),
    );
  }
}
