import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/kiemkho/models/ic_receipt.dart';
import 'package:sales_management_application/models/product.dart';
import 'package:sales_management_application/kiemkho/views/widgets/cards/ic_receipt_card.dart';
import 'package:sales_management_application/views/widgets/search_bars/search_note_screen.dart';
import '../models/ic_receipt_detail.dart';

class InventoryController {
  // Danh sách sản phẩm
  List<InventoryCheckReceipt> data = [
    InventoryCheckReceipt(
      id: 1,
      products: [
        InventoryCheckReceiptDetail(
          product: Product(
            id: "2",
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
          matchedQuantity: 99,
        ),
      ],
      status: 2,
      createdAt: DateTime.now(),
    ),
    InventoryCheckReceipt(
      id: 2,
      products: [
        InventoryCheckReceiptDetail(
          product: Product(
            id: "2",
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
          matchedQuantity: 209,
        ),
        InventoryCheckReceiptDetail(
          product: Product(
            id: "2",
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
          matchedQuantity: 200,
        ),
      ],
      status: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Hàm lấy dữ liệu
  Future<List<InventoryCheckReceipt>> getData() async {
    //lấy data từ db lưu vào biến data
    return data;
  }

  /// XỬ LÝ PHIẾU ///
  // Hàm thêm mới/cập nhật phiếu 
  void updateReceipt({
    required InventoryCheckReceipt updatedItem,
  }) {
    final index = data.indexWhere((receipt) => receipt.id == updatedItem.id);
    if (index == -1) {
      updatedItem.id = data.length + 1; // Giả định ID tự tăng
      data.add(updatedItem);
    } else {
      data[index] = updatedItem;
    }
  }
  //Hàm lấy tất cả phiếu chưa hủy
  List<InventoryCheckReceipt> getUncancelledReceipts() {
    return data.where((receipt) => receipt.status != 0).toList();
  }

  // Hàm lấy phiếu theo ID future
  Future<InventoryCheckReceipt?> getReceiptByIdAsync(int id) async {
    return data.firstWhere(
          (receipt) => receipt.id == id,
      orElse: () => InventoryCheckReceipt(id: -1),
    );
  }
  // Hàm lấy phiếu theo ID
  InventoryCheckReceipt? getReceiptById(int id) {
    return data.firstWhere(
          (receipt) => receipt.id == id,
      orElse: () => InventoryCheckReceipt(id: -1),
    );
  }

  // Hàm xóa phiếu
  void deleteReceipt(int id) {
    data.removeWhere((receipt) => receipt.id == id);
  }

  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<InventoryCheckReceipt>? data) => [
    for (var receipt in data ?? <InventoryCheckReceipt>[]) receipt.toJSON(),
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
    return receipt.products.any((item) => item.product.id == productId);
  }
  /// Hàm lấy chi tiết phiếu trong phiếu hủy xuất
  InventoryCheckReceiptDetail getDetailByProductId(
      InventoryCheckReceipt receipt, String productId) {
    return receipt.products.firstWhere(
          (detail) => detail.product.id == productId,
      orElse: () => InventoryCheckReceiptDetail(
        product: Product.empty(),
        matchedQuantity: 0,
      ),
    );
  }


  /// Hàm cập nhật chi tiết phiếu trong phiếu hủy xuất
  void updateDetail(InventoryCheckReceipt receipt, InventoryCheckReceiptDetail detail) {
    final detailIndex = receipt.products.indexWhere(
          (item) => item.product.id == detail.product.id,
    );

    if (detailIndex != -1) {
      // Cập nhật chi tiết phiếu
      receipt.products[detailIndex] = detail;
    } else {
      // Thêm chi tiết phiếu mới
      receipt.products.add(detail);
    }
  }

  //Hàm xóa chi tiết phiếu ra khỏi phiếu
  void removeDetail(InventoryCheckReceipt receipt, InventoryCheckReceiptDetail detail){
    receipt.products.remove(detail);
  }

  // Hàm mở trang tìm kiếm phiếu kiểm
  Future<void> openSearchScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchNoteScreen(
          searchOptions: const [
            {
              'searchKey': 'products',
              'tag': 'Hàng hóa',
              'hint': 'Tìm theo hàng hóa'
            },
          ],
          //chuyển sang map để tìm kiếm
          searchData: convertToJSON(data),
          dataType: 'inventory',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: 'Tìm kiếm phiếu kiểm kho',
          itemBuilder: (item) {
            return InventoryCheckReceiptCard(
              receipt:
                  InventoryCheckReceipt.fromJSON(item), //chuyển về object
              onTap: (id) => context.push('/inventory/$id'),
            );
          },
        ),
      ),
    );
  }
}
