import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/models/inventory_note.dart';
import 'package:sales_management_application/models/inventory_note_detail.dart';
import 'package:sales_management_application/models/product.dart';
import 'package:sales_management_application/views/widgets/cards/inventory_note_card.dart';
import 'package:sales_management_application/views/widgets/search_bars/search_note_screen.dart';

class InventoryController {
  // Danh sách sản phẩm
  List<InventoryNote> items = [
    InventoryNote(
      id: 1,
      products: [
        InventoryNoteDetail(
          product: Product(
            id: 1,
            name: 'Giò heo',
            capitalPrice: 100000,
            sellingPrice: 200000,
            quantity: 100,
          ),
          matchedQuantity: 99,
        ),
      ],
      status: 2,
      createdAt: DateTime.now(),
    ),
    InventoryNote(
      id: 2,
      products: [
        InventoryNoteDetail(
          product: Product(
            id: 2,
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
            isActived: true,
            imageUrl: 'image',
            createdAt: DateTime.now(),
          ),
          matchedQuantity: 209,
        ),
        InventoryNoteDetail(
          product: Product(
            id: 3,
            name: 'Giò gà Ấn Độ',
            capitalPrice: 200000,
            sellingPrice: 500000,
            quantity: 200,
          ),
          matchedQuantity: 200,
        ),
      ],
      status: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];


  // Hàm lấy dữ liệu kiểm kho
  Future<void> getData() async {
    try {
      print('Lấy dữ liệu thành công');
    } catch (e) {
      print('Lỗi khi lấy dữ liệu kiểm kho: $e');
    }
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
          searchData: getJSON(),
          dataType: 'inventory',
          onCancel: () {
            // Hủy tìm kiếm và đóng trang tìm kiếm
            Navigator.pop(context);
          },
          title: 'Tìm kiếm phiếu kiểm kho',
          itemBuilder: (item) {
            return InventoryNoteCard(
              inventoryNote: InventoryNote.fromJSON(item), //chuyển về object
              onTap: (id) => context.push('/inventory/$id'),
            );
          },
        ),
      ),
    );
  }

  // Hàm thêm mới/cập nhật phiếu kiểm kho
  Future<void> updateInventoryNote({
    required InventoryNote newNote,
    required int status,
  }) async {
    try {
      newNote.status = status;
      if (newNote.id == null) {
        // Tạo mới
        newNote.id = items.length + 1; // Giả định ID tự tăng
        items.add(newNote);
      } else {
        // Cập nhật
        final index =
            items.indexWhere((note) => note.id == newNote.id);
        if (index != -1) {
          items[index] = newNote;
        }
      }
      print('Lưu phiếu kiểm kho thành công');
    } catch (e) {
      print('Lỗi khi lưu phiếu kiểm kho: $e');
    }
  }

  /// Hàm lấy InventoryNote theo ID
  InventoryNote? getInventoryNoteById(int id) {
    try {
      final note = items.firstWhere(
        (note) => note.id == id,
      );

      return note;
    } catch (e) {
      print('Lỗi khi tìm kiếm InventoryNote: $e');
      return null;
    }
  }
  /// lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> getJSON(){
    return items.map((note) => note.toJSON()).toList();
  }
  ///chuyển sang danh sách object
  List<InventoryNote> toObjects(List<Map<String, dynamic>> json){
    return json
        .map((noteJson) => InventoryNote.fromJSON(noteJson))
        .toList();
  }
}
