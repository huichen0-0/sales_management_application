import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/products/product_controller.dart';
import 'package:sales_management_application/views/widgets/forms/image_input_field.dart';
import 'package:sales_management_application/views/widgets/forms/number_range_field.dart';
import 'package:sales_management_application/views/widgets/forms/price_field.dart';

import '../views/widgets/dialogs/confirmation_dialog.dart';
import '../views/widgets/forms/custom_form.dart';
import '../views/widgets/forms/custom_form_fields.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ProductController productController = ProductController();
  // Tạo GlobalKey để quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();

  // Các TextEditingController để điều khiển giá trị của các trường nhập
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'barcode': TextEditingController(),
    'sellingPrice': TextEditingController(),
    'capitalPrice': TextEditingController(),
    'quantity': TextEditingController(),
    'unit': TextEditingController(),
    'minLimit': TextEditingController(),
    'maxLimit': TextEditingController(),
    'description': TextEditingController(),
    'notes': TextEditingController(),
  };
  File? productImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Thêm hàng hóa'),
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
                  PriceField(controller: controllers['capitalPrice']!,
                      label: AppString.capitalPrice),
                  const SizedBox(height: 16),

                  ///giá bán
                  PriceField(controller: controllers['sellingPrice']!,
                      label: AppString.sellingPrice),
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
                  _addProduct();
                },
                submitBtn: 'Lưu',
              ),
            ],
          ),
        ),
      ),
    );
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

  void _addProduct() {
    ConfirmationDialog.show(
      context: context,
      title: 'Thêm hàng hóa',
      content: 'Bạn có chắc muốn thêm hàng hóa này không?',
      onConfirm: () {
        productController.addProduct(controllers);
        context.pop();
        _showSnackBar('Thêm hàng hóa thành công!', Colors.green);
      },
    );
  }
}
