import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';

class TextUsernameWidget extends StatefulWidget {
  const TextUsernameWidget({
    super.key,
  });

  @override
  State<TextUsernameWidget> createState() => _TextUsernameWidget();
}

class _TextUsernameWidget extends State<TextUsernameWidget> {
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
