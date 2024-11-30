import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/controllers/auth_controller.dart';
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
    this.firebaseService.updateDate('Suppliers', id, {'isActive': newActive});
  }

  void deleteSupplier(String id) {
    this.firebaseService.updateDate('Suppliers', id, {'isDeleted': false});
  }

  Future<Map<String, Supplier>> getSupplierList(SupplierFilter filter) async {
    Map<String, Supplier> suppliers = HashMap();
    FirebaseService firebaseService = FirebaseService();
    Map<String, Object> result = await firebaseService.readData("Suppliers");
    result.forEach((key, value) {
      Supplier mapValue = Supplier.fromJson(Map<dynamic, dynamic>.from(value as Map));
      if (isFilterd(mapValue, filter) && isBelonged(mapValue, _auth.currentUser!.uid)) {
        suppliers[key] = mapValue;
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
}