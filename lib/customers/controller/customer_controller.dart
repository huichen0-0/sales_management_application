import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_management_application/customers/model/customer.dart';
import 'package:sales_management_application/customers/filter/customer_filter.dart';
import 'package:sales_management_application/customers/service/customer_service.dart';
import 'package:sales_management_application/repository/customer_repository.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';

import '../../config/constants.dart';
import '../../sort/sorting_controller.dart';

class CustomerController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CustomerRepository _customerRepository = CustomerRepository();
  List<Customer> customers = [];
  late Customer customerDetail;
  List<Customer> listCustomersToSearch = [];
  CustomerService customerService = CustomerService();
  TimeFilterService timeFilterService = TimeFilterService();

  Future<List<Customer>> getCustomerListToSearch(CustomerFilter filter) async {
    return await customerService.getCustomerList(filter);
  }

  Future<List<Customer>> getCustomerList(CustomerFilter filter, String selectedOption, String selectedDisplay, DateTime? fromDate, DateTime? toDate) async {
    List<Customer> customers = await customerService.getCustomerList(filter);
    List<Customer> result = [];
    for(Customer customer in customers) {
      // if (timeFilterService.isTimeFilterd(customer.createdAt, fromDate, toDate)) {
        // result.add(customer);
      // }
      if (selectedDisplay == AppString.totalSale) {
        customer.amountSell = await customerService.getTotalPurchase(fromDate, toDate, customer);
      } else {
        customer.amountReturn = await customerService.getTotalRefund(fromDate, toDate, customer);
      }
      result.add(customer);
    }
    return result;
  }

  List<Map<String, dynamic>> convertToJson(List<Customer> customers) {
    return customerService.convertToJson(customers);
  }

  List<Customer> convertToCustomers(List<Map<String, dynamic>> items) {
    return customerService.convertToCustomers(items);
  }

  //Thêm khách hàng
  void addCustomer(Customer customer) {
    customerService.addCustomer(customer);
  }

  Customer getNewCustomer(String name, String phoneNumber, String sex, String address, String email, String note) {

    String shopOwnerId = getUidCurrentUsers();

    //Xử lý thêm khách hàng
    int gender;
    int status = 1;
    int isActivated = 1;
    DateTime currentDateTime = DateTime.now();
    num amountSell = 0;
    num amountReturn = 0;

    if (sex.toLowerCase() == 'nam') {
      gender = 1;
    } else if (sex.toLowerCase() == 'nữ') {
      gender = 2;
    } else if (sex.toLowerCase() == 'khác'){
      gender = 3;
    } else { //Nếu không chọn giới tính
      gender = 4;
    }

    Customer newCustomer = Customer(
        id: '',
        name: name,
        phoneNumber: phoneNumber,
        gender: gender,
        address: address,
        email: email,
        note: note,
        status: status,
        uid: shopOwnerId,
        createdAt: currentDateTime,
        amountSell: amountSell,
        amountReturn: amountReturn
    );
    return newCustomer;
  }

  //Lấy danh sách khách hàng
  Future<void> getDataListCustomers() async {
    String shopOwnerId = getUidCurrentUsers();

    customers = await _customerRepository.getListCustomers(shopOwnerId);
  } 

  //Lấy thông tin khách hàng
  Future<void> getCustomerInfo (String cusId) async {
    customerDetail = (await _customerRepository.getCustomerById(cusId))!;
  }

  void updateActive(String id, int newActive) {
    customerService.updateActive('Customer', id,  newActive);
  }

  //Sửa thông tin khách hàng
  void editCustomerInfo(Customer customer) {
    _customerRepository.updateCustomer(customer.id, customer);
  }

  //Xóa khách hàng
  void deleteCustomer(Customer customer) {
    customer.status = 3;
    _customerRepository.updateCustomer(customer.id, customer);
  }

  //Lấy danh sách khách hàng để tìm kiếm
  Future<void> getListCustomerToSearch() async {
    String shopOwnerId = getUidCurrentUsers();

    listCustomersToSearch = await _customerRepository.getListCustomers(shopOwnerId);
  }

  //Chuyển danh sách đối tượng về dạng List<Map<String, dynamic>>
  List<Map<String, dynamic>> toMap(List<Customer> listCus){
    List<Map<String, dynamic>> listMap= [];
    for (Customer cus in listCus){
      Map<String, dynamic> item = cus.toJson();
      item['id'] = cus.id;
      listMap.add(item);
    }
    return listMap;
  }

  //Chuyển ngược danh sách List<Map<String, dynamic>> về dạng danh sách đối tượng
  List<Customer> fromMap(List<Map<String, dynamic>> listMap){
    List<Customer> listCus = [];
    for(var item in listMap){
      Customer cus = Customer.fromJson(item);
      cus.id = item['id'];
      listCus.add(cus);
    }
    return listCus;
  }

  //Lấy id người dùng đang đănh nhập
  String getUidCurrentUsers () {
    User? user = _auth.currentUser;
    
    String currentUserUid = "";
    if(user != null){
      currentUserUid = user.uid;
    } 
    return currentUserUid;
  }

  Future<void> filterCustomer(CustomerFilter filterCustomer) async {
    String shopOwnerId = getUidCurrentUsers();
    List<Customer> oldListCustomer = await _customerRepository.getListCustomers(shopOwnerId);

    List<Customer> newListCustomer = [];

    for (Customer customer in oldListCustomer) {
      bool matches = true;
      int gender;
      int isActivated;

      if(filterCustomer.isMan == true && filterCustomer.isWoman == false){
        gender = 1;
      } else if(filterCustomer.isMan == false && filterCustomer.isWoman == true){
        gender = 2;
      } else {
        gender = 3;
      }
      
      if(filterCustomer.isActive == true && filterCustomer.isInactive == false){
        isActivated = 1;
      } else if(filterCustomer.isActive == false && filterCustomer.isInactive == true){
        isActivated = 2;
      } else {
        isActivated = 3;
      }

      // Lọc bằng ngày giao dịch cuối 
      if (filterCustomer.fromDate != null || filterCustomer.toDate != null) {
        // DateTime transactionDate = DateTime.parse(customer['transactionDate']); //Thay bằng giá trị ngày giao dịch cuối cùng của khách hàng
        // if (fromDate != null && transactionDate.isBefore(fromDate)) {
        //   matches = false;
        // }
        // if (toDate != null && transactionDate.isAfter(toDate)) {
        //   matches = false;
        // }
      }

      // Lọc bằng tổng bán
      if (filterCustomer.fromSellAmount != null || filterCustomer.toSellAmount != null) {
        if (filterCustomer.fromSellAmount != null && customer.amountSell < filterCustomer.fromSellAmount!) {
          matches = false;
        }
        if (filterCustomer.toSellAmount != null && customer.amountSell > filterCustomer.toSellAmount!) {
          matches = false;
        }
      }

      // Lọc bằng tổng trả
      if (filterCustomer.fromDebtAmount != null || filterCustomer.toDebtAmount != null) {
        if (filterCustomer.fromDebtAmount != null && customer.amountReturn < filterCustomer.fromDebtAmount!) {
          matches = false;
        }
        if (filterCustomer.toDebtAmount != null && customer.amountReturn > filterCustomer.toDebtAmount!) {
          matches = false;
        }
      }

      // Filter by gender
      if (gender == 1 || gender == 2) {
        if (gender != customer.gender) {
          matches = false;
        }
      }

      if (matches) {
        newListCustomer.add(customer);
      }
    }
    customers = newListCustomer;
  }

  CustomerFilter convertInputToFilter(bool isActive, bool isInactive, bool isMale, bool isFemale,
      TextEditingController purchaseFromController,
      TextEditingController purchaseToController,
      TextEditingController debtFromController,
      TextEditingController debtToController
      ) {
    CustomerFilter filter = CustomerFilter.empty();
    filter.isActive = isActive;
    filter.isInactive = isInactive;
    filter.isMan = isMale;
    filter.isWoman = isFemale;
    /////////
    if (purchaseFromController.text.isEmpty) {
      filter.fromSellAmount = 0;
    } else {
      filter.fromSellAmount = int.parse(purchaseFromController.text);
    }
    if (purchaseToController.text.isEmpty) {
      filter.toSellAmount = 0;
    } else {
      filter.toSellAmount = int.parse(purchaseToController.text);
    }
    /////////
    if (debtFromController.text.isEmpty) {
      filter.fromDebtAmount = 0;
    } else {
      filter.fromDebtAmount = int.parse(purchaseFromController.text);
    }
    if (debtToController.text.isEmpty) {
      filter.toDebtAmount = 0;
    } else {
      filter.toDebtAmount = int.parse(purchaseFromController.text);
    }
    return filter;
  }
  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<Customer>? data) => [
    for (var receipt in data ?? <Customer>[]) receipt.toJson(),
  ];

  // chuyển sang danh sách object
  List<Customer> convertFromJSON(List<Map<String, dynamic>> json) {
    return json
        .map((receiptJson) => Customer.fromJson(receiptJson))
        .toList();
  }
  List<Customer> sort(
      List<Customer> receipts,
      String sortOption,
      String sortAttribute
      ) {
    // Sắp xếp theo tùy chọn
    final sortingController = SortingController(convertToJSON(receipts));
    sortingController.updateSorting(sortOption, sortAttribute);

    return convertFromJSON(sortingController.currentData);
  }

}