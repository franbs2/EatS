import 'package:flutter/material.dart';

class TextButtonHaveAccountWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const TextButtonHaveAccountWidget(
      {super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade300,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            margin: const EdgeInsets.only(
              left: 30.0,
            ),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xff8D8D8D),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade300,
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            margin: const EdgeInsets.only(right: 30.0),
          ),
        ),
      ],
    );
  }
}
