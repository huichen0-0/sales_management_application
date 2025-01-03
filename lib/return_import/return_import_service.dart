import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/import/import_filter.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';
import 'package:sales_management_application/return_import/model/return_import_receipt.dart';
import 'package:sales_management_application/return_import/return_import_filter.dart';

class ReturnImportService {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void save(ReturnImportReceipt receipt, String path) {
    receipt.createdAt = DateTime.now();
    if (receipt.uid == null || receipt.uid!.isEmpty) {
      receipt.uid = _auth.currentUser!.uid;
      firebaseService.insertData('ReturnImportReceipt', receipt.toJson2());
    } else {
      firebaseService.updateData('ReturnImportReceipt', receipt.id, receipt.toJson2());
    }
  }

  Future<List<ReturnImportReceipt>> getReceiptOfSupplier(String supplierId) async {
    List<ReturnImportReceipt> receipts = await this.getData(ReturnImportFilter());
    List<ReturnImportReceipt> results = [];
    for(ReturnImportReceipt i in receipts) {
      if (i.partnerId == supplierId) {
        results.add(i);
      }
    }
    return results;
  }

  Future<List<ReturnImportReceipt>> getData(ReturnImportFilter filter) async {
    List<ReturnImportReceipt> returnImportReceipts = [];
    Map<String, Object> result = await firebaseService.readData('ReturnImportReceipt');
    result.forEach((key, value) {
      ReturnImportReceipt mapValue = ReturnImportReceipt.fromJson(Map<dynamic, dynamic>.from(value as Map));
      mapValue.id = key;
      if (isFilterd(mapValue, filter) && isBelonged(mapValue, _auth.currentUser!.uid)) {
        returnImportReceipts.add(mapValue);
      }
    });
    return returnImportReceipts;
  }

  void delete(ReturnImportReceipt receipt) {
    firebaseService.delete('ReturnImportReceipt', receipt.id);
  }

  bool isFilterd(ReturnImportReceipt mapValue, ReturnImportFilter filter) {
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

  bool isBelonged(ReturnImportReceipt mapValue, String uid) {
    if (mapValue.uid == uid) {
      return true;
    }
    return false;
  }
}