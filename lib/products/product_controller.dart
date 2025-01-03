import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/products/product.dart';
import 'package:sales_management_application/products/product_service.dart';

import 'product_filter.dart';

class ProductController {

  ProductService productService = ProductService();

  Future<List<Product>> getProductList(ProductFilter filter) async {
    return await productService.getProductList(filter);
  }

  void addProduct(Map<String, TextEditingController> controllers) {
    Product product = Product.empty();
    DateTime now = DateTime.now();
    product.id = DateFormat('yyMMddHHmmss').format(now);
    product.barcode = '';
    product.name = controllers['name']!.text;
    product.sellingPrice = num.parse(controllers['sellingPrice']!.text.replaceAll(',', ''));
    product.capitalPrice = num.parse(controllers['capitalPrice']!.text.replaceAll(',', ''));
    product.quantity = int.parse(controllers['quantity']!.text.replaceAll(',', ''));
    product.unit = controllers['unit']?.text;
    product.minLimit = num.parse(controllers['minLimit']!.text.replaceAll(',', ''));
    product.maxLimit = num.parse(controllers['maxLimit']!.text.replaceAll(',', ''));
    product.description = controllers['description']?.text;
    product.notes = controllers['notes']!.text;
    productService.save(product);
  }

}