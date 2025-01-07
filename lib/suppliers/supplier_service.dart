import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/import/import_receipt.dart';
import 'package:sales_management_application/import/import_service.dart';
import 'package:sales_management_application/products/product_service.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';
import 'package:sales_management_application/return_import/model/return_import_receipt.dart';
import 'package:sales_management_application/return_import/return_import_service.dart';
import 'package:sales_management_application/suppliers/supplier.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';
import '../payment/payment.dart';
import '../products/product.dart';
import '../receipt/receipt_detail.dart';
import 'supplier_filter.dart';

class SupplierService {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TimeFilterService timeFilterService = TimeFilterService();
  ImportService importService = ImportService();
  ReturnImportService returnImportService = ReturnImportService();
  ProductService productService = ProductService();

  void insertSupplier(Supplier supplier) {
    supplier.uid = _auth.currentUser!.uid;
    firebaseService.insertData("Suppliers", supplier.toJson());
  }

  void updateActive(String id, bool newActive) {
    firebaseService.updateData('Suppliers', id, {'isActive': newActive});
  }

  void deleteSupplier(String id) {
    firebaseService.updateData('Suppliers', id, {'isDeleted': true});
  }

  Future<Supplier> getSupplierByKey(String id) async {
    Supplier supplier = Supplier.fromJson(await firebaseService.getDataByKey('Suppliers', id));
    supplier.id = id;
    return supplier;
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
    if (supplier.isDeleted == true) {
      return false;
    }
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
    if(!filter.isInactive && !filter.isActive) return false;

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

  Future<num> getTotalPurchase(DateTime? from, DateTime? to, Supplier supplier) async {
    List<ImportReceipt> receipts = await importService.getReceiptOfSupplier(supplier.id);
    for(ImportReceipt i in receipts) {
      List<ReceiptDetail> details = [];
      for (ReceiptDetail detail in i.details) {
        Product product = await productService.getProduct(detail.productId);
        detail.product = product;
        details.add(detail);
      }
      i.details = details;
      Supplier supplier = await getSupplierByKey(i.partnerId);
      i.supplier = supplier;
    }
    num totalPurchase = 0;
    for(ImportReceipt i in receipts) {
      if(i.payments.isNotEmpty) {
        for(Payment j in i.payments) {
          if (timeFilterService.isTimeFilterd(j.createdAt, from, to)) {
            totalPurchase += j.amount;
          }
        }
      }
    }
    return totalPurchase;
  }

  Future<num> getTotalRefund(DateTime? from, DateTime? to, Supplier supplier) async {
    List<ReturnImportReceipt> receipts = await returnImportService.getReceiptOfSupplier(supplier.id);

    num totalRefund = 0;
    for(ReturnImportReceipt i in receipts) {
      if(i.payments != null && i.payments.isNotEmpty) {
        for(Payment j in i.payments) {
          if (timeFilterService.isTimeFilterd(j.createdAt, from, to)) {
            totalRefund += j.amount;
          }
        }
      }
    }
    return totalRefund;
  }
}