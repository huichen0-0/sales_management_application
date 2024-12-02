import 'package:sales_management_application/models/inventory_note_detail.dart';
import 'package:sales_management_application/models/product.dart';

class InventoryNote {
  // Đơn kiểm kho
  int? _id; // Mã phiếu kiểm kho
  int? _status; // Trạng thái phiếu kiểm kho
  DateTime? _createdAt; // Ngày tạo phiếu kiểm kho
  List<InventoryNoteDetail>
      _products; // Danh sách sản phẩm trong phiếu kiểm kho

  // Constructor
  InventoryNote({
    int? id,
    int? status,
    DateTime? createdAt,
    List<InventoryNoteDetail>? products,
  })  : _id = id,
        _status = status,
        _createdAt = createdAt,
        _products = products ?? [];

  // Getter và Setter
  int? get id => _id;

  set id(int? value) => _id = value;

  int? get status => _status;

  set status(int? value) => _status = value;

  DateTime? get createdAt => _createdAt;

  set createdAt(DateTime? value) => _createdAt = value;

  List<InventoryNoteDetail> get products => _products;

  set products(List<InventoryNoteDetail> value) => _products = value;

  // Tính toán các thuộc tính tổng hợp
  num get totalStockQuantity {
    return _products.fold(0, (sum, product) => sum + (product.stockQuantity));
  }

  num get totalMatchedQuantity {
    return _products.fold(0, (sum, product) => sum + (product.matchedQuantity));
  }

  // tổng lệch
  num get totalQuantityDifference {
    return _products.fold(
        0, (sum, product) => sum + (product.quantityDifference));
  }

  // tôổng giá trị thực
  num get totalValueMatched {
    return _products.fold(0, (sum, product) => sum + (product.matchedValue));
  }
  //tổng hàng hóa lệch
  num get totalProductDiv{
    return _products.fold(
      0,
          (sum, product) =>
      sum + (product.quantityDifference != 0 ? 1 : 0),
    );
  }
///lệch tăng
  List<num> get totalIncrements {
    num totalDeviationInc = 0;
    num totalProductInc = 0;
    num totalQuantityInc = 0;

    for (var product in _products) {
      if (product.quantityDifference > 0) {
        totalDeviationInc += product.differenceValue;
        totalProductInc += 1;
        totalQuantityInc += product.matchedQuantity;
      }
    }

    return [totalDeviationInc, totalProductInc, totalQuantityInc];
  }
/// lệch giảm
  List<num> get totalDecrements {
    num totalDeviationDec = 0; // Tổng lệch giảm
    num totalProductDec = 0;   // Tổng hàng hóa lệch giảm
    num totalQuantityDec = 0;  // Tổng số lượng hàng hóa lệch giảm

    for (var product in _products) {
      if (product.quantityDifference < 0) {
        totalDeviationDec += product.differenceValue;
        totalProductDec += 1;
        totalQuantityDec += product.matchedQuantity;
      }
    }

    return [totalDeviationDec,totalProductDec,totalQuantityDec];
  }


  // kiểm tra hàng hóa đã trong phiếu kiểm chưa
  bool isInInventoryNote(Product productToCheck) {
    return _products.any((item) => item.product.id == productToCheck.id);
  }

  //lấy phiếu kiểm chi tiết (hàng hóa kiểm) trong phiếu kiểm
  InventoryNoteDetail getInventoryNoteDetailByProduct(Product productToFind) {
    return _products.firstWhere(
      (item) => item.product.id == productToFind.id,
    );
  }

  void updateInventoryNoteDetail(InventoryNoteDetail item) {
    // Tìm InventoryNoteDetail theo Product
    InventoryNoteDetail inventoryNoteDetail =
        getInventoryNoteDetailByProduct(item.product);

    //cập nhật giá trị
    inventoryNoteDetail.matchedQuantity = item.matchedQuantity;
  }

  // Lấy nhãn trạng thái
  String getStatusLabel() {
    switch (_status) {
      case 2:
        return 'Đã cân bằng';
      case 1:
        return 'Phiếu tạm';
      case 0:
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  // Hàm toJSON
  Map<String, dynamic> toJSON() {
    return {
      'id': _id,
      'status': _status,
      'createdAt': _createdAt, // Chuyển DateTime thành chuỗi ISO 8601
      'products': _products.map((product) => product.toJSON()).toList(),
    };
  }

  factory InventoryNote.fromJSON(Map<String, dynamic> json) {
    return InventoryNote(
      id: json['id'],
      status: json['status'],
      createdAt: json['createdAt'],
      products: (json['products'] as List<dynamic>)
          .map((product) => InventoryNoteDetail.fromJSON(product))
          .toList(),
    );
  }
}
