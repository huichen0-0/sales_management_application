import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/invoice/invoice_filter.dart';
import 'package:sales_management_application/invoice/invoice_receipt.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';

class InvoiceService {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void saveReceipt(InvoiceReceipt receipt) {
    receipt.uid = _auth.currentUser!.uid;
    firebaseService.insertData('Invoice', receipt.toJson2());
  }

  Future<List<InvoiceReceipt>> getData(InvoiceFilter filter) async {
    List<InvoiceReceipt> orders = [];
    Map<String, Object> result = await firebaseService.readData('Invoice');
    result.forEach((key, value) {
      InvoiceReceipt mapValue = InvoiceReceipt.fromJson(Map<dynamic, dynamic>.from(value as Map));
      mapValue.id = key;
      if (isFilterd(mapValue, filter) && isBelonged(mapValue, _auth.currentUser!.uid)) {
        orders.add(mapValue);
      }
    });
    return orders;
  }

  bool isFilterd(InvoiceReceipt mapValue, InvoiceFilter filter) {
    int check = 0;
    if (filter.isTemp == true && mapValue.status == 1) {
      check += 1;
    }
    if (filter.isCompleted == true && mapValue.status == 2) {
      check += 1;
    }
    if (check >= 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isBelonged(InvoiceReceipt mapValue, String uid) {
    if (mapValue.uid == uid) {
      return true;
    }
    return false;
  }

  void updateReceiptReturned(String id) {
    firebaseService.updateData('Invoice', id, {'returned': true});
  }

  Future<InvoiceReceipt> getReceiptById(String id) async {
    return InvoiceReceipt.fromJson(await firebaseService.getDataByKey('Invoice', id));
  }
}