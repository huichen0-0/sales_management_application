import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/repository/FirebaseService.dart';

import '../models/Supplier.dart';
import 'filter/SupplierFilter.dart';

class SupplierService {
  FirebaseService firebaseService = new FirebaseService();
  FirebaseAuth _auth = FirebaseAuth.instance;

  void insertSupplier(Supplier supplier) {
    supplier.uid = _auth.currentUser!.uid;
    this.firebaseService.insertData("Suppliers", supplier.toJson());
  }

  void updateActive(String id, bool newActive) {
    this.firebaseService.updateData('Suppliers', id, {'isActive': newActive});
  }

  void deleteSupplier(String id) {
    this.firebaseService.updateData('Suppliers', id, {'isDeleted': false});
  }

  Future<List<Supplier>> getSupplierList(SupplierFilter filter) async {
    List<Supplier> suppliers = [];
    FirebaseService firebaseService = FirebaseService();
    Map<String, Object> result = await firebaseService.readData("Suppliers");
    result.forEach((key, value) {
      Supplier mapValue = Supplier.fromJson(Map<dynamic, dynamic>.from(value as Map));
      mapValue.id = key;
      if (isFilterd(mapValue, filter) && isBelonged(mapValue, _auth.currentUser!.uid)) {
        suppliers.add(mapValue);
      }
    });
    return suppliers;
  }

  bool isFilterd(Supplier supplier, SupplierFilter filter) {
    if (filter.purchaseUpperBound != 0 || filter.purchaseLowerBound != 0) {
      if (supplier.amount < (filter.purchaseLowerBound as num) ||
          supplier.amount > (filter.purchaseUpperBound as num)) {
        return false;
      }
    }
    if (filter.isActive == true && filter.isInactive == false && supplier.isActive == false) {
      return false;
    }
    if (filter.isActive == false && filter.isInactive == true && supplier.isActive == true) {
      return false;
    }
    return true;
  }

  bool isBelonged(Supplier supplier, String uid) {
    if (supplier.uid == uid) {
      return true;
    }
    return false;
  }

  List<Supplier> convertToSupplier(List<Map<String, dynamic>> items) {
    List<Supplier> suppliers = [];
    for(Map<String, dynamic> i in items) {
      suppliers.add(Supplier.fromJson(i));
    }
    return suppliers;
  }

  List<Map<String, dynamic>> convertToJson(List<Supplier> suppliers) {
    List<Map<String, dynamic>> items = [];
    for(Supplier i in suppliers) {
      items.add(i.toJson());
    }
    return items;
  }
}