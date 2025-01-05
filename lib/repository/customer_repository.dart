import 'package:firebase_database/firebase_database.dart';
import 'package:sales_management_application/customers/model/customer.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';

class CustomerRepository {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  FirebaseService firebaseService = FirebaseService();

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
    List<Customer> listCustomer = [];

    Query query = _databaseReference.child('Customer').orderByChild('shopOwnerId').equalTo(shopOwnerId);

    final snapshot = await query.once();
    
    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic>? values = snapshot.snapshot.value as Map<dynamic, dynamic>?;
      values?.forEach((key, value) {
        Customer customer = Customer.fromJson(value);
        if (customer.status == 1) {
          customer.id = key;

          listCustomer.add(customer);
        }
      });
    }
    return listCustomer;
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
  void updateCustomer (String cusId, Customer updatedCustomer) {
    try{
      firebaseService.updateData('Customer', cusId, updatedCustomer.toJson());
    } catch (e) {
      print ('Lỗi khi cập nhật thông tin khách hàng: $e');
    }
  }
}