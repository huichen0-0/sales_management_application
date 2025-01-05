import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final VoidCallback onSubmit;
  final String submitBtn;

  const CustomForm({
    super.key,
    required this.formKey,
    required this.fields,
    required this.onSubmit,
    required this.submitBtn,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          ...fields,
          const SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  onSubmit();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
              child: Container(
                height: 50,
                width: double.infinity,  // Set the width of the container
                alignment: Alignment.center,  // Center the child widget inside the container
                child: Text(
                  submitBtn,  // Your text content
                  style: TextStyle(
                    color: Colors.white,  // Set text color
                    fontFamily: 'YourFontFamily',  // Set custom font family
                    fontSize: 18.0,  // Set font size
                    fontWeight: FontWeight.bold,  // Set font weight (optional)
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
