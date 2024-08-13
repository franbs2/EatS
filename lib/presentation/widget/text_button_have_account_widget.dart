import 'package:flutter/material.dart';

import '../../core/style/strings_app.dart';

class TextButtonHaveAccountWidget extends StatelessWidget {
  const TextButtonHaveAccountWidget({super.key});

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
          onPressed: () {},
          child: const Text(
            StringsApp.haveAccount,
            style: TextStyle(
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
