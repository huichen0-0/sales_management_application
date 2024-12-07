import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/models/Product.dart';
import 'package:sales_management_application/services/ProductService.dart';
import 'package:sales_management_application/views/widgets/forms/image_input_field.dart';
import 'package:sales_management_application/views/widgets/forms/number_range_field.dart';
import 'package:sales_management_application/views/widgets/forms/price_field.dart';
import '../../widgets/forms/custom_form.dart';
import '../../widgets/forms/custom_form_fields.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ProductService productService = ProductService();
  // Tạo GlobalKey để quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();

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
                  PriceField(controller: controllers['capital_price']!,
                      label: AppDisplay.capitalPrice),
                  const SizedBox(height: 16),

                  ///giá bán
                  PriceField(controller: controllers['selling_price']!,
                      label: AppDisplay.sellingPrice),
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
                  Product product = Product(name: 'name', capitalPrice: 0, sellingPrice: 0, quantity: 0, minLimit: 0, maxLimit: 0, barcode: '', notes: '');
                  DateTime now = DateTime.now();
                  product.id = DateFormat('yyMMddHHmmss').format(now);
                  product.barcode = '';
                  product.name = controllers['name']!.text;
                  product.sellingPrice = num.parse(controllers['selling_price']!.text.replaceAll(',', ''));
                  product.capitalPrice = num.parse(controllers['capital_price']!.text.replaceAll(',', ''));
                  product.quantity = num.parse(controllers['quantity']!.text.replaceAll(',', ''));
                  product.unit = controllers['unit']?.text;
                  product.minLimit = num.parse(controllers['minLimit']!.text.replaceAll(',', ''));
                  product.maxLimit = num.parse(controllers['maxLimit']!.text.replaceAll(',', ''));
                  product.description = controllers['description']?.text;
                  product.notes = controllers['notes']!.text;
                  this.productService.insertProduct(product);
                  _showSuccessDialog(context);
                  context.go('/products');
                },
                submitBtn: 'Lưu',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// hàm hiển thị thông báo sau khi submit và TODO: chuyển về trang products/:id trước đó
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Đặt thời gian chuyển hướng sau 2 giây
        Future.delayed(const Duration(seconds: 2), () {
        });

        return const AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                'Thành công',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Thêm hàng hóa thành công!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

}
