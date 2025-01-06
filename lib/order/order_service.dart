import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/import/import_receipt.dart';
import 'package:sales_management_application/import/import_filter.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';

import 'order.dart';
import 'order_filter.dart';

class OrderService {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void save(Order order, String path) {
    order.createdAt = DateTime.now();
    if (order.uid.isEmpty) {
      order.uid = _auth.currentUser!.uid;
      firebaseService.insertData('Order', order.toJson2());
    } else {
      firebaseService.updateData('Order', order.id, order.toJson2());
    }
  }

  Future<List<Order>> getData(OrderFilter filter) async {
    List<Order> orders = [];
    Map<String, Object> result = await firebaseService.readData('Order');
    result.forEach((key, value) {
      Order mapValue = Order.fromJson(Map<dynamic, dynamic>.from(value as Map));
      mapValue.id = key;
      if (isFilterd(mapValue, filter) && isBelonged(mapValue, _auth.currentUser!.uid)) {
        orders.add(mapValue);
      }
    });
    return orders;
  }

  void cancelReceipt(String id) {
    firebaseService.updateData('Order', id, {'status': 0});
  }

  void delete(Order order) {
    firebaseService.delete('Order', order.id);
  }

  bool isFilterd(Order mapValue, OrderFilter filter) {
    int check = 0;
    if (filter.isTemp == true && mapValue.status == 1) {
      check += 1;
    }
    if (filter.isFinished == true && mapValue.status == 2) {
      check += 1;
    }
    if (filter.isCancelled == true && mapValue.status == 0) {
      check += 1;
    }
    if (check >= 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isBelonged(Order mapValue, String uid) {
    if (mapValue.uid == uid) {
      return true;
    }
    return false;
  }
}