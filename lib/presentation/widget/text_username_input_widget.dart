import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';

class TextUsernameInputWidget extends StatelessWidget {
  final TextEditingController controller;
  const TextUsernameInputWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        if (controller.text.isEmpty)
          const Text(
            StringsApp.username,
            style: TextStyle(
                color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ],
    );
  }
}
