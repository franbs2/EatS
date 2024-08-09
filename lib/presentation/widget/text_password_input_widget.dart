import 'package:flutter/material.dart';

import '../style/color.dart';

class TextPasswordInputWidget extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const TextPasswordInputWidget(
      {super.key, this.controller, this.validator, required this.hint});

  @override
  State<TextPasswordInputWidget> createState() =>
      _TextPasswordInputWidgetState();
}

class _TextPasswordInputWidgetState extends State<TextPasswordInputWidget> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: widget.hint,
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
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppTheme.primaryColor,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      style: const TextStyle(
        color: Color(0xff2f4b4e),
      ),
    );
  }
}
