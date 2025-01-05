import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/ec/export_receipt.dart';
import 'package:sales_management_application/import/import_receipt.dart';
import 'package:sales_management_application/inventory_check/inventory_check_receipt.dart';
import 'package:sales_management_application/products/product.dart';
import 'package:sales_management_application/products/product_service.dart';
import 'package:sales_management_application/receipt/receipt_detail.dart';
import 'package:sales_management_application/return_import/model/return_import_receipt.dart';

import 'product_filter.dart';

class ProductController {

  ProductService productService = ProductService();

  Future<List<Product>> getProductList(ProductFilter filter) async {
    return await productService.getProductList(filter);
  }

  void addProduct(Map<String, TextEditingController> controllers) {
    Product product = Product.empty();
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

  void updateActive(String id, bool newActive) {
    productService.updateActive(id, newActive);
  }

  void deleteProduct(Product product) {
    productService.deleteProduct(product.id);
  }

  void addAmount(ImportReceipt receipt) {
    for(ReceiptDetail i in receipt.details) {
      num currentQuantity = i.product!.quantity;
      num updatedQuantity = currentQuantity + i.quantity;
      productService.updateAmount(i.productId, updatedQuantity);
    }
  }

  void subAmount(ReturnImportReceipt receipt) {
    for(ReceiptDetail i in receipt.details) {
      num currentQuantity = i.product!.quantity;
      num updatedQuantity = currentQuantity - i.quantity;
      productService.updateAmount(i.productId, updatedQuantity);
    }
  }

  void subAmountEc(ExportCancellationReceipt receipt) {
    for(var i in receipt.details) {
      num currentQuantity = i.product!.quantity;
      num updatedQuantity = currentQuantity - i.cancelledQuantity;
      productService.updateAmount(i.productId, updatedQuantity);
    }
  }

  void updateAmount(InventoryCheckReceipt receipt) {
    for(var i in receipt.details) {
      productService.updateAmount(i.productId, i.quantityDifference + i.product!.quantity);
    }
  }
}