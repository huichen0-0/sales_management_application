import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/import/import_receipt.dart';
import 'package:sales_management_application/import/import_filter.dart';
import 'package:sales_management_application/products/product_service.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';
import 'package:sales_management_application/suppliers/supplier_service.dart';

import '../products/product.dart';
import '../receipt/receipt_detail.dart';
import '../suppliers/supplier.dart';

class ImportService {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void save(ImportReceipt receipt, String path) {
    receipt.createdAt = DateTime.now();
    if (receipt.uid == null || receipt.uid!.isEmpty) {
      receipt.uid = _auth.currentUser!.uid;
      firebaseService.insertData('ImportReceipt', receipt.toJson2());
    } else {
      firebaseService.updateData('ImportReceipt', receipt.id, receipt.toJson2());
    }
  }

  Future<ImportReceipt> getReceiptByKey(String path, String key) async {
    return ImportReceipt.fromJson(await firebaseService.getDataByKey(path, key));
  }

  Future<List<ImportReceipt>> getReceiptOfSupplier(String supplierId) async {
    List<ImportReceipt> receipts = await this.getData(ImportFilter());
    List<ImportReceipt> results = [];
    for(ImportReceipt i in receipts) {
      if (i.partnerId == supplierId) {
        results.add(i);
      }
    }
    return results;
  }

  Future<List<ImportReceipt>> getData(ImportFilter filter) async {
    List<ImportReceipt> importReceipts = [];
    Map<String, Object> result = await firebaseService.readData('ImportReceipt');
    result.forEach((key, value) {
      ImportReceipt mapValue = ImportReceipt.fromJson(Map<dynamic, dynamic>.from(value as Map));
      mapValue.id = key;
      if (isFilterd(mapValue, filter) && isBelonged(mapValue, _auth.currentUser!.uid)) {
        importReceipts.add(mapValue);
      }
    });
    return importReceipts;
  }

  void delete(ImportReceipt receipt) {
    firebaseService.delete('ImportReceipt', receipt.id);
  }

  bool isFilterd(ImportReceipt mapValue, ImportFilter filter) {
    if (filter.isTemp == true && filter.isFinished == false && mapValue.status == 2) {
      return false;
    }
    if (filter.isTemp == false && filter.isFinished == true && mapValue.status == 1) {
      return false;
    }
    if (filter.isTemp == false && filter.isFinished == false) {
      return false;
    }
    return true;
  }

  bool isBelonged(ImportReceipt mapValue, String uid) {
    if (mapValue.uid == uid) {
      return true;
    }
    return false;
  }
}