import 'package:flutter/material.dart';

class TextUsernameWidget extends StatelessWidget {
  final String username;

  const TextUsernameWidget({super.key, this.username = 'Username'});

  @override
  Widget build(BuildContext context) {
    return Text(
      username,
      style: const TextStyle(
        color: Color(0xff624242),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
