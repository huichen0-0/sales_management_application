import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';
import 'package:sales_management_application/return_sale/return_sale_filter.dart';
import 'package:sales_management_application/return_sale/return_sale_receipt.dart';

class ReturnInvoiceService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseService firebaseService = FirebaseService();

  void saveReceipt(ReturnInvoiceReceipt receipt) {
    receipt.createdAt = DateTime.now();
    if (receipt.uid.isEmpty) {
      receipt.uid = _auth.currentUser!.uid;
      firebaseService.insertData('ReturnInvoiceReceipt', receipt.toJson2());
    } else {
      firebaseService.updateData('ReturnInvoiceReceipt', receipt.id, receipt.toJson2());
    }
  }

  void updateReceipt(String id) {
    firebaseService.updateData('ReturnInvoiceReceipt', id, {});
  }

  Future<List<ReturnInvoiceReceipt>> getData(ReturnInvoiceFilter filter) async {
    List<ReturnInvoiceReceipt> returnInvoiceReceipts = [];
    Map<String, Object> result = await firebaseService.readData('ReturnInvoiceReceipt');
    result.forEach((key, value) {
      ReturnInvoiceReceipt mapValue = ReturnInvoiceReceipt.fromJson(Map<dynamic, dynamic>.from(value as Map));
      mapValue.id = key;
      if (isFilterd(mapValue, filter) && isBelonged(mapValue, _auth.currentUser!.uid)) {
        returnInvoiceReceipts.add(mapValue);
      }

    });
    return returnInvoiceReceipts;
  }

  bool isFilterd(ReturnInvoiceReceipt mapValue, ReturnInvoiceFilter filter) {
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

  bool isBelonged(ReturnInvoiceReceipt mapValue, String uid) {
    if (mapValue.uid == uid) {
      return true;
    }
    return false;
  }

  Future<ReturnInvoiceReceipt> getReceiptById(String id) async {
    final receipt = await firebaseService.getDataByKey('ReturnInvoiceReceipt', id);
    receipt['id'] = id;
    return ReturnInvoiceReceipt.fromJson(receipt);
  }
  Future<List<ReturnInvoiceReceipt>> getCompletedReceipts(DateTime? date) async {
    List<ReturnInvoiceReceipt> receipts = [];
    Map<String, Object> result = await firebaseService.readData('ReturnInvoiceReceipt');
    result.forEach((key, value) {
      final receipt =
      ReturnInvoiceReceipt.fromJson(Map<dynamic, dynamic>.from(value as Map));
      receipt.id = key;
      if (receipt.uid == _auth.currentUser!.uid && receipt.status == 2) {
        if (date == null) {
          receipts.add(receipt);
        } else {
          if (receipt.createdAt.isAfter(date)) receipts.add(receipt);
        }
      }
    });
    return receipts;
  }
  void cancelReceipt(String id) {
    firebaseService.delete('ReturnInvoiceReceipt', id);
  }
}