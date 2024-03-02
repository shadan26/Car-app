import 'package:flutter/material.dart';

class TextFiledWidget extends StatelessWidget {
  const TextFiledWidget({Key? key, required this.controller, required this.labelText, this.validator, this.suffixIcon});

  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(

          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }
}

