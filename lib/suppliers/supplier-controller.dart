import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/suppliers/supplier.dart';
import 'package:sales_management_application/suppliers/supplier_filter.dart';
import 'package:sales_management_application/suppliers/supplier_service.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';

class SupplierController {
  SupplierService supplierService = SupplierService();
  TimeFilterService timeFilterService = TimeFilterService();

  Future<List<Supplier>> getSupplierList(SupplierFilter filter, String selectedDisplay, DateTime? fromDate, DateTime? toDate) async {
    List<Supplier> suppliers = await supplierService.getSupplierList(filter);
    List<Supplier> result = [];
    for(Supplier i in suppliers) {
      if (timeFilterService.isTimeFilterd(i.createdAt, fromDate, toDate)) {
        result.add(i);
        // i.amount = await  getTotalAmount(fromDate, toDate, selectedDisplay, i);
      }
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

  void deleteSupplier(Supplier supplier) {
    supplierService.deleteSupplier(supplier.id);
  }

  Future<Supplier> getSupplierByKey(String id) async {
    return await supplierService.getSupplierByKey(id);
  }

  void updateActive(Supplier supplier, bool newActive) {
    supplierService.updateActive(supplier.id, newActive);
  }
}