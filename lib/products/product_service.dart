import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_management_application/repository/firebase_repository.dart';
import 'package:sales_management_application/products/product_filter.dart';

import 'product.dart';

class ProductService {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void save(Product product) {
    product.uid = _auth.currentUser!.uid;
    firebaseService.insertData("Products", product.toJSON());
  }

  void updateActive(String id, bool newActive) {
    firebaseService.updateData('Products', id, {'isActive': newActive});
  }

  void deleteProduct(String id) {
    firebaseService.updateData('Products', id, {'isDeleted': false});
  }

  Future<Product> getProduct(String productId) async {
    Product product = Product.fromJSON(await firebaseService.getDataByKey('Products', productId));
    return product;
  }

  Future<List<Product>> getProductList(ProductFilter filter) async {
    List<Product> productList = [];
    Map<String, Object> result = await firebaseService.readData("Products");
    result.forEach((key, value) {
      Product mapValue = Product.fromJSON(Map<String, dynamic>.from(value as Map));
      mapValue.id = key;
      if (isFilterd(mapValue, filter) && isBelonged(mapValue, _auth.currentUser!.uid)) {
        productList.add(mapValue);
      }
    });
    return productList;
  }

  bool isFilterd(Product product, ProductFilter filter) {
    if (filter.isAboveStockLimit && !product.isAboveMaxLimit()) {
      return false;
    }
    if (filter.isBelowStockLimit && !product.isBelowMinLimit()) {
      return false;
    }
    if (filter.isAvailable && product.quantity <= 0) {
      return false;
    }
    if (filter.isSoldOut && product.quantity > 0) {
      return false;
    }
    if (filter.isActive == true && filter.isInactive == false && product.isActive == false) {
      return false;
    }
    if (filter.isActive == false && filter.isInactive == true && product.isActive == true) {
      return false;
    }
    if (filter.isActive == false && filter.isInactive == false) {
      return false;
    }
    return true;
  }

  bool isBelonged(Product product, String uid) {
    if (product.uid == uid) {
      return true;
    }
    return false;
  }

  List<Product> convertToProduct(List<Map<String, dynamic>> items) {
    List<Product> products = [];
    for(Map<String, dynamic> i in items) {
      products.add(Product.fromJSON(i));
    }
    return products;
  }

  List<Map<String, dynamic>> convertToJson(List<Product> products) {
    List<Map<String, dynamic>> items = [];
    for(Product i in products) {
      items.add(i.toJSON());
    }
    return items;
  }
}