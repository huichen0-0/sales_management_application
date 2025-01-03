import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';
import 'export_receipt.dart';
import 'ec_filter.dart';

class ExportCancelService {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void save(ExportCancellationReceipt receipt, String path) {
    receipt.createdAt = DateTime.now();
    if (receipt.uid == null || receipt.uid!.isEmpty) {
      receipt.uid = _auth.currentUser!.uid;
      firebaseService.insertData('ExportCancellationReceipt', receipt.toJSON2());
    } else {
      print('not null');
      firebaseService.updateData('ExportCancellationReceipt', receipt.id, receipt.toJSON2());
    }
  }

  Future<List<ExportCancellationReceipt>> getData(EcFilter filter) async {
    List<ExportCancellationReceipt> ecReceipts = [];
    Map<String, Object> result = await firebaseService.readData("ExportCancellationReceipt");
    result.forEach((key, value) {
      ExportCancellationReceipt mapValue = ExportCancellationReceipt.fromJSON(Map<dynamic, dynamic>.from(value as Map));
      mapValue.id = key;
      if (isFilterd(mapValue, filter) && isBelonged(mapValue, _auth.currentUser!.uid)) {
        ecReceipts.add(mapValue);
      }
    });
    return ecReceipts;
  }

  void delete(ExportCancellationReceipt receipt) {
    firebaseService.delete('ExportCancellationReceipt', receipt.id);
  }

  bool isFilterd(ExportCancellationReceipt mapValue, EcFilter filter) {
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

  bool isBelonged(ExportCancellationReceipt mapValue, String uid) {
    if (mapValue.uid == uid) {
      return true;
    }
    return false;
  }
}