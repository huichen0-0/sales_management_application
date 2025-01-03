import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/products/product.dart';
import 'package:sales_management_application/inventory_check/inventory_filter.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';

import 'inventory_check_receipt.dart';

class InventoryService {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void save(InventoryCheckReceipt receipt, String path) {
    receipt.createdAt = DateTime.now();
    if (receipt.uid == null || receipt.uid!.isEmpty) {
      receipt.uid = _auth.currentUser!.uid;
      firebaseService.insertData('InventoryCheck', receipt.toJSON2());
    } else {
      firebaseService.updateData('InventoryCheck', receipt.id, receipt.toJSON2());
    }
  }

  Future<List<InventoryCheckReceipt>> getData(InventoryFilter filter) async {
    List<InventoryCheckReceipt> ecReceipts = [];
    Map<String, Object> result = await firebaseService.readData("InventoryCheck");
    result.forEach((key, value) {
      InventoryCheckReceipt mapValue = InventoryCheckReceipt.fromJSON(Map<dynamic, dynamic>.from(value as Map));
      mapValue.id = key;
      if (isFilterd(mapValue, filter) && isBelonged(mapValue, _auth.currentUser!.uid)) {
        ecReceipts.add(mapValue);
      }
    });
    return ecReceipts;
  }

  void delete(InventoryCheckReceipt receipt) {
    firebaseService.delete('InventoryCheck', receipt.id);
  }

  bool isFilterd(InventoryCheckReceipt mapValue, InventoryFilter filter) {
    if (filter.isTemp == true && filter.isBalanced == false && mapValue.status == 3) {
      return false;
    }
    if (filter.isTemp == false && filter.isBalanced == true && mapValue.status == 1) {
      return false;
    }
    if (filter.isTemp == false && filter.isBalanced == false) {
      return false;
    }
    return true;
  }

  bool isBelonged(InventoryCheckReceipt mapValue, String uid) {
    if (mapValue.uid == uid) {
      return true;
    }
    return false;
  }

  void updateInventory(Product product, int updateQuantity) {
    product.quantity = product.quantity - updateQuantity;
    firebaseService.updateData('Products', product.id, product.toJSON());
  }
}