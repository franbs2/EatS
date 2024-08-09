import 'package:eats/presentation/style/color.dart';
import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const TextInputWidget(
      {super.key, this.controller, this.validator, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 73, 139, 45),
            width: 1.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(
        color: Color(0xff2f4b4e),
      ),
    );
  }
}
