import '../../inventory_check/inventory_check_detail.dart';

class InventoryCheckReceipt {
  // Đơn kiểm kho
  String id; // Mã phiếu kiểm kho
  int? status; // Trạng thái phiếu kiểm kho
  DateTime createdAt; // Ngày tạo phiếu kiểm kho
  List<InventoryCheckReceiptDetail> details; // Danh sách sản phẩm trong phiếu kiểm kho
  String? uid;

  // Constructor
  InventoryCheckReceipt({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.details,
    required this.uid,
  });

  InventoryCheckReceipt.empty()
      : id = '',
        status = 1,
        createdAt = DateTime.now(),
        details = [],
        uid = '';

   // Tính toán các thuộc tính tổng hợp
  num get totalStockQuantity {
    return details.fold(0, (sum, product) => sum + (product.stockQuantity));
  }

  num get totalMatchedQuantity {
    return details.fold(0, (sum, product) => sum + (product.matchedQuantity));
  }

  // tổng lệch
  num get totalQuantityDifference {
    return details.fold(
        0, (sum, product) => sum + (product.quantityDifference));
  }

  // tôổng giá trị thực
  num get totalValueMatched {
    return details.fold(0, (sum, product) => sum + (product.matchedValue));
  }

  //tổng hàng hóa lệch
  num get totalProductDiv {
    return details.fold(
      0,
      (sum, product) => sum + (product.quantityDifference != 0 ? 1 : 0),
    );
  }

  ///lệch tăng
  List<num> get totalIncrements {
    num totalDeviationInc = 0;
    num totalProductInc = 0;
    num totalQuantityInc = 0;

    for (var product in details) {
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
    num totalProductDec = 0; // Tổng hàng hóa lệch giảm
    num totalQuantityDec = 0; // Tổng số lượng hàng hóa lệch giảm

    for (var product in details) {
      if (product.quantityDifference < 0) {
        totalDeviationDec += product.differenceValue;
        totalProductDec += 1;
        totalQuantityDec += product.matchedQuantity;
      }
    }

    return [totalDeviationDec, totalProductDec, totalQuantityDec];
  }

  // Hàm toJSON
  Map<String, dynamic> toJSON1() {
    return {
      'id': id,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'details': details.map((product) => product.toJSON1()).toList(),
      'uid': uid
    };
  }

  // Hàm toJSON insert db
  Map<String, dynamic> toJSON2() {
    return {
      'id': id,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'details': details.map((product) => product.toJSON2()).toList(),
      'uid': uid
    };
  }

  factory InventoryCheckReceipt.fromJSON(Map<dynamic, dynamic> json) {
    return InventoryCheckReceipt(
        id: json['id'],
        status: json['status'],
        details: (json['details'] as List<Object?>)
            .map((i) {
          InventoryCheckReceiptDetail result = InventoryCheckReceiptDetail.fromJSON(Map<dynamic, dynamic>.from(i as Map));
          return result;
        }).toList(),
        createdAt: DateTime.parse(json['createdAt']),
        uid: json['uid']
    );
  }
}
