import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/products/product.dart';
import 'package:sales_management_application/ec/ec_service.dart';
import 'package:sales_management_application/inventory_check/inventory_service.dart';
import 'package:sales_management_application/products/product_service.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';
import 'package:sales_management_application/search/search_note_screen.dart';
import 'package:sales_management_application/views/widgets/cards/export_cancel_card.dart';

import '../export_receipt.dart';
import '../view/export_receipt_detail.dart';
import '../ec_filter.dart';

class ExportCancellationController {

  ExportCancelService ecService = ExportCancelService();
  InventoryService inventoryService = InventoryService();
  ProductService productService = ProductService();
  TimeFilterService timeFilterService = TimeFilterService();
  List<ExportCancellationReceipt> data = [  ];
  
  // Hàm lấy dữ liệu
  Future<List<ExportCancellationReceipt>> getData(EcFilter filter,  String selectedOption, DateTime? fromDate, DateTime? toDate) async {
    List<ExportCancellationReceipt> receipts = await ecService.getData(filter);
    List<ExportCancellationReceipt> results = [];
    for(ExportCancellationReceipt i in receipts) {
      if (timeFilterService.isTimeFilterd(i.createdAt, fromDate, toDate)) {
        ExportCancellationReceipt t = await getDetail(i);
        results.add(t);
      }
    }
    return results;
  }

  Future<ExportCancellationReceipt> getDetail(ExportCancellationReceipt receipt) async {
    List<ExportCancellationReceiptDetail> details = [];
    for(ExportCancellationReceiptDetail i in receipt.details) {
      ExportCancellationReceiptDetail t = ExportCancellationReceiptDetail.empty();
      Product product = await productService.getProduct(i.productId);
      t.product = product;
      t.productId = i.productId;
      t.cancelledQuantity = i.cancelledQuantity;
      details.add(t);
    }
    receipt.details = details;
    return receipt;
  }

  void save(ExportCancellationReceipt receipt) {
    ecService.save(receipt, 'ExportCancellationReceipt');
    // if (receipt.status == 2) {
    //   for(ExportCancellationReceiptDetail i in receipt.details) {
    //     Product product = await productService.getProduct(i.productId);
    //     inventoryService.updateInventory(product, i.cancelledQuantity);
    //   }
    // }
  }

  void delete(ExportCancellationReceipt receipt) {
    ecService.delete(receipt);
  }

  //Hàm lấy tất cả phiếu chưa hủy
  List<ExportCancellationReceipt> getUncancelledReceipts() {
    return data.where((receipt) => receipt.status != 0).toList();
  }

  // Hàm lấy phiếu theo ID future
  Future<ExportCancellationReceipt?> getReceiptByIdAsync(int id) async {
    return data.firstWhere(
      (receipt) => receipt.id == id,
      orElse: () => ExportCancellationReceipt.empty(),
    );
  }
  // Hàm lấy phiếu theo ID
  ExportCancellationReceipt? getReceiptById(int id) {
    return data.firstWhere(
      (receipt) => receipt.id == id,
      orElse: () => ExportCancellationReceipt.empty(),
    );
  }

  // Hàm xóa phiếu
  void deleteReceipt(int id) {
    data.removeWhere((receipt) => receipt.id == id);
  }

  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<ExportCancellationReceipt> data) {
    return data.map((i) => i.toJSON1()).toList();
  }

  // kiểm tra hàng hóa đã trong phiếu kiểm chưa
  bool existDetail(ExportCancellationReceipt receipt, String productId) {
    return receipt.details.any((item) => item.product!.id == productId);
  }
  /// Hàm lấy chi tiết phiếu trong phiếu hủy xuất
  ExportCancellationReceiptDetail getDetailByProductId(
      ExportCancellationReceipt receipt, String productId) {
    return receipt.details.firstWhere(
      (detail) => detail.product!.id == productId,
      orElse: () => ExportCancellationReceiptDetail.empty(),
    );
  }


  /// Hàm cập nhật chi tiết phiếu trong phiếu hủy xuất
  void updateDetail(ExportCancellationReceipt receipt, ExportCancellationReceiptDetail detail) {
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
  void removeDetail(ExportCancellationReceipt receipt, ExportCancellationReceiptDetail detail){
    receipt.details.remove(detail);
  }


  /// Hàm mở trang tìm kiếm phiếu 
  Future<void> openSearchScreen(BuildContext context, List<ExportCancellationReceipt> data) async {
    for(var i in data) {
      print(i.toJSON2());
    }
    List<Map<String, dynamic>> searchData = data.map((i) => i.toJSON1()).toList();
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
          searchData: searchData,
          dataType: 'exportCancellation',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            context.pop();
          },
          title: 'Tìm kiếm phiếu hủy xuất',
          itemBuilder: (item) {
            ExportCancellationReceipt receipt = ExportCancellationReceipt.fromJSON(item);
            return ExportCancellationReceiptCard(
              receipt: receipt, //chuyển về object
              onTap: (id) => context.push('/ec/${receipt.id}', extra: [receipt.id, receipt]),
            );
          },
        ),
      ),
    );
  }

  List<ExportCancellationReceipt> convertFromJSON(List<Map<String, dynamic>> json) {
    return json
          .map((receiptJson) => ExportCancellationReceipt.fromJSON(receiptJson))
        .toList();
  }
}