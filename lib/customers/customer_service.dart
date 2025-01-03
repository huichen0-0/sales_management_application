import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/invoice/invoice_controller.dart';
import 'package:sales_management_application/invoice/invoice_receipt.dart';
import 'package:sales_management_application/invoice/invoice_service.dart';
import 'package:sales_management_application/order/order.dart';
import 'package:sales_management_application/order/order_controller.dart';
import 'package:sales_management_application/order/order_service.dart';
import 'package:sales_management_application/products/product_service.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';
import 'package:sales_management_application/return_sale/return_sale_receipt.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';

import '../invoice/invoice_filter.dart';
import '../order/order_detail.dart';
import '../order/order_filter.dart';
import '../payment/payment.dart';
import '../products/product.dart';
import '../return_sale/return_invoice_service.dart';
import '../return_sale/return_sale_filter.dart';
import 'customer.dart';
import 'customer_filter.dart';

class CustomerService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseService firebaseService = FirebaseService();
  InvoiceService invoiceService = InvoiceService();
  TimeFilterService timeFilterService = TimeFilterService();
  ReturnInvoiceService returnInvoiceService = ReturnInvoiceService();
  ProductService productService = ProductService();
  OrderService orderService = OrderService();
  
  Future<Customer> getCustomerByKey(String key) async {
    return Customer.fromJson(await firebaseService.getDataByKey('Customer', key));
  }

  Future<List<Customer>> getCustomerList(CustomerFilter filter) async {
    List<Customer> customers = [];
    Map<String, Object> result = await firebaseService.readData('Customer');
    result.forEach((key, value) {
      Customer mapValue = Customer.fromJson(Map<dynamic, dynamic>.from(value as Map));
      mapValue.id = key;
      if (isFilterd(mapValue, filter) && isBelonged(mapValue, _auth.currentUser!.uid)) {
        customers.add(mapValue);
      }
    });
    return customers;
  }

  bool isFilterd(Customer customer, CustomerFilter filter) {
    if (filter.fromSellAmount != 0 || filter.toSellAmount != 0) {
      if (customer.amountSell < (filter.fromSellAmount as num) ||
          customer.amountSell > (filter.toSellAmount as num)) {
        return false;
      }
    }
    if (filter.fromDebtAmount != 0 || filter.toDebtAmount != 0) {
      if (customer.amountReturn < (filter.fromDebtAmount as num) ||
          customer.amountReturn > (filter.toDebtAmount as num)) {
        return false;
      }
    }
    if (filter.isActive == true && filter.isInactive == false && customer.status == 0) {
      return false;
    }
    if (filter.isActive == false && filter.isInactive == true && customer.status == 1) {
      return false;
    }
    if (filter.isMan == true && filter.isWoman == false && customer.gender == 2) {
      return false;
    }
    if (filter.isMan == false && filter.isWoman == true && customer.gender == 1) {
      return false;
    }
    return true;
  }

  bool isBelonged(Customer customer, String uid) {
    if (customer.uid == uid) {
      return true;
    }
    return false;
  }

  List<Map<String, dynamic>> convertToJson(List<Customer> customers) {
    List<Map<String, dynamic>> items = [];
    for(Customer i in customers) {
      items.add(i.toJson());
    }
    return items;
  }

  List<Customer> convertToCustomers(List<Map<String, dynamic>> items) {
    List<Customer> customers = [];
    for(Map<String, dynamic> i in items) {
      customers.add(Customer.fromJson(i));
    }
    return customers;
  }

  void updateActive(String path, String id, int newActive) {
    firebaseService.updateData(path, id, {'status': newActive});
  }

  Future<num> getTotalPurchase(DateTime? from, DateTime? to, Customer customer) async {
    num totalPurchase = 0;
    List<InvoiceReceipt> invoiceReceipts = await getInvoiceReceiptOfCustomer(customer.id);
    for(InvoiceReceipt i in invoiceReceipts) {
      if(i.payments != null && i.payments.isNotEmpty) {
        for(Payment j in i.payments) {
          if (timeFilterService.isTimeFilterd(j.createdAt, from, to)) {
            totalPurchase += j.amount;
          }
        }
      }
    }
    List<Order> orders = await getOrderOfCustomer(customer.id);
    print('get order');
    for(Order i in orders) {
          if (timeFilterService.isTimeFilterd(i.createdAt, from, to)) {
            totalPurchase += i.totalAmount;
          }
    }
    print('total done');
    return totalPurchase;
  }

  Future<List<InvoiceReceipt>> getInvoiceReceiptOfCustomer(String customerId) async {
    List<InvoiceReceipt> receipts = await invoiceService.getData(InvoiceFilter());
    List<InvoiceReceipt> results = [];
    for(InvoiceReceipt i in receipts) {
      if (i.partnerId == customerId) {
        results.add(i);
      }
    }
    return results;
  }

  Future<List<Order>> getOrderOfCustomer(String customerId) async {
    List<Order> orders = await orderService.getData(OrderFilter());
    List<Order> results = [];
    for(Order i in orders) {
      if (i.customerId == customerId) {
        List<OrderDetail> detailResult = [];
        for (OrderDetail detail in i.details) {
          Product product = await productService.getProduct(detail.productId);
          detail.product = product;
          detailResult.add(detail);
        }
        i.details = detailResult;
        Customer customer = await getCustomerByKey(i.customerId);
        i.customer = customer;
        results.add(i);
      }
    }
    return results;
  }

  Future<num> getTotalRefund(DateTime? from, DateTime? to, Customer customer) async {
    List<ReturnInvoiceReceipt> receipts = await this.getReturnReceiptOfCustomer(customer.id);
    num totalRefund = 0;
    for(ReturnInvoiceReceipt i in receipts) {
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

  Future<List<ReturnInvoiceReceipt>> getReturnReceiptOfCustomer(String customerId) async {
    List<ReturnInvoiceReceipt> receipts = await returnInvoiceService.getData(ReturnInvoiceFilter());
    List<ReturnInvoiceReceipt> results = [];
    for(ReturnInvoiceReceipt i in receipts) {
      if (i.partnerId == customerId) {
        results.add(i);
      }
    }
    return results;
  }

}