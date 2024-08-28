import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';

class TextUsernameInputWidget extends StatefulWidget {
  const TextUsernameInputWidget({
    super.key,
  });

  @override
  State<TextUsernameInputWidget> createState() => _TextUsernameWidget();
}

class _TextUsernameWidget extends State<TextUsernameInputWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isEmpty = _controller.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        if (_isEmpty)
          const Text(
            StringsApp.username,
            style: TextStyle(
                color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        TextFormField(
          controller: _controller,
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
