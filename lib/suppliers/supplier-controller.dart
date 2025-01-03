import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/suppliers/supplier.dart';
import 'package:sales_management_application/suppliers/supplier_filter.dart';
import 'package:sales_management_application/suppliers/supplier_service.dart';

class SupplierController {
  SupplierService supplierService = SupplierService();

  Future<List<Supplier>> getSupplierList(SupplierFilter filter, String selectedDisplay, DateTime? fromDate, DateTime? toDate) async {
    List<Supplier> suppliers = await supplierService.getSupplierList(filter);
    for(Supplier i in suppliers) {
      i.amount = await  getTotalAmount(fromDate, toDate, selectedDisplay, i);
    }
    return suppliers;
  }

  Future<List<Supplier>> getSupplierToSearch(SupplierFilter filter) async {
    return await supplierService.getSupplierList(filter);
  }

  List<Map<String, dynamic>> convertToJson(List<Supplier> suppliers) {
    return supplierService.convertToJson(suppliers);
  }

  Future<num> getTotalAmount(DateTime? fromDate, DateTime? toDate, String selectedDisplay, Supplier supplier) async {
    if (selectedDisplay == AppString.totalPurchase) {
      return await supplierService.getTotalPurchase(fromDate, toDate, supplier);
    } else {
      return await supplierService.getTotalRefund(fromDate, toDate, supplier);
    }
  }

  List<Supplier> convertToSupplier(List<Map<String, dynamic>> items) {
    return supplierService.convertToSupplier(items);
  }
}