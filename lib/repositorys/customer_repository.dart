import 'package:firebase_database/firebase_database.dart';
import 'package:sales_management_application/models/Customer.dart';

class CustomerRepository {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  //Thêm khách hàng
  Future<bool> addCustomer(Customer customer) async {
    try{
      await _databaseReference.child('Customer').push().set(customer.toJson());
      return true;
    } catch (e){
      print ('Lỗi khi thêm khách hàng: $e');
      return false;
    }
    
  }

  //Lấy danh sách khách hàng
  Future<List<Customer>> getListCustomers (String shopOwnerId) async {
    List<Customer> list_customer = [];

    Query query = _databaseReference.child('Customer').orderByChild('shopOwnerId').equalTo(shopOwnerId);

    final snapshot = await query.once();
    
    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic>? values = snapshot.snapshot.value as Map<dynamic, dynamic>?;
      values?.forEach((key, value) {
        Customer customer = Customer.fromJson(value);
        if (customer.status == 1) {
          customer.id = key;

          list_customer.add(customer);
        }
      });
    }
    return list_customer;
  }

  //Lấy thông tin khách hàng
  Future<Customer?> getCustomerById (String cusId) async {
    final snapshot = await _databaseReference.child('Customer').child(cusId).get();
    if(snapshot.exists){
      Customer customer = Customer.fromJson(snapshot.value as Map<dynamic, dynamic>);
      customer.id = cusId;
      return customer;
    }
    return null;
  }

  //Cập nhật thông tin khách hàng
  Future<bool> updateCustomer (String cusId, Customer updatedCustomer) async {
    try{
      Map<String, dynamic> customerData = updatedCustomer.toJson();
      await _databaseReference.child('Customer').child(cusId).update(customerData);
      return true;

    } catch (e) {
      print ('Lỗi khi cập nhật thông tin khách hàng: $e');
      return false;
    }
  }
}