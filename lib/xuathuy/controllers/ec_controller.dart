import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/models/product.dart';
import 'package:sales_management_application/views/widgets/search_bars/search_note_screen.dart';
import 'package:sales_management_application/xuathuy/models/ec_receipt.dart';
import 'package:sales_management_application/xuathuy/models/ec_receipt_detail.dart';
import 'package:sales_management_application/xuathuy/views/widgets/cards/ec_card.dart';

class ExportCancellationController {
  
  
  /// DỮ LIỆU ///
  List<ExportCancellationReceipt> data = [
    ExportCancellationReceipt(
      id: '1',
      products: [
        ExportCancellationReceiptDetail(
          productId: '2',
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
          cancelledQuantity: 9,
        ),
      ],
      status: 1,
      createdAt: DateTime.now(),
    ),
    ExportCancellationReceipt(
      id: '2',
      products: [
        ExportCancellationReceiptDetail(
          productId: '4',
          product: Product(
            id: "4",
            name: 'Giò hổ Châu Phi 4',
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
          cancelledQuantity: 2,
        ),
        ExportCancellationReceiptDetail(
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
          cancelledQuantity: 20, productId: '2',
        ),
      ],
      status: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ExportCancellationReceipt(
      id: '3',
      products: [
        ExportCancellationReceiptDetail(
          productId: '3',
          product: Product(
            id: "3",
            name: 'Giò hổ Châu Phi 3',
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
          cancelledQuantity: 2,
        ),
        ExportCancellationReceiptDetail(
          productId: '2',
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
          cancelledQuantity: 20,
        ),
      ],
      status: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
  
  // Hàm lấy dữ liệu
  Future<List<ExportCancellationReceipt>> getData() async {
    //lấy data từ db lưu vào biến data
    return data;
  }

  /// XỬ LÝ PHIẾU ///
 // Hàm thêm mới/cập nhật phiếu 
  void updateReceipt({
    required ExportCancellationReceipt updatedItem,
  }) {
    final index = data.indexWhere((receipt) => receipt.id == updatedItem.id);
    if (index == -1) {
      updatedItem.id = (data.length + 1).toString(); // Giả định ID tự tăng
      data.add(updatedItem);
    } else {
      data[index] = updatedItem;
    }
  }
  //Hàm lấy tất cả phiếu chưa hủy
  List<ExportCancellationReceipt> getUncancelledReceipts() {
    return data.where((receipt) => receipt.status != 0).toList();
  }

  // Hàm lấy phiếu theo ID future
  Future<ExportCancellationReceipt?> getReceiptByIdAsync(String id) async {
    return data.firstWhere(
      (receipt) => receipt.id == id,
      orElse: () => ExportCancellationReceipt.empty(),
    );
  }
  // Hàm lấy phiếu theo ID
  ExportCancellationReceipt? getReceiptById(String id) {
    return data.firstWhere(
      (receipt) => receipt.id == id,
      orElse: () => ExportCancellationReceipt.empty(),
    );
  }

  // Hàm xóa phiếu
  void deleteReceipt(String id) {
    data.removeWhere((receipt) => receipt.id == id);
  }

  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<ExportCancellationReceipt>? data) => [
        for (var receipt in data ?? <ExportCancellationReceipt>[]) receipt.toJSON1(),
      ];

  // chuyển sang danh sách object
  List<ExportCancellationReceipt> convertFromJSON(List<Map<String, dynamic>> json) {
    return json
        .map((receiptJson) => ExportCancellationReceipt.fromJSON(receiptJson))
        .toList();
  }

  /// XỬ LÝ CHI TIẾT PHIẾU ///
  // kiểm tra hàng hóa đã trong phiếu kiểm chưa
  bool existDetail(ExportCancellationReceipt receipt, String productId) {
    return receipt.products.any((item) => item.productId == productId);
  }
  /// Hàm lấy chi tiết phiếu trong phiếu hủy xuất
  ExportCancellationReceiptDetail getDetailByProductId(
      ExportCancellationReceipt receipt, String productId) {
    return receipt.products.firstWhere(
      (detail) => detail.productId == productId,
      orElse: () => ExportCancellationReceiptDetail.empty(),
    );
  }


  /// Hàm cập nhật chi tiết phiếu trong phiếu hủy xuất
  void updateDetail(ExportCancellationReceipt receipt, ExportCancellationReceiptDetail detail) {
    final detailIndex = receipt.products.indexWhere(
      (item) => item.productId == detail.productId,
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
  void removeDetail(ExportCancellationReceipt receipt, ExportCancellationReceiptDetail detail){
    receipt.products.remove(detail);
  }


  /// Hàm mở trang tìm kiếm phiếu 
  Future<void> openSearchScreen(BuildContext context) async {
    final searchData = convertToJSON(data); //chuyển sang map để tìm kiếm
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
          searchData: searchData,
          dataType: 'exportCancellation',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            context.pop();
          },
          title: 'Tìm kiếm phiếu hủy xuất',
          itemBuilder: (item) {
            return ExportCancellationReceiptCard(
              receipt:
                  ExportCancellationReceipt.fromJSON(item), //chuyển về object
              onTap: (id) => context.push('/export_cancellation/$id'),
            );
          },
        ),
      ),
    );
  }

  
}