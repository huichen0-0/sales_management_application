import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/config/constants.dart';
import 'package:sales_management_application/views/widgets/forms/image_input_field.dart';
import 'package:sales_management_application/views/widgets/forms/number_range_field.dart';
import 'package:sales_management_application/views/widgets/forms/price_field.dart';
import '../../widgets/forms/custom_form.dart';
import '../../widgets/forms/custom_form_fields.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
  void initState() {
    super.initState();
    // Giả sử các giá trị ban đầu của nhà cung cấp
    controllers['name']!.text = 'Hàng hóa 1';
    controllers['barcode']!.text = '123456789';
    controllers['selling_price']!.text = '200000';
    controllers['capital_price']!.text = '100000';
    controllers['unit']!.text = 'Cái';
    controllers['quantity']!.text = '50';
    controllers['minLimit']!.text = '20';
    controllers['maxLimit']!.text = '1000';
    controllers['description']!.text = 'Hàng real 100%';
    controllers['notes']!.text = 'Nhập khẩu';
    // image nữa
  }
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
                  _showSuccessDialog(context);
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
          context.go('/products');
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
                'Sửa hàng hóa thành công!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

}
