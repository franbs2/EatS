import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';

class TextUsernameInputWidget extends StatefulWidget {
  final TextEditingController controller;

  const TextUsernameInputWidget({
    super.key,
    required this.controller,
  });

  @override
  _TextUsernameInputWidgetState createState() =>
      _TextUsernameInputWidgetState();
}

class _TextUsernameInputWidgetState extends State<TextUsernameInputWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        if (widget.controller.text.isEmpty)
          const Text(
            StringsApp.username,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        TextFormField(
          controller: widget.controller,
          decoration: const InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            //mudar a cor do texto adicionado pelo usuario
          ),
          style: const TextStyle(
              color: Color(0xff624242),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
