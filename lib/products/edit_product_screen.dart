import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/products/product_detail_screen.dart';
import 'package:sales_management_application/views/widgets/forms/image_input_field.dart';
import 'package:sales_management_application/views/widgets/forms/number_range_field.dart';
import 'package:sales_management_application/views/widgets/forms/price_field.dart';
import '../views/widgets/dialogs/confirmation_dialog.dart';
import '../views/widgets/forms/custom_form.dart';
import '../views/widgets/forms/custom_form_fields.dart';
import 'product.dart';
import '../../../repository/firebase_repository.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.id, required this.product});
  final Product product;
  final String id;

  @override
  _EditProductScreenState createState() => _EditProductScreenState(id: id, product: product);
}

class _EditProductScreenState extends State<EditProductScreen> {
  // Tạo GlobalKey để quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();
  Product product;
  String id;

  _EditProductScreenState({required this.id, required this.product});

  // Các TextEditingController để điều khiển giá trị của các trường nhập
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'barcode': TextEditingController(),
    'selling_price': TextEditingController(),
    'capital_price': TextEditingController(),
    'quantity': TextEditingController(),
    'unit': TextEditingController(),
    'minLimit': TextEditingController(),
    'maxLimit': TextEditingController(),
    'description': TextEditingController(),
    'notes': TextEditingController(),
  };
  File? productImage;

  String formatCurrency(num amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  void initState() {
    super.initState();
    // Giả sử các giá trị ban đầu của nhà cung cấp
    controllers['name']!.text = product.name;
    controllers['barcode']!.text = product.barcode;
    controllers['selling_price']!.text = formatCurrency(product.sellingPrice);
    controllers['capital_price']!.text = formatCurrency(product.capitalPrice);
    controllers['unit']!.text = product.unit!;
    controllers['quantity']!.text = formatCurrency(product.quantity);
    controllers['minLimit']!.text = formatCurrency(product.minLimit);
    controllers['maxLimit']!.text = formatCurrency(product.maxLimit);
    controllers['description']!.text = product.description.toString();
    controllers['notes']!.text = product.notes;
    // image nữa
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Cập nhật hàng hóa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // context.go('/suppliers');
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomForm(
                formKey: _formKey,
                fields: [

                  ///ảnh
                  ImageInputField(
                    onImageSelected: (image) {
                      productImage = image;
                    },
                  ),
                  const SizedBox(height: 16),

                  ///tên
                  const SizedBox(height: 16),
                  NotNullField(
                    controller: controllers['name']!, label: 'Tên hàng hóa',),

                  ///mã vạch
                  const SizedBox(height: 16),
                  BarcodeField(controller: controllers['barcode']!,),
                  const SizedBox(height: 16),

                  ///giá vốn
                  PriceField(controller: controllers['capital_price']!,
                      label: AppAttribute.capitalPrice),
                  const SizedBox(height: 16),

                  ///giá bán
                  PriceField(controller: controllers['selling_price']!,
                      label: AppAttribute.sellingPrice),
                  const SizedBox(height: 16),

                  ///tồn kho
                  PriceField(
                      controller: controllers['quantity']!, label: 'Tồn kho'),
                  const SizedBox(height: 16),
                  ///Đơn vị
                  NotNullField(controller: controllers['unit']!, label: 'Đơn vị'),
                  const SizedBox(height: 16),
                  ///định mức tồn
                  NumberRangeField(
                    fromController: controllers['minLimit']!,
                    toController: controllers['maxLimit']!, fromLabel: 'Tồn ít nhất', toLabel: 'Tồn nhiều nhất',),
                  const SizedBox(height: 16),

                  ///mô tả
                  InputField(
                      controller: controllers['description']!, label: 'Mô tả'),
                  const SizedBox(height: 16),

                  ///ghi chú
                  InputField(
                      controller: controllers['notes']!, label: 'Ghi chú'),
                ],
                onSubmit: () {
                  Product updateProduct = product;
                  updateProduct.name = controllers['name']!.text;
                  updateProduct.barcode = controllers['barcode']!.text;
                  updateProduct.sellingPrice = num.parse(controllers['selling_price']!.text.replaceAll(',', ''));
                  updateProduct.capitalPrice = num.parse(controllers['capital_price']!.text.replaceAll(',', ''));
                  updateProduct.unit = controllers['unit']!.text;
                  updateProduct.quantity = int.parse(controllers['quantity']!.text.replaceAll(',', ''));
                  updateProduct.minLimit = num.parse(controllers['minLimit']!.text.replaceAll(',', ''));
                  updateProduct.maxLimit = num.parse(controllers['maxLimit']!.text.replaceAll(',', ''));
                  updateProduct.description = controllers['description']!.text;
                  updateProduct.notes = controllers['notes']!.text;
                  _editProduct(updateProduct);
                  // product = updateProduct;
                  // context.pop(product);
                },
                submitBtn: 'Lưu',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProductInfo(String id, Product product) async {
    FirebaseService firebaseService = FirebaseService();
    firebaseService.updateData('Products',  id, product.toJSON());
  }


  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _editProduct(Product updateProduct) {
    ConfirmationDialog.show(
      context: context,
      title: 'Sửa hàng hóa',
      content: 'Bạn có chắc muốn lưu lại thông tin không?',
      onConfirm: () {
        _updateProductInfo(id, updateProduct);
        context.pop(updateProduct);
        _showSnackBar('Sửa hàng hóa thành công!', Colors.green);
      },
    );
  }

}
